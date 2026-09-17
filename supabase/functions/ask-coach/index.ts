// Step 4: real end-to-end "Ask Coach". The client (mobile/src/screens/AskCoachScreen.tsx)
// inserts the user's message into chat_messages itself (RLS-checked, role='user')
// BEFORE calling this function -- so by the time this runs, chat_messages
// already has the latest turn. This function re-reads that history (rather
// than trusting the request body's `message` for prompt content) so the
// conversation this function sees is always exactly what's persisted.
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "@supabase/supabase-js";
import Anthropic from "@anthropic-ai/sdk";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

const anthropic = new Anthropic({ apiKey: Deno.env.get("ANTHROPIC_API_KEY") });

// AI features are globally disabled for the single-tier (unlimited-logging)
// monetization model. Mirrors mobile/src/lib/featureFlags.ts. Left in place
// (not deleted) so flipping this back re-enables the whole function. Env
// override wins so it can be toggled without a redeploy if needed.
const AI_FEATURES_ENABLED = Deno.env.get("AI_FEATURES_ENABLED") === "true";

// Shared 90-day memory window (matches the AICoachNote spec) for both the
// chat transcript and the workout history used as context -- time-based
// rather than a fixed message/session count, so it doesn't shrink to "the
// last few days" for someone who chats or trains often, and doesn't grow
// unbounded (and blow up prompt size) for a long-tenured user either.
// CHAT_HISTORY_SAFETY_LIMIT is just a ceiling against a pathological case
// (extreme volume within the window) -- not expected to bind normally.
const MEMORY_WINDOW_DAYS = 90;
const CHAT_HISTORY_SAFETY_LIMIT = 500;
const RECENT_COACH_NOTES_LIMIT = 20;

// Mirrors TRIAL_DAYS in mobile/src/lib/trial.ts -- Deno functions can't
// import from mobile/src, so this window is duplicated rather than shared.
// Every new signup gets AI Coach features (including Ask Coach) unlocked
// for this many days from `created_at`, no subscription required.
const TRIAL_DAYS = 14;

function isTrialActive(createdAt: string): boolean {
  const trialEnd = new Date(createdAt).getTime() + TRIAL_DAYS * 24 * 60 * 60 * 1000;
  return Date.now() < trialEnd;
}

interface LoggedSetRow {
  set_index: number;
  reps: number;
  weight: number;
  exercise: { name: string };
  workout_sessions: { id: string; completed_at: string };
}

interface CoachNoteRow {
  reasoning_text: string;
  change_type: string;
  created_at: string;
  exercise: { name: string };
}

interface ChatMessageRow {
  role: "user" | "coach";
  content: string;
}

function formatDate(iso: string): string {
  return new Date(iso).toISOString().slice(0, 10);
}

/** Complete workout history, grouped into one line per exercise per session. */
function summarizeWorkoutHistory(rows: LoggedSetRow[]): string {
  if (rows.length === 0) return "No workouts logged yet.";

  const bySessionExercise = new Map<string, { date: string; exercise: string; sets: LoggedSetRow[] }>();
  for (const row of rows) {
    const key = `${row.workout_sessions.id}:${row.exercise.name}`;
    if (!bySessionExercise.has(key)) {
      bySessionExercise.set(key, {
        date: formatDate(row.workout_sessions.completed_at),
        exercise: row.exercise.name,
        sets: [],
      });
    }
    bySessionExercise.get(key)!.sets.push(row);
  }

  const lines = Array.from(bySessionExercise.values())
    .sort((a, b) => a.date.localeCompare(b.date))
    .map((group) => {
      const sets = group.sets
        .sort((a, b) => a.set_index - b.set_index)
        .map((s) => `${s.reps}@${s.weight}lb`)
        .join(", ");
      return `${group.date}: ${group.exercise} -- ${group.sets.length} sets: ${sets}`;
    });

  return lines.join("\n");
}

