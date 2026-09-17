// sync-entitlement: authoritative, RevenueCat-verified write of a user's paid
// entitlement to public.users.
//
// Why this exists: subscription_tier / is_lifetime are no longer writable by
// the client (see migration 20260728120000). The client used to set its own
// tier straight after a purchase -- which was the same privilege-escalation
// hole as is_reviewer. Now the client asks THIS function to reconcile, and the
// function verifies the entitlement with RevenueCat's REST API (server->RC,
// using the secret key) before writing via the service role. The client's claim
// is never trusted; only RevenueCat's answer is.
//
// It is UPGRADE-ONLY: it writes `premium` (and sticky is_lifetime) when
// RevenueCat confirms an active `pro` entitlement, and otherwise writes nothing.
// Downgrades on lapse/expiry remain the revenuecat-webhook's job, so a transient
// "not active" read here can never strip a valid entitlement.
//
// Auth model mirrors delete-account: gateway verify_jwt is off, and we
// authenticate in-code with the caller's Authorization header so we can trust
// user.id. RevenueCat's app_user_id == the Supabase user id (see
// purchases.ts configurePurchases), so we look the subscriber up by user.id.
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "@supabase/supabase-js";

const PAID_ENTITLEMENT = "pro"; // must match purchases.ts UNLIMITED_LOGGING_ENTITLEMENT
const REVENUECAT_API = "https://api.revenuecat.com/v1";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: corsHeaders });

  // --- Authenticate the caller from their JWT -----------------------------
  const authHeader = req.headers.get("Authorization");
  if (!authHeader) return json({ error: "Unauthorized" }, 401);

  const userClient = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_ANON_KEY")!,
    { global: { headers: { Authorization: authHeader } } },
  );
  const {
    data: { user },
    error: authError,
  } = await userClient.auth.getUser();
  if (authError || !user) return json({ error: "Unauthorized" }, 401);

  // --- Verify the entitlement with RevenueCat -----------------------------
  const secretKey = Deno.env.get("REVENUECAT_SECRET_KEY");
  if (!secretKey) {
    // Can't verify without the secret -> grant nothing. The webhook remains the
    // backstop. Mirrors the webhook's DRY-RUN posture pre-configuration.
    console.log("sync-entitlement: no REVENUECAT_SECRET_KEY; skipping (dry run)");
    return json({ tier: "free", isLifetime: false, verified: false });
  }

  const rcRes = await fetch(
    `${REVENUECAT_API}/subscribers/${encodeURIComponent(user.id)}`,
    { headers: { Authorization: `Bearer ${secretKey}` } },
  );
  if (!rcRes.ok) {
    console.error("sync-entitlement: RevenueCat read failed", rcRes.status);
    return json({ error: "Entitlement check failed" }, 502);
  }

  const body = await rcRes.json();
  const ent = body?.subscriber?.entitlements?.[PAID_ENTITLEMENT];
  // Active if the entitlement exists and hasn't expired. expires_date is an ISO
  // timestamp for subscriptions and null for a lifetime non-consumable (which
  // never expires) -- the same null-means-lifetime signal purchases.ts uses.
  const expires = ent?.expires_date ?? null;
  const isActive = !!ent && (expires === null || Date.parse(expires) > Date.now());
  const isLifetime = isActive && expires === null;

  if (!isActive) {
    // Upgrade-only: never downgrade here (that's the webhook's job).
    return json({ tier: "free", isLifetime: false, verified: true, wrote: false });
  }

  // --- Persist via the service role ---------------------------------------
  const admin = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );
  // is_lifetime is sticky: only ever set true, never cleared. Read current so a
  // subscription-only sync can't wipe a previously-recorded lifetime purchase.
  const { data: current } = await admin
    .from("users")
    .select("is_lifetime")
    .eq("id", user.id)
    .single();
  const nextLifetime = (current?.is_lifetime ?? false) || isLifetime;

  const { error: upErr } = await admin
    .from("users")
    .update({ subscription_tier: "premium", is_lifetime: nextLifetime })
    .eq("id", user.id);
  if (upErr) {
    console.error("sync-entitlement: write failed", upErr);
    return json({ error: "Write failed" }, 500);
  }

  return json({ tier: "premium", isLifetime: nextLifetime, verified: true, wrote: true });
});
