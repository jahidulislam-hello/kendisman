// RevenueCat webhook -> referral reward payout.
//
// This is the server-side half of the referral program and the ONLY place a
// reward is ever granted. It fires when RevenueCat reports a subscription
// event for one of our users; we pay out a referral reward only when that
// event represents a real, money-changing payment for the paid entitlement.
//
// Reward rule (matches the spec):
//   - Trigger on CONVERSION TO PAID, never on signup or trial. We key on
//     period_type === "NORMAL": trial/intro periods are TRIAL/INTRO, and our
//     own promotional grants come back as PROMOTIONAL -- all excluded -- so a
//     free-trial signup or a trial-and-cancel never pays out, and a granted
//     reward can't re-trigger itself.
//   - Both sides get one free month via a RevenueCat promotional entitlement
//     (POST /v1/subscribers/{id}/entitlements/{ent}/promotional, duration
//     "monthly" -- see https://www.revenuecat.com/docs/api-v1).
//   - Idempotent: the reward is claimed with a conditional UPDATE on
//     reward_granted_at IS NULL, so it can be granted at most once per referral
//     no matter how many times the (or a duplicate) event is delivered.
//   - Self-referral is already impossible (blocked at attribution time), and a
//     per-referrer monthly cap (config env) limits abuse.
//
// Gating: REFERRAL_REWARDS_ENABLED must be "true" for any payout. When it's off
// the conversion is still RECORDED (status -> 'converted') so history accrues,
// but nothing is granted -- the matching server-side guard to the client's
// REFERRALS_ENABLED flag, mirroring how the AI edge functions guard themselves.
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "@supabase/supabase-js";

const PAID_ENTITLEMENT = "pro"; // must match purchases.ts UNLIMITED_LOGGING_ENTITLEMENT
const REVENUECAT_API = "https://api.revenuecat.com/v1";

interface RCEvent {
  type?: string;
  app_user_id?: string;
  period_type?: string; // NORMAL | TRIAL | INTRO | PROMOTIONAL
  environment?: string; // PRODUCTION | SANDBOX
  entitlement_id?: string | null;
  entitlement_ids?: string[] | null;
}

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}

// Whether this event is a real paid-period activation of the paid entitlement.
// Covers both subscriptions (INITIAL_PURCHASE/RENEWAL) and the one-time lifetime
// purchase (NON_RENEWING_PURCHASE) -- all real payments carry period_type NORMAL,
// while trials/intros and our own promotional grants (PROMOTIONAL) are excluded.
function isPaidConversion(event: RCEvent): boolean {
  if (event.period_type !== "NORMAL") return false; // excludes TRIAL/INTRO/PROMOTIONAL
  const ents = event.entitlement_ids ?? (event.entitlement_id ? [event.entitlement_id] : []);
  return ents.includes(PAID_ENTITLEMENT);
}

// A real lifetime (non-consumable / one-time) purchase of the paid entitlement.
// RevenueCat sends these as NON_RENEWING_PURCHASE; period_type NORMAL keeps out
// our own PROMOTIONAL referral grants (which are also NON_RENEWING_PURCHASE).
function isLifetimePurchase(event: RCEvent): boolean {
  return event.type === "NON_RENEWING_PURCHASE" && isPaidConversion(event);
}

// app_user_id is our Supabase user id (set as the RevenueCat appUserID). Guard
// against anonymous RC ids so the DB write only ever targets a real user row.
const UUID_RE = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

// Grants a one-month promotional entitlement to a user via the RevenueCat REST
// API. Returns true on success. When no secret key is configured (the current
// pre-launch state -- RevenueCat products/offerings don't exist yet) this is a
// DRY RUN: it logs the intended grant and reports success so the reward ledger
// can still be exercised end to end. Wiring the secret later makes grants real
// with no code change.
async function grantFreeMonth(appUserId: string, secretKey: string | undefined): Promise<boolean> {
  if (!secretKey) {
    console.log(`DRY RUN (no REVENUECAT_SECRET_KEY): would grant 1 month '${PAID_ENTITLEMENT}' to ${appUserId}`);
    return true;
  }
  try {
    const res = await fetch(
      `${REVENUECAT_API}/subscribers/${encodeURIComponent(appUserId)}/entitlements/${PAID_ENTITLEMENT}/promotional`,
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${secretKey}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ duration: "monthly" }),
      },
    );
    if (!res.ok) {
      console.error(`RevenueCat grant failed for ${appUserId}: ${res.status} ${await res.text()}`);
      return false;
    }
    return true;
  } catch (err) {
    console.error(`RevenueCat grant threw for ${appUserId}:`, err);
    return false;
  }
}

