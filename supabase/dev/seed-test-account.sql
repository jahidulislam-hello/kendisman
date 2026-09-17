-- DEV-ONLY. Not part of the schema seed (supabase/seed.sql), which stays
-- generic so it's safe to run against any fresh project. This one is
-- hardcoded to a specific test account's user id and is meant to be run
-- once, by hand, via:
--   npx supabase db query --linked --file supabase/dev/seed-test-account.sql
--
-- Gives that account one routine with 4 exercises, seeded with past
-- sessions chosen to exercise each branch of the progression engine
-- (packages/progression-engine) so "Today's Workout" shows a real
-- decision instead of an empty state:
--   - Barbell Bench Press: one clean session      -> expect weight_up
--   - Overhead Press:      one session, missed reps -> expect hold
--   - Barbell Back Squat:  2 sessions missed in a row -> expect a deload
--     (volume_down, since 3 sets > 1 to drop)
--   - Barbell Row:         no history yet          -> expect no suggestion,
--     routine's default target shown instead

do $$
declare
  v_user_id uuid := '8b3477c9-6cfc-4b99-ae01-e6623b2b4ecc'; -- vermonski+ironcoach-test@gmail.com
  v_routine_id uuid;
  v_bench_id uuid;
  v_ohp_id uuid;
  v_squat_id uuid;
  v_row_id uuid;
  v_bench_session uuid;
  v_ohp_session uuid;
  v_squat_session_1 uuid;
  v_squat_session_2 uuid;
begin
  select id into v_bench_id from public.exercises where name = 'Barbell Bench Press';
  select id into v_ohp_id   from public.exercises where name = 'Overhead Press';
  select id into v_squat_id from public.exercises where name = 'Barbell Back Squat';
  select id into v_row_id   from public.exercises where name = 'Barbell Row';

  if v_bench_id is null or v_ohp_id is null or v_squat_id is null or v_row_id is null then
    raise exception 'Expected exercises not found -- run supabase/seed.sql first.';
  end if;

  insert into public.routines (user_id, name, is_ai_generated)
  values (v_user_id, 'Full Body A', false)
  returning id into v_routine_id;

  insert into public.routine_exercises (routine_id, exercise_id, order_index, target_sets, target_reps, target_weight)
  values
    (v_routine_id, v_bench_id, 1, 3, 5, 135),
    (v_routine_id, v_ohp_id,   2, 3, 5, 95),
    (v_routine_id, v_squat_id, 3, 3, 5, 185),
    (v_routine_id, v_row_id,   4, 3, 8, 115);

  -- Bench Press: clean session a week ago -> weight_up expected next time.
  insert into public.workout_sessions (user_id, routine_id, started_at, completed_at, mode_at_time)
  values (v_user_id, v_routine_id, now() - interval '7 days', now() - interval '7 days' + interval '45 minutes', 'ai_suggest')
  returning id into v_bench_session;

  insert into public.logged_sets (session_id, exercise_id, set_index, reps, weight, completed_at)
  values
    (v_bench_session, v_bench_id, 1, 5, 135, now() - interval '7 days'),
    (v_bench_session, v_bench_id, 2, 5, 135, now() - interval '7 days'),
    (v_bench_session, v_bench_id, 3, 5, 135, now() - interval '7 days');

  -- Overhead Press: missed reps on 2 of 3 sets a week ago -> hold expected.
  insert into public.workout_sessions (user_id, routine_id, started_at, completed_at, mode_at_time)
  values (v_user_id, v_routine_id, now() - interval '7 days', now() - interval '7 days' + interval '45 minutes', 'ai_suggest')
  returning id into v_ohp_session;

  insert into public.logged_sets (session_id, exercise_id, set_index, reps, weight, completed_at)
  values
    (v_ohp_session, v_ohp_id, 1, 5, 95, now() - interval '7 days'),
    (v_ohp_session, v_ohp_id, 2, 3, 95, now() - interval '7 days'),
    (v_ohp_session, v_ohp_id, 3, 4, 95, now() - interval '7 days');

  -- Back Squat: missed reps 2 sessions running -> deload expected.
  insert into public.workout_sessions (user_id, routine_id, started_at, completed_at, mode_at_time)
  values (v_user_id, v_routine_id, now() - interval '14 days', now() - interval '14 days' + interval '50 minutes', 'ai_suggest')
  returning id into v_squat_session_1;

  insert into public.logged_sets (session_id, exercise_id, set_index, reps, weight, completed_at)
  values
    (v_squat_session_1, v_squat_id, 1, 5, 185, now() - interval '14 days'),
    (v_squat_session_1, v_squat_id, 2, 3, 185, now() - interval '14 days'),
    (v_squat_session_1, v_squat_id, 3, 4, 185, now() - interval '14 days');

  insert into public.workout_sessions (user_id, routine_id, started_at, completed_at, mode_at_time)
  values (v_user_id, v_routine_id, now() - interval '7 days', now() - interval '7 days' + interval '50 minutes', 'ai_suggest')
  returning id into v_squat_session_2;

  insert into public.logged_sets (session_id, exercise_id, set_index, reps, weight, completed_at)
  values
    (v_squat_session_2, v_squat_id, 1, 4, 185, now() - interval '7 days'),
    (v_squat_session_2, v_squat_id, 2, 3, 185, now() - interval '7 days'),
    (v_squat_session_2, v_squat_id, 3, 4, 185, now() - interval '7 days');

  -- Barbell Row: no sessions seeded on purpose -- demonstrates the
  -- no-history path (routine's default target shown, no suggestion).
end $$;
