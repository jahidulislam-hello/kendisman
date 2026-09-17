// Runs on a schedule (Supabase Dashboard Cron Jobs, e.g. every 15 minutes) --
// not tied to any single user's request, so auth here just confirms the
// caller holds a valid project key (verify_jwt = true in config.toml lets
// the cron job authenticate with the anon key). All actual data access uses
// the service-role client below.
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "@supabase/supabase-js";

const WORKOUT_LOOKBACK_DAYS = 400;
const REMINDER_LOCAL_HOUR = 18;
const MILESTONE_STREAKS = [7, 30, 60, 100, 365];

// Mirrors TRIAL_DAYS in mobile/src/lib/trial.ts -- Deno functions can't
// import from mobile/src, so this window is duplicated rather than shared.
const TRIAL_DAYS = 14;
const TRIAL_NUDGE_TEXT = "Your free trial includes unlimited logging -- log another workout before it ends.";

interface UserRow {
  id: string;
  timezone: string;
  push_token: string | null;
  last_reminder_sent_date: string | null;
  last_milestone_streak_notified: number;
  created_at: string;
  subscription_tier: string;
  trial_nudge_sent: boolean;
}

function localDateStr(date: Date, timeZone: string): string {
  // en-CA formats as YYYY-MM-DD, which doubles as our calendar-day key.
  return new Intl.DateTimeFormat("en-CA", { timeZone, year: "numeric", month: "2-digit", day: "2-digit" }).format(
    date
  );
}

function localHour(date: Date, timeZone: string): number {
  const hourStr = new Intl.DateTimeFormat("en-US", { timeZone, hour: "2-digit", hour12: false }).format(date);
  // Some ICU versions render midnight as "24" instead of "00".
  return parseInt(hourStr, 10) % 24;
}

function stepDateBack(dateStr: string): string {
  const [y, m, d] = dateStr.split("-").map(Number);
  const t = Date.UTC(y, m - 1, d) - 24 * 60 * 60 * 1000;
  return new Date(t).toISOString().slice(0, 10);
}

/** Consecutive local calendar days present in dateSet, walking backward from (and including) endDateStr. */
function computeStreakEndingAt(dateSet: Set<string>, endDateStr: string): number {
  let streak = 0;
  let cursor = endDateStr;
  while (dateSet.has(cursor)) {
    streak++;
    cursor = stepDateBack(cursor);
  }
  return streak;
}

function isTrialActive(user: Pick<UserRow, "created_at" | "subscription_tier">, now: Date): boolean {
  if (user.subscription_tier === "premium") return false;
  const trialEnd = new Date(user.created_at).getTime() + TRIAL_DAYS * 24 * 60 * 60 * 1000;
  return now.getTime() < trialEnd;
}

async function sendExpoPush(token: string, title: string, body: string): Promise<boolean> {
  try {
    const res = await fetch("https://exp.host/--/api/v2/push/send", {
      method: "POST",
      headers: { "Content-Type": "application/json", Accept: "application/json" },
      body: JSON.stringify({ to: token, title, body, sound: "default" }),
    });
    if (!res.ok) {
      console.error("Expo push send failed", res.status, await res.text());
      return false;
    }
    return true;
  } catch (error) {
    console.error("Expo push send threw", error);
    return false;
  }
}

