import { serviceClient } from '../src/supabase';
import {
  fetchLibrary,
  recentWorkouts,
  exerciseHistory,
  personalRecords,
  trainingVolume,
  bodyMeasurements,
} from '../src/queries';
import { matchExercise } from '../src/exerciseMatch';

// Exercises the data layer directly (bypassing HTTP/auth) against a real user, so
// the query + unit logic can be verified without deploying. Usage:
//   npm run tsx scripts/selftest.ts -- <email>  (or: npx tsx scripts/selftest.ts <email>)

async function main() {
  try {
    (process as unknown as { loadEnvFile?: (p: string) => void }).loadEnvFile?.('.env');
  } catch {
    /* optional */
  }
  const email = process.argv[2];
  if (!email) {
    console.error('Usage: npx tsx scripts/selftest.ts <email>');
    process.exit(1);
  }
  const sb = serviceClient();
  const { data: user, error } = await sb.from('users').select('id, unit_preference').eq('email', email).single();
  if (error || !user) {
    console.error(`No user for ${email}: ${error?.message ?? 'not found'}`);
    process.exit(1);
  }
  const uid = user.id as string;
  console.log(`User ${email} · unit_preference=${user.unit_preference}\n`);

  const recent = await recentWorkouts(uid, 3);
  console.log(`recentWorkouts(3): ${recent.length} sessions`);
  for (const w of recent) console.log(`  - ${w.startedAt.slice(0, 10)} "${w.name}" · ${w.exercises.length} exercises`);

  const prs = await personalRecords(uid);
  console.log(`\npersonalRecords: ${prs.length}`);
  for (const p of prs.slice(0, 5)) console.log(`  - ${p.exerciseName}: ${p.bestWeightLb}lb x${p.repsAtBest} (1RM~${p.estimated1rmLb}lb)`);

  const vol = await trainingVolume(uid, 30);
  console.log(`\ntrainingVolume(30): ${vol.totalSets} sets`);
  for (const g of vol.byMuscleGroup) console.log(`  - ${g.muscleGroup}: ${g.sets} sets, ${g.totalVolumeLb}lb volume`);

  const lib = await fetchLibrary();
  const m = matchExercise('bench press', lib);
  console.log(`\nmatch "bench press" -> ${m.matched?.name ?? 'NONE'} (${m.score.toFixed(2)})`);
  if (m.matched) {
    const hist = await exerciseHistory(uid, m.matched.id);
    console.log(`exerciseHistory: ${hist.length} sets`);
  }

  const bm = await bodyMeasurements(uid);
  console.log(`\nbodyMeasurements: ${bm.length} rows`);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
