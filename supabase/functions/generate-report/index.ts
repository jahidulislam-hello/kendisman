// Generates the "AI Coach" weekly analysis: metric scores computed here from
// the user's real logged data (transparent heuristics, no AI), plus a written
// insight + recommendations from Claude grounded in that same data. Gated to
// AI Coach access (premium subscription or active trial), mirroring ask-coach.
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "@supabase/supabase-js";
import Anthropic from "@anthropic-ai/sdk";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

const anthropic = new Anthropic({ apiKey: Deno.env.get("ANTHROPIC_API_KEY") });

// AI features are globally disabled for the single-tier (unlimited-logging)
// monetization model. Mirrors mobile/src/lib/featureFlags.ts. Env override
// wins so it can be re-enabled without a redeploy.
const AI_FEATURES_ENABLED = Deno.env.get("AI_FEATURES_ENABLED") === "true";

const DAY_MS = 24 * 60 * 60 * 1000;
const ANALYSIS_WINDOW_DAYS = 56; // 8 weeks of history feed the scores + prompt
const RECOVERY_FULL_HOURS = 48; // rest hours that read as fully recovered
const TARGET_WORKOUTS_PER_WEEK = 4;
const LB_PER_KG = 2.20462262;

// Mirrors TRIAL_DAYS in mobile/src/lib/trial.ts.
const TRIAL_DAYS = 14;
function isTrialActive(createdAt: string): boolean {
  return Date.now() < new Date(createdAt).getTime() + TRIAL_DAYS * DAY_MS;
}

interface SetRow {
  reps: number;
  weight: number;
  exercise: { name: string };
  workout_sessions: { id: string; completed_at: string };
}

interface Scores {
  strength: number;
  volume: number;
  recovery: number;
  consistency: number;
  overall: number;
}

function clamp(n: number, lo = 0, hi = 100): number {
  return Math.max(lo, Math.min(hi, n));
}

function localDayKey(ms: number): string {
  return new Date(ms).toISOString().slice(0, 10);
}

/** All metric scores (0-100), computed from real logged sets. */
function computeScores(rows: SetRow[]): Scores {
  const now = Date.now();

  const sessionVolume = new Map<string, { t: number; vol: number }>();
  const exerciseTops = new Map<string, { t: number; top: number }[]>();
  const perExerciseSession = new Map<string, { ex: string; t: number; top: number }>();

  for (const r of rows) {
    const sid = r.workout_sessions.id;
    const t = new Date(r.workout_sessions.completed_at).getTime();
    if (!sessionVolume.has(sid)) sessionVolume.set(sid, { t, vol: 0 });
    sessionVolume.get(sid)!.vol += r.reps * r.weight;

    const exKey = `${r.exercise.name}:${sid}`;
    if (!perExerciseSession.has(exKey)) perExerciseSession.set(exKey, { ex: r.exercise.name, t, top: 0 });
    const es = perExerciseSession.get(exKey)!;
    if (r.weight > es.top) es.top = r.weight;
  }
  for (const { ex, t, top } of perExerciseSession.values()) {
    if (!exerciseTops.has(ex)) exerciseTops.set(ex, []);
    exerciseTops.get(ex)!.push({ t, top });
  }

  // Volume: this 7-day window vs the prior 7-day window.
  let volThis = 0;
  let volLast = 0;
  let lastSessionT = 0;
  const daysLast7 = new Set<string>();
  for (const { t, vol } of sessionVolume.values()) {
    const age = now - t;
    if (age < 7 * DAY_MS) {
      volThis += vol;
      daysLast7.add(localDayKey(t));
    } else if (age < 14 * DAY_MS) {
      volLast += vol;
    }
    if (t > lastSessionT) lastSessionT = t;
  }

  let volume: number;
  if (volLast === 0) volume = volThis > 0 ? 72 : 45;
  else volume = clamp(Math.round(50 + (volThis / volLast - 1) * 80));

  // Consistency: distinct training days in the last week vs target frequency.
  const consistency = clamp(Math.round((daysLast7.size / TARGET_WORKOUTS_PER_WEEK) * 100));

  // Recovery: rest hours since the last session, ramping to full over 48h.
  const recovery =
    lastSessionT === 0 ? 100 : clamp(Math.round(((now - lastSessionT) / (60 * 60 * 1000) / RECOVERY_FULL_HOURS) * 100));

  // Strength: share of exercises whose top weight has climbed across the window.
  const repeated = [...exerciseTops.values()].filter((list) => list.length >= 2);
  let strength: number;
  if (repeated.length === 0) strength = 55;
  else {
    const progressing = repeated.filter((list) => {
      const sorted = [...list].sort((a, b) => a.t - b.t);
      return sorted[sorted.length - 1].top > sorted[0].top;
    }).length;
    strength = Math.round((progressing / repeated.length) * 100);
  }

  const overall = Math.round((strength + volume + recovery + consistency) / 4);
  return { strength, volume, recovery, consistency, overall };
}

/** Compact per-session-per-exercise history for the prompt (weights in lb). */
function summarize(rows: SetRow[]): string {
  const byGroup = new Map<string, { date: string; exercise: string; sets: SetRow[] }>();
  for (const r of rows) {
    const key = `${r.workout_sessions.id}:${r.exercise.name}`;
    if (!byGroup.has(key)) {
      byGroup.set(key, { date: r.workout_sessions.completed_at.slice(0, 10), exercise: r.exercise.name, sets: [] });
    }
    byGroup.get(key)!.sets.push(r);
  }
  return [...byGroup.values()]
    .sort((a, b) => a.date.localeCompare(b.date))
    .map((g) => `${g.date}: ${g.exercise} -- ${g.sets.map((s) => `${s.reps}@${s.weight}lb`).join(", ")}`)
    .join("\n");
}