/** Recent progression-engine decisions (weight bumps, deloads, holds, etc). */
function summarizeCoachNotes(rows: CoachNoteRow[]): string {
  if (rows.length === 0) return "No progression decisions recorded yet.";
  return rows
    .map((row) => `${formatDate(row.created_at)} ${row.exercise.name} [${row.change_type}]: ${row.reasoning_text}`)
    .join("\n");
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  if (!AI_FEATURES_ENABLED) {
    return new Response(JSON.stringify({ error: "AI Coach is not available." }), {
      status: 503,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }

  try {
    const supabaseClient = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_ANON_KEY")!,
      { global: { headers: { Authorization: req.headers.get("Authorization")! } } }
    );

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

    const { message } = await req.json();
    if (!message || typeof message !== "string") {
      return new Response(JSON.stringify({ error: "Missing 'message' string in request body" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // Real enforcement, not just client-side button hiding -- Ask Coach is
    // an AI Coach feature, unlocked by either a premium subscription or an
    // active 14-day trial (see isTrialActive above). Under the simplified
    // 2-tier model there's no middle "AI Suggests" tier to worry about.
    const { data: profileRow, error: profileError } = await supabaseClient
      .from("users")
      .select("subscription_tier, created_at")
      .eq("id", user.id)
      .single();

    if (profileError || !profileRow) throw profileError ?? new Error("Failed to load subscription tier");

    const hasAiCoachAccess = profileRow.subscription_tier === "premium" || isTrialActive(profileRow.created_at);
    if (!hasAiCoachAccess) {
      return new Response(JSON.stringify({ error: "Ask Coach requires the AI Coach plan." }), {
        status: 403,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // Service role client: privileged reads across the user's full history,
    // and the only path allowed to write a 'coach'-role chat message (RLS
    // blocks that role for the anon-key client entirely -- see the
    // chat_messages migration).
    const supabaseAdmin = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    );

    const memoryWindowStartIso = new Date(Date.now() - MEMORY_WINDOW_DAYS * 24 * 60 * 60 * 1000).toISOString();

    const [loggedSetsResult, coachNotesResult, chatHistoryResult] = await Promise.all([
      supabaseAdmin
        .from("logged_sets")
        .select("set_index, reps, weight, exercise:exercises(name), workout_sessions!inner(id, user_id, completed_at)")
        .eq("workout_sessions.user_id", user.id)
        .not("workout_sessions.completed_at", "is", null)
        .gte("workout_sessions.completed_at", memoryWindowStartIso),
      supabaseAdmin
        .from("ai_coach_notes")
        .select("reasoning_text, change_type, created_at, exercise:exercises(name), workout_sessions!inner(user_id)")
        .eq("workout_sessions.user_id", user.id)
        .order("created_at", { ascending: false })
        .limit(RECENT_COACH_NOTES_LIMIT),
      supabaseAdmin
        .from("chat_messages")
        .select("role, content")
        .eq("user_id", user.id)
        .gte("created_at", memoryWindowStartIso)
        .order("created_at", { ascending: true })
        .limit(CHAT_HISTORY_SAFETY_LIMIT),
    ]);

    if (loggedSetsResult.error) throw loggedSetsResult.error;
    if (coachNotesResult.error) throw coachNotesResult.error;
    if (chatHistoryResult.error) throw chatHistoryResult.error;

    const workoutHistorySummary = summarizeWorkoutHistory(
      (loggedSetsResult.data ?? []) as unknown as LoggedSetRow[]
    );
    const coachNotesSummary = summarizeCoachNotes((coachNotesResult.data ?? []) as unknown as CoachNoteRow[]);

    // Already oldest-first from the query.
    const chatHistory = (chatHistoryResult.data ?? []) as ChatMessageRow[];
    const claudeMessages = chatHistory.map((row) => ({
      role: (row.role === "coach" ? "assistant" : "user") as "assistant" | "user",
      content: row.content,
    }));

    if (claudeMessages.length === 0 || claudeMessages[claudeMessages.length - 1].role !== "user") {
      // Defensive fallback -- should not happen since the client inserts the
      // user's message before calling this function, but don't call Claude
      // with a message list that doesn't end on a user turn.
      claudeMessages.push({ role: "user", content: message });
    }

    const response = await anthropic.messages.create({
      model: "claude-sonnet-5",
      max_tokens: 1024,
      system:
        "You are Fitzella, an AI strength-training coach.\n\n" +
        "FORMATTING -- READ FIRST: your reply is shown in a plain chat bubble with no markdown " +
        "renderer at all. Do not write **asterisks**, _underscores_, `backticks`, #headings, or " +
        "- bullet/numbered lists. If you wrap a word or number in asterisks to 'emphasize' it, " +
        "the literal asterisk characters show up in the user's chat, which looks broken. Write " +
        "plain sentences only, the way you'd send a text message -- use words for emphasis " +
        "(\"jumped to\", \"still stuck at\"), never symbols.\n\n" +
        "Keep replies short and specific, not generic -- reference actual logged exercises, " +
        "weights, and dates from the history below whenever relevant (e.g. \"You missed reps on " +
        "set 3 last Tuesday at 185lb, that's why I dropped volume\" rather than vague " +
        "encouragement).\n\n" +
        `## Workout History (last ${MEMORY_WINDOW_DAYS} days)\n${workoutHistorySummary}\n\n` +
        `## Recent Progression Decisions\n${coachNotesSummary}\n\n` +
        "Reminder: plain text only, no asterisks or other markdown symbols anywhere in your reply.",
      messages: claudeMessages,
    });

    const reply = response.content.find((block) => block.type === "text")?.text ?? "";

    const { data: savedCoachMessage, error: insertError } = await supabaseAdmin
      .from("chat_messages")
      .insert({ user_id: user.id, role: "coach", content: reply })
      .select("id, role, content, created_at")
      .single();

    if (insertError) throw insertError;

    return new Response(JSON.stringify({ message: savedCoachMessage }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (error) {
    console.error("ask-coach error:", error);
    return new Response(JSON.stringify({ error: "Internal error" }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
