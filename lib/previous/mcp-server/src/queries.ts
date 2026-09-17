import { serviceClient } from './supabase';
import { LibraryExercise } from './exerciseMatch';

// The ONLY module that reads Supabase. Every exported function takes the
// token-resolved `userId` as its first argument and scopes to it, because the
// service-role client bypasses RLS. Weights come back canonical (lb) and lengths
// canonical (cm); unit conversion happens in the tool layer.

const num = (v: unknown): number => (v == null ? 0 : Number(v));
const numOrNull = (v: unknown): number | null => (v == null ? null : Number(v));

export interface SetRow {
  sessionId: string;
  exerciseId: string;
  exerciseName: string;
  muscleGroup: string;
  setIndex: number;
  reps: number;
  weightLb: number;
  rpe: number | null;
  setType: string;
}

interface SessionMeta {
  startedAt: string;
  completedAt: string | null;
  name: string | null;
}

/** Global reference data (not user-scoped): id + name + muscle group. */
export async function fetchLibrary(): Promise<LibraryExercise[]> {
  const { data, error } = await serviceClient()
    .from('exercises')
    .select('id, name, muscle_group');
  if (error) throw error;
  return (data ?? []) as LibraryExercise[];
}

/** Session id -> metadata for this user, optionally only since a date. */
export async function userSessionIndex(
  userId: string,
  sinceIso?: string
): Promise<Map<string, SessionMeta>> {
  let q = serviceClient()
    .from('workout_sessions')
    .select('id, started_at, completed_at, routine_name')
    .eq('user_id', userId)
    .order('started_at', { ascending: false });
  if (sinceIso) q = q.gte('started_at', sinceIso);

  const { data, error } = await q;
  if (error) throw error;
  const map = new Map<string, SessionMeta>();
  for (const r of data ?? []) {
    map.set(r.id as string, {
      startedAt: r.started_at as string,
      completedAt: (r.completed_at as string | null) ?? null,
      name: (r.routine_name as string | null) ?? null,
    });
  }
  return map;
}

/** Raw joined sets for a set of session ids (chunked to keep the IN list sane). */
async function setsForSessions(sessionIds: string[], exerciseId?: string): Promise<SetRow[]> {
  if (sessionIds.length === 0) return [];
  const out: SetRow[] = [];
  const CHUNK = 200;
  for (let i = 0; i < sessionIds.length; i += CHUNK) {
    const ids = sessionIds.slice(i, i + CHUNK);
    let q = serviceClient()
      .from('logged_sets')
      .select('session_id, exercise_id, set_index, reps, weight, rpe, set_type, exercises(name, muscle_group)')
      .in('session_id', ids)
      .order('set_index', { ascending: true });
    if (exerciseId) q = q.eq('exercise_id', exerciseId);

    const { data, error } = await q;
    if (error) throw error;
    for (const r of (data ?? []) as any[]) {
      out.push({
        sessionId: r.session_id,
        exerciseId: r.exercise_id,
        exerciseName: r.exercises?.name ?? '(unknown)',
        muscleGroup: r.exercises?.muscle_group ?? 'other',
        setIndex: num(r.set_index),
        reps: num(r.reps),
        weightLb: num(r.weight),
        rpe: numOrNull(r.rpe),
        setType: r.set_type ?? 'normal',
      });
    }
  }
  return out;
}

export interface RecentWorkout {
  sessionId: string;
  name: string | null;
  startedAt: string;
  completedAt: string | null;
  exercises: {
    name: string;
    muscleGroup: string;
    sets: { setIndex: number; weightLb: number; reps: number; rpe: number | null; setType: string }[];
  }[];
}

