-- Demo / dummy data for Home, Workout, Progress, and Profile screens.
-- Idempotent-ish: skips users that already have a "Fitzella Starter" program.
-- Run with:
--   npx supabase db query --linked -f supabase/dev/seed-demo-screens.sql

-- Extra shared exercises (safe if some already exist)
insert into public.exercises (name, muscle_group, equipment_type, is_custom)
select v.name, v.muscle_group, v.equipment_type, false
from (values
  ('Lat Pulldown', 'back', 'machine'),
  ('Dumbbell Shoulder Press', 'shoulders', 'dumbbell'),
  ('Romanian Deadlift', 'legs', 'barbell'),
  ('Cable Face Pull', 'shoulders', 'cable'),
  ('Plank', 'core', 'bodyweight')
) as v(name, muscle_group, equipment_type)
where not exists (
  select 1 from public.exercises e where e.name = v.name
);

do $$
declare
  r record;
  v_program_id uuid;
  v_routine_a uuid;
  v_routine_b uuid;
  v_bench_id uuid;
  v_squat_id uuid;
  v_row_id uuid;
  v_ohp_id uuid;
  v_session uuid;
  v_mode text;
begin
  select id into v_bench_id from public.exercises where name = 'Barbell Bench Press' limit 1;
  select id into v_squat_id from public.exercises where name = 'Barbell Back Squat' limit 1;
  select id into v_row_id from public.exercises where name = 'Barbell Row' limit 1;
  select id into v_ohp_id from public.exercises where name = 'Overhead Press' limit 1;

  -- Prefer current enum value used by the app
  v_mode := 'manual';

  for r in
    select u.id, u.email
    from public.users u
    where not exists (
      select 1 from public.programs p
      where p.user_id = u.id and p.name = 'Fitzella Starter'
    )
  loop
    -- Profile-ish demo fields (only fill blanks)
    update public.users
    set
      username = coalesce(nullif(username, ''), split_part(email, '@', 1)),
      sex = coalesce(sex, 'male'),
      height_cm = coalesce(height_cm, 175),
      date_of_birth = coalesce(date_of_birth, '1998-06-15'),
      unit_preference = coalesce(unit_preference, 'kg'),
      goal = coalesce(goal, 'strength'),
      experience_level = coalesce(experience_level, 'beginner'),
      training_days_per_week = coalesce(training_days_per_week, 3),
      onboarded = true
    where id = r.id;

    insert into public.body_measurements (user_id, measured_on, weight_lb, body_fat_pct)
    select r.id, current_date - (g.n || ' days')::interval, 170 + g.n, 18.5 - (g.n * 0.1)
    from generate_series(0, 14, 7) as g(n)
    where not exists (
      select 1 from public.body_measurements bm
      where bm.user_id = r.id and bm.measured_on = (current_date - (g.n || ' days')::interval)::date
    );

    insert into public.programs (user_id, name, is_ai_generated, is_active)
    values (r.id, 'Fitzella Starter', true, true)
    returning id into v_program_id;

    insert into public.routines (user_id, program_id, name, is_ai_generated, day_index)
    values (r.id, v_program_id, 'Day A — Push / Legs', true, 0)
    returning id into v_routine_a;

    insert into public.routines (user_id, program_id, name, is_ai_generated, day_index)
    values (r.id, v_program_id, 'Day B — Pull / Press', true, 1)
    returning id into v_routine_b;

    if v_bench_id is not null and v_squat_id is not null then
      insert into public.routine_exercises (routine_id, exercise_id, order_index, target_sets, target_reps, target_weight)
      values
        (v_routine_a, v_bench_id, 1, 3, 8, 135),
        (v_routine_a, v_squat_id, 2, 3, 5, 185);
    end if;

    if v_row_id is not null and v_ohp_id is not null then
      insert into public.routine_exercises (routine_id, exercise_id, order_index, target_sets, target_reps, target_weight)
      values
        (v_routine_b, v_row_id, 1, 3, 8, 115),
        (v_routine_b, v_ohp_id, 2, 3, 6, 95);
    end if;

    -- Recent completed workout for Home / Progress history
    if v_bench_id is not null then
      insert into public.workout_sessions (user_id, routine_id, started_at, completed_at, mode_at_time)
      values (
        r.id,
        v_routine_a,
        now() - interval '2 days',
        now() - interval '2 days' + interval '42 minutes',
        v_mode::public.user_mode
      )
      returning id into v_session;

      insert into public.logged_sets (session_id, exercise_id, set_index, reps, weight, completed_at)
      values
        (v_session, v_bench_id, 1, 8, 135, now() - interval '2 days'),
        (v_session, v_bench_id, 2, 8, 135, now() - interval '2 days'),
        (v_session, v_bench_id, 3, 7, 135, now() - interval '2 days');
    end if;

    -- Goals for Progress > Goals
    insert into public.goals (user_id, goal_type, title, exercise_id, target_value, start_value, direction, status)
    values
      (r.id, 'strength', 'Bench 185 lb', v_bench_id, 185, 135, 'increase', 'active'),
      (r.id, 'consistency', 'Train 3x / week', null, 3, null, 'increase', 'active'),
      (r.id, 'body_comp', 'Reach 165 lb', null, 165, 170, 'decrease', 'active');

    update public.goals
    set metric = 'weight'
    where user_id = r.id and goal_type = 'body_comp' and metric is null;
  end loop;
end $$;