Deno.serve(async (_req) => {
  try {
    const supabaseAdmin = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);

    const { data: users, error: usersError } = await supabaseAdmin
      .from("users")
      .select(
        "id, timezone, push_token, last_reminder_sent_date, last_milestone_streak_notified, created_at, subscription_tier, trial_nudge_sent"
      )
      .eq("notifications_enabled", true);

    if (usersError) throw usersError;
    if (!users || users.length === 0) {
      return Response.json({ processed: 0, reminders_sent: 0, milestones_sent: 0, trial_nudges_sent: 0 });
    }

    const userIds = users.map((u) => u.id);
    const lookbackIso = new Date(Date.now() - WORKOUT_LOOKBACK_DAYS * 24 * 60 * 60 * 1000).toISOString();

    const { data: sessions, error: sessionsError } = await supabaseAdmin
      .from("workout_sessions")
      .select("user_id, completed_at")
      .in("user_id", userIds)
      .not("completed_at", "is", null)
      .gte("completed_at", lookbackIso);

    if (sessionsError) throw sessionsError;

    const timezoneByUser = new Map(users.map((u) => [u.id, u.timezone || "UTC"]));
    const datesByUser = new Map<string, Set<string>>();
    // Raw timestamps too (not just calendar-day strings) -- the trial nudge
    // needs to know exactly how long ago the single workout happened, which
    // a calendar-day set can't express precisely.
    const timestampsByUser = new Map<string, string[]>();
    for (const row of sessions ?? []) {
      const tz = timezoneByUser.get(row.user_id) ?? "UTC";
      const day = localDateStr(new Date(row.completed_at as string), tz);
      if (!datesByUser.has(row.user_id)) datesByUser.set(row.user_id, new Set());
      datesByUser.get(row.user_id)!.add(day);
      if (!timestampsByUser.has(row.user_id)) timestampsByUser.set(row.user_id, []);
      timestampsByUser.get(row.user_id)!.push(row.completed_at as string);
    }

    const now = new Date();
    let remindersSent = 0;
    let milestonesSent = 0;
    let trialNudgesSent = 0;
    const errors: string[] = [];

    for (const user of users as UserRow[]) {
      try {
        const tz = user.timezone || "UTC";
        const todayStr = localDateStr(now, tz);
        const hour = localHour(now, tz);
        const workedOutDates = datesByUser.get(user.id) ?? new Set<string>();
        const workedOutToday = workedOutDates.has(todayStr);

        // Reminder / streak-risk check -- only fires around 6pm local time,
        // once per local day (dedup via last_reminder_sent_date).
        if (hour === REMINDER_LOCAL_HOUR && !workedOutToday && user.last_reminder_sent_date !== todayStr) {
          const streakEndingYesterday = computeStreakEndingAt(workedOutDates, stepDateBack(todayStr));
          const body =
            streakEndingYesterday >= 1
              ? `You've worked out ${streakEndingYesterday} day${
                  streakEndingYesterday === 1 ? "" : "s"
                } in a row -- don't break it today!`
              : "Time for today's workout!";

          if (user.push_token) {
            const sent = await sendExpoPush(user.push_token, "Fitzella", body);
            if (sent) remindersSent++;
          }

          const { error } = await supabaseAdmin
            .from("users")
            .update({ last_reminder_sent_date: todayStr })
            .eq("id", user.id);
          if (error) throw error;
        }

        // Milestone check -- fires as soon as today's workout is logged,
        // any time of day, not gated to the 6pm window.
        if (workedOutToday) {
          const streakEndingToday = computeStreakEndingAt(workedOutDates, todayStr);
          if (MILESTONE_STREAKS.includes(streakEndingToday) && streakEndingToday > user.last_milestone_streak_notified) {
            const body = `${streakEndingToday}-day streak! Incredible consistency -- keep it going.`;

            if (user.push_token) {
              const sent = await sendExpoPush(user.push_token, "Fitzella", body);
              if (sent) milestonesSent++;
            }

            const { error } = await supabaseAdmin
              .from("users")
              .update({ last_milestone_streak_notified: streakEndingToday })
              .eq("id", user.id);
            if (error) throw error;
          }
        }

        // Trial nudge -- exactly one workout logged during the active
        // 14-day trial, with 2-3 days since that single workout and no
        // second one logged yet. Not gated to a time-of-day window (unlike
        // the 6pm reminder) since it only needs to fire once, ever, for a
        // given account -- trial_nudge_sent is what prevents a repeat.
        if (!user.trial_nudge_sent && isTrialActive(user, now)) {
          const workoutTimestamps = timestampsByUser.get(user.id) ?? [];
          if (workoutTimestamps.length === 1) {
            const daysSinceOnlyWorkout = Math.floor(
              (now.getTime() - new Date(workoutTimestamps[0]).getTime()) / (24 * 60 * 60 * 1000)
            );
            if (daysSinceOnlyWorkout === 2 || daysSinceOnlyWorkout === 3) {
              if (user.push_token) {
                const sent = await sendExpoPush(user.push_token, "Fitzella", TRIAL_NUDGE_TEXT);
                if (sent) trialNudgesSent++;
              }

              const { error } = await supabaseAdmin
                .from("users")
                .update({ trial_nudge_sent: true })
                .eq("id", user.id);
              if (error) throw error;
            }
          }
        }
      } catch (error) {
        errors.push(`user ${user.id}: ${error instanceof Error ? error.message : String(error)}`);
      }
    }

    return Response.json({
      processed: users.length,
      reminders_sent: remindersSent,
      milestones_sent: milestonesSent,
      trial_nudges_sent: trialNudgesSent,
      errors,
    });
  } catch (error) {
    console.error("send-notifications error:", error);
    return new Response(JSON.stringify({ error: "Internal error" }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
});