/** Most recent `limit` sessions, each with its exercises and sets. */
export async function recentWorkouts(userId: string, limit: number): Promise<RecentWorkout[]> {
  const { data, error } = await serviceClient()
    .from('workout_sessions')
    .select('id, routine_name, started_at, completed_at')
    .eq('user_id', userId)
    .order('started_at', { ascending: false })
    .limit(limit);
  if (error) throw error;
  const sessions = data ?? [];
  const sets = await setsForSessions(sessions.map((s) => s.id as string));

  // Group sets by session, then by exercise (preserving first-seen order).
  const bySession = new Map<string, SetRow[]>();
  for (const s of sets) {
    const list = bySession.get(s.sessionId) ?? [];
    list.push(s);
    bySession.set(s.sessionId, list);
  }
  return sessions.map((session) => {
    const rows = bySession.get(session.id as string) ?? [];
    const byExercise = new Map<string, RecentWorkout['exercises'][number]>();
    for (const r of rows) {
      let ex = byExercise.get(r.exerciseId);
      if (!ex) {
        ex = { name: r.exerciseName, muscleGroup: r.muscleGroup, sets: [] };
        byExercise.set(r.exerciseId, ex);
      }
      ex.sets.push({ setIndex: r.setIndex, weightLb: r.weightLb, reps: r.reps, rpe: r.rpe, setType: r.setType });
    }
    return {
      sessionId: session.id as string,
      name: (session.routine_name as string | null) ?? null,
      startedAt: session.started_at as string,
      completedAt: (session.completed_at as string | null) ?? null,
      exercises: Array.from(byExercise.values()),
    };
  });
}

export interface HistorySet {
  date: string;
  weightLb: number;
  reps: number;
  rpe: number | null;
  setType: string;
  sessionId: string;
}

/** Every logged set for one exercise (already matched to a library id), over time. */
export async function exerciseHistory(
  userId: string,
  exerciseId: string,
  sinceIso?: string
): Promise<HistorySet[]> {
  const index = await userSessionIndex(userId, sinceIso);
  const rows = await setsForSessions(Array.from(index.keys()), exerciseId);
  return rows
    .map((r) => ({
      date: index.get(r.sessionId)?.startedAt ?? '',
      weightLb: r.weightLb,
      reps: r.reps,
      rpe: r.rpe,
      setType: r.setType,
      sessionId: r.sessionId,
    }))
    .sort((a, b) => a.date.localeCompare(b.date));
}

export interface PersonalRecord {
  exerciseName: string;
  bestWeightLb: number;
  repsAtBest: number;
  estimated1rmLb: number;
  date: string;
}

/** Heaviest working set per exercise + Epley 1RM off it (warm-ups excluded). */
export async function personalRecords(userId: string): Promise<PersonalRecord[]> {
  const index = await userSessionIndex(userId);
  const rows = await setsForSessions(Array.from(index.keys()));
  const best = new Map<string, { name: string; weightLb: number; reps: number; date: string }>();
  for (const r of rows) {
    if (r.setType === 'warmup') continue;
    const date = index.get(r.sessionId)?.startedAt ?? '';
    const cur = best.get(r.exerciseId);
    // Heavier wins; equal weight -> more reps wins.
    if (!cur || r.weightLb > cur.weightLb || (r.weightLb === cur.weightLb && r.reps > cur.reps)) {
      best.set(r.exerciseId, { name: r.exerciseName, weightLb: r.weightLb, reps: r.reps, date });
    }
  }
  return Array.from(best.values())
    .map((b) => ({
      exerciseName: b.name,
      bestWeightLb: b.weightLb,
      repsAtBest: b.reps,
      // Epley, matching the app: weight x (1 + reps/30), canonical lb.
      estimated1rmLb: Math.round(b.weightLb * (1 + b.reps / 30)),
      date: b.date,
    }))
    .sort((a, b) => a.exerciseName.localeCompare(b.exerciseName));
}

export interface MuscleVolume {
  muscleGroup: string;
  sets: number;
  totalReps: number;
  totalVolumeLb: number;
}

