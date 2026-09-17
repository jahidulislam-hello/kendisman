// Generates a starting program from a short questionnaire (goal, days/week,
// experience, equipment). The client always treats the result as a *draft*
// -- it gets routed into the same ProgramBuilderScreen used for manual
// programs, fully editable, and nothing is saved until the user reviews and
// hits Save there (per spec: never force-accept the AI's output as-is).
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

const VALID_GOALS = ["strength", "hypertrophy", "general_fitness"] as const;
const VALID_EXPERIENCE = ["beginner", "intermediate", "advanced"] as const;
type Goal = (typeof VALID_GOALS)[number];
type Experience = (typeof VALID_EXPERIENCE)[number];

interface RequestBody {
  goal: Goal;
  daysPerWeek: number;
  experienceLevel: Experience;
  equipment: string[];
}

interface ExerciseLibraryRow {
  id: string;
  name: string;
  muscle_group: string;
  equipment_type: string;
}

export interface GeneratedExercise {
  exerciseId: string | null;
  exerciseName: string;
  muscleGroup: string;
  equipmentType: string;
  sets: number;
  reps: number;
  weight: number;
}

export interface GeneratedDay {
  name: string;
  exercises: GeneratedExercise[];
}

export interface GeneratedProgram {
  name: string;
  days: GeneratedDay[];
}

interface RawExercise {
  exercise_id?: string | null;
  exercise_name?: string;
  muscle_group?: string | null;
  equipment_type?: string | null;
  sets?: number;
  reps?: number;
  weight?: number;
}

interface RawDay {
  name?: string;
  exercises?: RawExercise[];
}

interface RawProgram {
  name?: string;
  days?: RawDay[];
}

function extractJson(text: string): unknown {
  const trimmed = text.trim();
  try {
    return JSON.parse(trimmed);
  } catch {
    const start = trimmed.indexOf("{");
    const end = trimmed.lastIndexOf("}");
    if (start === -1 || end === -1 || end <= start) {
      throw new Error("No JSON object found in AI response");
    }
    return JSON.parse(trimmed.slice(start, end + 1));
  }
}

/** Defensive cleanup -- an LLM response is untrusted input, not a typed API result. */
function validateAndClean(raw: unknown, validExerciseIds: Set<string>, daysPerWeek: number): GeneratedProgram {
  const program = raw as RawProgram;
  if (!program || typeof program !== "object" || !Array.isArray(program.days)) {
    throw new Error('AI response missing a "days" array');
  }

  const name = typeof program.name === "string" && program.name.trim() ? program.name.trim() : "AI-Generated Program";

  const days: GeneratedDay[] = program.days
    .slice(0, Math.max(daysPerWeek, 1))
    .map((day, i): GeneratedDay => {
      const dayName = typeof day.name === "string" && day.name.trim() ? day.name.trim() : `Day ${i + 1}`;
      const exercises = (Array.isArray(day.exercises) ? day.exercises : [])
        .map((ex): GeneratedExercise | null => {
          const exerciseName =
            typeof ex.exercise_name === "string" && ex.exercise_name.trim() ? ex.exercise_name.trim() : null;
          if (!exerciseName) return null;

          const hasValidId = typeof ex.exercise_id === "string" && validExerciseIds.has(ex.exercise_id);
          return {
            exerciseId: hasValidId ? (ex.exercise_id as string) : null,
            exerciseName,
            muscleGroup: typeof ex.muscle_group === "string" && ex.muscle_group.trim() ? ex.muscle_group.trim() : "general",
            equipmentType:
              typeof ex.equipment_type === "string" && ex.equipment_type.trim() ? ex.equipment_type.trim() : "other",
            sets: Number.isFinite(ex.sets) && (ex.sets as number) > 0 ? Math.round(ex.sets as number) : 3,
            reps: Number.isFinite(ex.reps) && (ex.reps as number) > 0 ? Math.round(ex.reps as number) : 8,
            weight: Number.isFinite(ex.weight) && (ex.weight as number) >= 0 ? (ex.weight as number) : 0,
          };
        })
        .filter((e): e is GeneratedExercise => e !== null);

      return { name: dayName, exercises };
    })
    .filter((day) => day.exercises.length > 0);

  if (days.length === 0) throw new Error("AI response produced no usable days");
  return { name, days };
}