Deno.serve(async (req) => {
  if (req.method !== "POST") return json({ error: "Method not allowed" }, 405);

  // Shared-secret auth: RevenueCat sends the Authorization header value
  // configured on the webhook. Reject if it doesn't match (and refuse to run at
  // all if the secret isn't configured, so this can never be an open endpoint).
  const expectedAuth = Deno.env.get("REVENUECAT_WEBHOOK_AUTH");
  if (!expectedAuth || req.headers.get("Authorization") !== expectedAuth) {
    return json({ error: "Unauthorized" }, 401);
  }

  let event: RCEvent;
  try {
    const payload = await req.json();
    event = payload?.event ?? {};
  } catch {
    return json({ error: "Invalid JSON" }, 400);
  }

  const appUserId = event.app_user_id;
  if (!appUserId) return json({ ok: true, skipped: "no app_user_id" });

  // Not a real paid conversion -> ignore (trial start, promo grant, cancellation,
  // wrong entitlement, etc.). This is the core "don't pay out on signup/trial".
  if (!isPaidConversion(event)) {
    return json({ ok: true, skipped: `not a paid conversion (${event.type}/${event.period_type})` });
  }

  const admin = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  // Lifetime (non-consumable) backstop: record premium + is_lifetime durably,
  // server-side, so a reinstall/new-device restore can never strand a paying
  // customer even if the client entitlement sync doesn't run. Idempotent (same
  // values every time). Runs independently of referrals below. Subscriptions are
  // intentionally left to the client sync -- they can lapse, and the client owns
  // the downgrade; a lifetime purchase never lapses, so writing it here is safe.
  if (isLifetimePurchase(event) && UUID_RE.test(appUserId)) {
    const { error: lifeErr } = await admin
      .from("users")
      .update({ subscription_tier: "premium", is_lifetime: true })
      .eq("id", appUserId);
    if (lifeErr) console.error("lifetime backstop write failed:", lifeErr);
  }

  // Was this user referred? If not, nothing more to do.
  const { data: referral, error: findErr } = await admin
    .from("referrals")
    .select("id, referrer_id, referred_id, status, reward_granted_at")
    .eq("referred_id", appUserId)
    .maybeSingle();
  if (findErr) {
    console.error("referral lookup failed:", findErr);
    return json({ error: "lookup failed" }, 500);
  }
  if (!referral) return json({ ok: true, skipped: "user was not referred" });

  // Record the conversion regardless of whether rewards are on (history first).
  if (referral.status === "pending") {
    await admin.from("referrals").update({ status: "converted" }).eq("id", referral.id);
  }

  // Server-side reward gate (mirrors the client REFERRALS_ENABLED flag).
  if (Deno.env.get("REFERRAL_REWARDS_ENABLED") !== "true") {
    return json({ ok: true, converted: true, rewarded: false, reason: "rewards disabled" });
  }

  // Already rewarded? Idempotent no-op.
  if (referral.reward_granted_at) {
    return json({ ok: true, rewarded: true, reason: "already rewarded" });
  }

  // Per-referrer monthly cap (config value).
  const monthlyCap = parseInt(Deno.env.get("REFERRAL_MONTHLY_CAP") ?? "5", 10);
  const monthStart = new Date();
  monthStart.setUTCDate(1);
  monthStart.setUTCHours(0, 0, 0, 0);
  const { count: rewardedThisMonth, error: capErr } = await admin
    .from("referrals")
    .select("id", { count: "exact", head: true })
    .eq("referrer_id", referral.referrer_id)
    .gte("reward_granted_at", monthStart.toISOString());
  if (capErr) {
    console.error("cap check failed:", capErr);
    return json({ error: "cap check failed" }, 500);
  }
  if ((rewardedThisMonth ?? 0) >= monthlyCap) {
    return json({ ok: true, converted: true, rewarded: false, reason: "monthly cap reached" });
  }

  // Atomic claim: flip reward_granted_at from NULL exactly once. A concurrent or
  // duplicate delivery matches zero rows here and falls through as a no-op, so
  // the reward can never be granted twice.
  const { data: claimed, error: claimErr } = await admin
    .from("referrals")
    .update({ status: "rewarded", reward_granted_at: new Date().toISOString() })
    .eq("id", referral.id)
    .is("reward_granted_at", null)
    .select("referrer_id, referred_id")
    .maybeSingle();
  if (claimErr) {
    console.error("reward claim failed:", claimErr);
    return json({ error: "claim failed" }, 500);
  }
  if (!claimed) {
    // Lost the race to another delivery; that one is doing (or did) the grant.
    return json({ ok: true, rewarded: true, reason: "already claimed" });
  }

  // Grant both sides one free month. If either grant fails, release the claim so
  // a webhook retry can try again (RevenueCat retries non-2xx).
  const secretKey = Deno.env.get("REVENUECAT_SECRET_KEY");
  const grantedReferred = await grantFreeMonth(claimed.referred_id, secretKey);
  const grantedReferrer = await grantFreeMonth(claimed.referrer_id, secretKey);
  if (!grantedReferred || !grantedReferrer) {
    await admin
      .from("referrals")
      .update({ status: "converted", reward_granted_at: null })
      .eq("id", referral.id);
    return json({ error: "grant failed; released for retry" }, 500);
  }

  return json({
    ok: true,
    rewarded: true,
    dry_run: !secretKey,
    referrer_id: claimed.referrer_id,
    referred_id: claimed.referred_id,
  });
});