/** Working-set volume by muscle group over the last `days` days. */
export async function trainingVolume(
  userId: string,
  days: number
): Promise<{ byMuscleGroup: MuscleVolume[]; totalSets: number }> {
  const sinceIso = new Date(Date.now() - days * 24 * 60 * 60 * 1000).toISOString();
  const index = await userSessionIndex(userId, sinceIso);
  const rows = await setsForSessions(Array.from(index.keys()));
  const groups = new Map<string, MuscleVolume>();
  let totalSets = 0;
  for (const r of rows) {
    if (r.setType === 'warmup') continue; // volume = working sets
    const key = (r.muscleGroup || 'other').toLowerCase();
    let g = groups.get(key);
    if (!g) {
      g = { muscleGroup: key, sets: 0, totalReps: 0, totalVolumeLb: 0 };
      groups.set(key, g);
    }
    g.sets += 1;
    g.totalReps += r.reps;
    g.totalVolumeLb += r.weightLb * r.reps;
    totalSets += 1;
  }
  const byMuscleGroup = Array.from(groups.values())
    .map((g) => ({ ...g, totalVolumeLb: Math.round(g.totalVolumeLb) }))
    .sort((a, b) => b.totalVolumeLb - a.totalVolumeLb);
  return { byMuscleGroup, totalSets };
}

export interface RawMeasurement {
  type: string;
  date: string;
  // Exactly one of these is set depending on the measurement kind.
  weightLb?: number;
  bodyFatPct?: number;
  valueCm?: number;
}

const CIRCUMFERENCE_TYPES = new Set([
  'neck', 'shoulders', 'chest', 'waist', 'hips',
  'bicep_left', 'bicep_right', 'forearm_left', 'forearm_right',
  'thigh_left', 'thigh_right', 'calf_left', 'calf_right',
]);

/**
 * Body metrics: weight + body-fat from body_measurements, circumferences from
 * body_measurement_entries. `type` optionally filters (accepts an exact enum, or
 * a base like "bicep" matching left+right, or "weight"/"body_fat").
 */
export async function bodyMeasurements(
  userId: string,
  type?: string,
  sinceIso?: string
): Promise<RawMeasurement[]> {
  const wantsWeight = !type || type === 'weight';
  const wantsBodyFat = !type || type === 'body_fat';
  // Circumference set to fetch: exact match, prefix match (e.g. "bicep"), or all.
  const circumferenceMatch = (t: string): boolean => {
    if (type == null) return true;
    if (type === 'weight' || type === 'body_fat') return false;
    return t === type || t.startsWith(`${type}_`);
  };
  const wantsAnyCircumference = !type || (type !== 'weight' && type !== 'body_fat');

  const out: RawMeasurement[] = [];

  if (wantsWeight || wantsBodyFat) {
    let q = serviceClient()
      .from('body_measurements')
      .select('measured_on, weight_lb, body_fat_pct')
      .eq('user_id', userId)
      .order('measured_on', { ascending: true });
    if (sinceIso) q = q.gte('measured_on', sinceIso.slice(0, 10));
    const { data, error } = await q;
    if (error) throw error;
    for (const r of data ?? []) {
      if (wantsWeight && r.weight_lb != null) {
        out.push({ type: 'weight', date: r.measured_on as string, weightLb: num(r.weight_lb) });
      }
      if (wantsBodyFat && r.body_fat_pct != null) {
        out.push({ type: 'body_fat', date: r.measured_on as string, bodyFatPct: num(r.body_fat_pct) });
      }
    }
  }

  if (wantsAnyCircumference) {
    let q = serviceClient()
      .from('body_measurement_entries')
      .select('measurement_type, value_cm, measured_on')
      .eq('user_id', userId)
      .order('measured_on', { ascending: true });
    if (sinceIso) q = q.gte('measured_on', sinceIso.slice(0, 10));
    const { data, error } = await q;
    if (error) throw error;
    for (const r of data ?? []) {
      const mt = r.measurement_type as string;
      if (CIRCUMFERENCE_TYPES.has(mt) && circumferenceMatch(mt)) {
        out.push({ type: mt, date: r.measured_on as string, valueCm: num(r.value_cm) });
      }
    }
  }

  return out.sort((a, b) => a.date.localeCompare(b.date));
}