function buildPrompt(body: RequestBody, library: ExerciseLibraryRow[]): { system: string; user: string } {
  const goalGuidance: Record<Goal, string> = {
    strength: "3-5 sets of 3-6 reps on compound lifts, minimal isolation work",
    hypertrophy: "3-4 sets of 8-12 reps, meaningful isolation volume alongside compounds",
    general_fitness: "2-3 sets of 8-12 reps, a balanced mix of compound and isolation movements",
  };

  const system =
    "You are Fitzella's program-generation assistant. Design a complete starting strength program " +
    "using the same conservative, adjust-over-time philosophy as our progression engine: the user's " +
    "actual current strength is unknown, so prescribe safe, beginner-appropriate starting weights they " +
    "can revise after their first real session -- never guess at a personal max. " +
    `Rep/set scheme for this user's stated goal ("${body.goal}"): ${goalGuidance[body.goal]}. ` +
    "Only use equipment the user says they have access to. Prefer reusing an exercise from the " +
    "provided library when a good match exists for the target muscle group and available equipment; " +
    "only invent a new exercise when nothing in the library fits. " +
    "Respond with ONLY raw JSON, no markdown code fences, no commentary before or after, matching " +
    "exactly this shape:\n" +
    '{"name": string, "days": [{"name": string, "exercises": [{"exercise_id": string|null, ' +
    '"exercise_name": string, "muscle_group": string|null, "equipment_type": string|null, ' +
    '"sets": number, "reps": number, "weight": number}]}]}\n' +
    '"muscle_group" and "equipment_type" are required when "exercise_id" is null (a brand-new exercise), ' +
    `and may be null otherwise. Output exactly ${body.daysPerWeek} entries in "days".`;

  const user = JSON.stringify({
    goal: body.goal,
    daysPerWeek: body.daysPerWeek,
    experienceLevel: body.experienceLevel,
    equipmentAvailable: body.equipment,
    exerciseLibrary: library.map((e) => ({
      id: e.id,
      name: e.name,
      muscle_group: e.muscle_group,
      equipment_type: e.equipment_type,
    })),
  });

  return { system, user };
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  if (!AI_FEATURES_ENABLED) {
    return new Response(JSON.stringify({ error: "AI program generation is not available." }), {
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

    const body = (await req.json()) as Partial<RequestBody>;
    if (
      !body.goal ||
      !VALID_GOALS.includes(body.goal) ||
      !body.experienceLevel ||
      !VALID_EXPERIENCE.includes(body.experienceLevel) ||
      !Number.isFinite(body.daysPerWeek) ||
      (body.daysPerWeek as number) < 1 ||
      (body.daysPerWeek as number) > 7 ||
      !Array.isArray(body.equipment)
    ) {
      return new Response(JSON.stringify({ error: "Invalid request body" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }
    const validatedBody = body as RequestBody;

    const { data: library, error: libraryError } = await supabaseClient
      .from("exercises")
      .select("id, name, muscle_group, equipment_type");
    if (libraryError) throw libraryError;

    const { system, user: userPrompt } = buildPrompt(validatedBody, library ?? []);

    const response = await anthropic.messages.create({
      model: "claude-opus-4-8",
      max_tokens: 2048,
      system,
      messages: [{ role: "user", content: userPrompt }],
    });

    const replyText = response.content.find((block) => block.type === "text")?.text ?? "";
    const parsed = extractJson(replyText);
    const validExerciseIds = new Set((library ?? []).map((e) => e.id));
    const program = validateAndClean(parsed, validExerciseIds, validatedBody.daysPerWeek);

    return new Response(JSON.stringify(program), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (error) {
    console.error("generate-program error:", error);
    return new Response(JSON.stringify({ error: "Failed to generate program" }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
