import { z } from 'zod';
import type { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
import { requireUser, ResolvedUser } from './auth';
import { weightInUnit, weightUnitLabel, lengthInUnit, lengthUnitLabel } from './units';
import {
  fetchLibrary,
  recentWorkouts,
  exerciseHistory,
  personalRecords,
  trainingVolume,
  bodyMeasurements,
} from './queries';
import { matchExercise } from './exerciseMatch';

// Tool registrations for the five read-only Fitzella tools. Every handler resolves
// the user from the request token (requireUser) BEFORE any data access — no tool
// takes a user_id. Weights are returned in the user's unit with the unit named
// explicitly in the payload so ChatGPT never has to guess.

type ToolResult = {
  content: { type: 'text'; text: string }[];
  structuredContent?: Record<string, unknown>;
  isError?: boolean;
};

/** Auth + uniform error handling around a tool body. */
async function guarded(
  extra: { authInfo?: unknown },
  fn: (user: ResolvedUser) => Promise<ToolResult>
): Promise<ToolResult> {
  try {
    const user = requireUser(extra as { authInfo?: any });
    return await fn(user);
  } catch (e) {
    const message = e instanceof Error ? e.message : 'Unexpected error';
    return { content: [{ type: 'text', text: message }], isError: true };
  }
}

const READ_ONLY = { readOnlyHint: true, destructiveHint: false, openWorldHint: false } as const;

export function registerTools(server: McpServer): void {
  // --- 1. get_recent_workouts -------------------------------------------------
  server.registerTool(
    'get_recent_workouts',
    {
      title: 'Get recent workouts',
      description:
        'Return the user\'s most recent workout sessions, each with its exercises and every logged set (weight, reps, RPE, set type). Use for "what did I do recently / last workout" questions.',
      inputSchema: { limit: z.number().int().min(1).max(50).optional().describe('How many recent sessions (default 10).') },
      outputSchema: {
        weight_unit: z.string(),
        workouts: z.array(
          z.object({
            session_id: z.string(),
            name: z.string().nullable(),
            date: z.string(),
            started_at: z.string(),
            completed_at: z.string().nullable(),
            exercises: z.array(
              z.object({
                name: z.string(),
                muscle_group: z.string(),
                sets: z.array(
                  z.object({
                    set_index: z.number(),
                    weight: z.number(),
                    reps: z.number(),
                    rpe: z.number().nullable(),
                    set_type: z.string(),
                  })
                ),
              })
            ),
          })
        ),
      },
      annotations: READ_ONLY,
    },
    async (args, extra) =>
      guarded(extra, async (user) => {
        const unit = weightUnitLabel(user.unitPreference);
        const rows = await recentWorkouts(user.userId, args.limit ?? 10);
        const workouts = rows.map((w) => ({
          session_id: w.sessionId,
          name: w.name,
          date: (w.completedAt ?? w.startedAt).slice(0, 10),
          started_at: w.startedAt,
          completed_at: w.completedAt,
          exercises: w.exercises.map((e) => ({
            name: e.name,
            muscle_group: e.muscleGroup,
            sets: e.sets.map((s) => ({
              set_index: s.setIndex,
              weight: weightInUnit(s.weightLb, user.unitPreference),
              reps: s.reps,
              rpe: s.rpe,
              set_type: s.setType,
            })),
          })),
        }));
        const structuredContent = { weight_unit: unit, workouts };
        const summary = workouts.length
          ? `${workouts.length} recent workout(s), weights in ${unit}. Most recent: "${workouts[0].name ?? 'Workout'}" on ${workouts[0].date}.`
          : 'No workouts logged yet.';
        return { content: [{ type: 'text', text: summary }], structuredContent };
      })
  );

  // --- 2. get_exercise_history -----------------------------------------------
  server.registerTool(
    'get_exercise_history',
    {
      title: 'Get exercise history',
      description:
        'Return every logged set for one exercise over time (for progress/PR-trend questions). The exercise name is fuzzy-matched to the library; if it can\'t be matched confidently, suggestions are returned instead.',
      inputSchema: {
        exercise_name: z.string().describe('Exercise name, e.g. "bench press" or "Barbell Squat".'),
        since: z.string().optional().describe('ISO date; only sets on/after this date. Omit for all time.'),
      },
      outputSchema: {
        matched: z.boolean(),
        exercise: z.object({ matched_name: z.string(), muscle_group: z.string() }).nullable(),
        suggestions: z.array(z.string()).optional(),
        weight_unit: z.string(),
        sets: z.array(
          z.object({
            date: z.string(),
            weight: z.number(),
            reps: z.number(),
            rpe: z.number().nullable(),
            set_type: z.string(),
            session_id: z.string(),
          })
        ),
      },
      annotations: READ_ONLY,
    },
    async (args, extra) =>
      guarded(extra, async (user) => {
        const unit = weightUnitLabel(user.unitPreference);
        const library = await fetchLibrary();
        const match = matchExercise(args.exercise_name, library);
        if (!match.matched) {
          const structuredContent = {
            matched: false,
            exercise: null,
            suggestions: match.suggestions,
            weight_unit: unit,
            sets: [],
          };
          return {
            content: [{ type: 'text', text: `No confident match for "${args.exercise_name}". Did you mean: ${match.suggestions.join(', ')}?` }],
            structuredContent,
          };
        }
        const history = await exerciseHistory(user.userId, match.matched.id, args.since);
        const sets = history.map((h) => ({
          date: h.date.slice(0, 10),
          weight: weightInUnit(h.weightLb, user.unitPreference),
          reps: h.reps,
          rpe: h.rpe,
          set_type: h.setType,
          session_id: h.sessionId,
        }));
        const structuredContent = {
          matched: true,
          exercise: { matched_name: match.matched.name, muscle_group: match.matched.muscle_group },
          weight_unit: unit,
          sets,
        };
        const summary = sets.length
          ? `${sets.length} logged set(s) of "${match.matched.name}" (weights in ${unit}).`
          : `Matched "${match.matched.name}" but no sets logged in that range.`;
        return { content: [{ type: 'text', text: summary }], structuredContent };
      })
  );

  // --- 3. get_personal_records ------------------------------------------------
  server.registerTool(
    'get_personal_records',
    {
      title: 'Get personal records',
      description:
        'Return the best (heaviest) working set per exercise with its reps, plus an estimated one-rep max (Epley). Use for "what are my PRs / best lifts" questions.',
      inputSchema: {},
      outputSchema: {
        weight_unit: z.string(),
        records: z.array(
          z.object({
            exercise_name: z.string(),
            best_weight: z.number(),
            reps_at_best_weight: z.number(),
            estimated_1rm: z.number(),
            date: z.string(),
          })
        ),
      },
      annotations: READ_ONLY,
    },
    async (_args, extra) =>
      guarded(extra, async (user) => {
        const unit = weightUnitLabel(user.unitPreference);
        const prs = await personalRecords(user.userId);
        const records = prs.map((p) => ({
          exercise_name: p.exerciseName,
          best_weight: weightInUnit(p.bestWeightLb, user.unitPreference),
          reps_at_best_weight: p.repsAtBest,
          estimated_1rm: weightInUnit(p.estimated1rmLb, user.unitPreference),
          date: p.date.slice(0, 10),
        }));
        return {
          content: [{ type: 'text', text: `${records.length} personal record(s), weights in ${unit}.` }],
          structuredContent: { weight_unit: unit, records },
        };
      })
  );

  // --- 4. get_training_volume -------------------------------------------------
  server.registerTool(
    'get_training_volume',
    {
      title: 'Get training volume',
      description:
        'Return working-set volume grouped by muscle group over the last N days (sets, total reps, and total weight moved). Warm-up sets are excluded. Use for "how much have I trained chest / weekly volume" questions.',
      inputSchema: { days: z.number().int().min(1).max(365).optional().describe('Window length in days (default 30).') },
      outputSchema: {
        window_days: z.number(),
        weight_unit: z.string(),
        total_sets: z.number(),
        by_muscle_group: z.array(
          z.object({
            muscle_group: z.string(),
            sets: z.number(),
            total_reps: z.number(),
            total_volume: z.number(),
          })
        ),
      },
      annotations: READ_ONLY,
    },
    async (args, extra) =>
      guarded(extra, async (user) => {
        const unit = weightUnitLabel(user.unitPreference);
        const days = args.days ?? 30;
        const { byMuscleGroup, totalSets } = await trainingVolume(user.userId, days);
        const by_muscle_group = byMuscleGroup.map((g) => ({
          muscle_group: g.muscleGroup,
          sets: g.sets,
          total_reps: g.totalReps,
          total_volume: weightInUnit(g.totalVolumeLb, user.unitPreference),
        }));
        return {
          content: [
            {
              type: 'text',
              text: `${totalSets} working set(s) over ${days} days across ${by_muscle_group.length} muscle group(s); volume in ${unit}.`,
            },
          ],
          structuredContent: { window_days: days, weight_unit: unit, total_sets: totalSets, by_muscle_group },
        };
      })
  );

  // --- 5. get_body_measurements ----------------------------------------------
  server.registerTool(
    'get_body_measurements',
    {
      title: 'Get body measurements',
      description:
        'Return body-metric history: bodyweight, body-fat %, and circumferences (neck, chest, waist, arms, legs, etc.). Optionally filter by type. Bodyweight uses the user\'s weight unit; circumferences use their length unit; every row names its unit.',
      inputSchema: {
        type: z
          .string()
          .optional()
          .describe('Optional filter: "weight", "body_fat", an exact type like "waist" or "bicep_left", or a base like "bicep" (matches left+right).'),
        since: z.string().optional().describe('ISO date; only measurements on/after this date.'),
      },
      outputSchema: {
        weight_unit: z.string(),
        length_unit: z.string(),
        measurements: z.array(
          z.object({ type: z.string(), date: z.string(), value: z.number(), unit: z.string() })
        ),
      },
      annotations: READ_ONLY,
    },
    async (args, extra) =>
      guarded(extra, async (user) => {
        const wUnit = weightUnitLabel(user.unitPreference);
        const lUnit = lengthUnitLabel(user.unitPreference);
        const raw = await bodyMeasurements(user.userId, args.type, args.since);
        const measurements = raw.map((m) => {
          if (m.weightLb != null) {
            return { type: m.type, date: m.date, value: weightInUnit(m.weightLb, user.unitPreference), unit: wUnit };
          }
          if (m.bodyFatPct != null) {
            return { type: m.type, date: m.date, value: Math.round(m.bodyFatPct * 10) / 10, unit: '%' };
          }
          return { type: m.type, date: m.date, value: lengthInUnit(m.valueCm ?? 0, user.unitPreference), unit: lUnit };
        });
        return {
          content: [
            { type: 'text', text: `${measurements.length} measurement(s). Weight in ${wUnit}, circumferences in ${lUnit}.` },
          ],
          structuredContent: { weight_unit: wUnit, length_unit: lUnit, measurements },
        };
      })
  );
}