function extractJson(text: string): unknown {
  const trimmed = text.trim();
  try {
    return JSON.parse(trimmed);
  } catch {
    const start = trimmed.indexOf("{");
    const end = trimmed.lastIndexOf("}");
    if (start === -1 || end === -1 || end <= start) throw new Error("No JSON object in AI response");
    return JSON.parse(trimmed.slice(start, end + 1));
  }
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: corsHeaders });

  if (!AI_FEATURES_ENABLED) {
    return new Response(JSON.stringify({ error: "The AI Coach report is not available." }), {
      status: 503,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }

  try {
    const supabaseClient = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_ANON_KEY")!, {
      global: { headers: { Authorization: req.headers.get("Authorization")! } },
    });

    const {
      data: { user },
      error: authError,
    } = await supabaseClient.auth.getUser();
    if (authError || !user) {
      return new Response(JSON.stringify({ error: "Unauthorized" }), {
        status: 401,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const { data: profileRow, error: profileError } = await supabaseClient
      .from("users")
      .select("subscription_tier, created_at, unit_preference")
      .eq("id", user.id)
      .single();
    if (profileError || !profileRow) throw profileError ?? new Error("Failed to load profile");

    const hasAiCoachAccess = profileRow.subscription_tier === "premium" || isTrialActive(profileRow.created_at);
    if (!hasAiCoachAccess) {
      return new Response(JSON.stringify({ error: "The AI Coach report requires the AI Coach plan." }), {
        status: 403,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const supabaseAdmin = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
    const windowStartIso = new Date(Date.now() - ANALYSIS_WINDOW_DAYS * DAY_MS).toISOString();

    const { data: setsData, error: setsError } = await supabaseAdmin
      .from("logged_sets")
      .select("reps, weight, exercise:exercises(name), workout_sessions!inner(id, user_id, completed_at)")
      .eq("workout_sessions.user_id", user.id)
      .not("workout_sessions.completed_at", "is", null)
      .gte("workout_sessions.completed_at", windowStartIso);
    if (setsError) throw setsError;

    const rows = (setsData ?? []) as unknown as SetRow[];
    const sessionCount = new Set(rows.map((r) => r.workout_sessions.id)).size;

    // Nothing logged yet -- no scores to compute, no point calling Claude.
    if (rows.length === 0) {
      return new Response(
        JSON.stringify({
          scores: { strength: 0, volume: 0, recovery: 100, consistency: 0, overall: 0 },
          insight: "Log your first few workouts and your AI Coach will analyze your training here.",
          recommendations: [],
          generatedAt: new Date().toISOString(),
          hasData: false,
        }),
        { headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const scores = computeScores(rows);
    const unit = profileRow.unit_preference === "kg" ? "kg" : "lb";

    // The scores above are real and don't depend on Claude -- so the AI text
    // is best-effort. If the model call fails (rate limit, outage, no API
    // credits), still return the scores with a clear "insight unavailable"
    // note rather than failing the whole report.
    let insight = "";
    let recommendations: string[] = [];
    try {
      const response = await anthropic.messages.create({
        model: "claude-sonnet-5",
        max_tokens: 700,
        system:
          "You are Fitzella, an AI strength-training coach writing a short weekly analysis for one user. " +
          "Ground everything in the real data below -- reference actual exercises, weights, and dates. Be " +
          "specific, not generic. No markdown symbols (no asterisks, backticks, headings, or bullets) inside " +
          `any string. The user records weight in ${unit}; the history below is in lb, so convert to ${unit} ` +
          `(1 kg = ${LB_PER_KG} lb) when you mention any weight.\n\n` +
          `Computed scores (0-100): strength ${scores.strength}, volume ${scores.volume}, recovery ` +
          `${scores.recovery}, consistency ${scores.consistency}, overall ${scores.overall}. ` +
          `Sessions in the last ${ANALYSIS_WINDOW_DAYS} days: ${sessionCount}.\n\n` +
          `Workout history (last ${ANALYSIS_WINDOW_DAYS} days):\n${summarize(rows)}\n\n` +
          'Respond with ONLY a JSON object of this exact shape: {"insight": string, "recommendations": string[]}. ' +
          "insight is 2-3 plain sentences interpreting the scores and trend. recommendations is 2-3 short, " +
          "concrete next actions (each one sentence). If the data is sparse, say so honestly in the insight " +
          "rather than inventing progress.",
        messages: [{ role: "user", content: "Generate my weekly analysis." }],
      });

      const replyText = response.content.find((block) => block.type === "text")?.text ?? "";
      const parsed = extractJson(replyText) as { insight?: unknown; recommendations?: unknown };
      insight = typeof parsed.insight === "string" ? parsed.insight : "";
      recommendations = Array.isArray(parsed.recommendations)
        ? parsed.recommendations.filter((r): r is string => typeof r === "string").slice(0, 4)
        : [];
    } catch (aiError) {
      console.error("generate-report AI step failed:", aiError);
      insight = "Your written analysis is temporarily unavailable, but your scores above are up to date.";
    }

    return new Response(
      JSON.stringify({ scores, insight, recommendations, generatedAt: new Date().toISOString(), hasData: true }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (error) {
    console.error("generate-report error:", error);
    return new Response(JSON.stringify({ error: "Failed to generate your analysis. Try again." }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
