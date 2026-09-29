-- DEV-ONLY. Removes the dummy rows inserted by supabase/dev/seed-demo-screens.sql.
-- Only rows that match the seed's exact values are touched, so real user data
-- logged later (even on the "Fitzella Starter" program) is kept.
--
-- Run in the Supabase dashboard SQL Editor (runs as postgres, bypasses RLS).
-- Step A: run the PREVIEW block alone and check the counts.
-- Step B: run the DELETE block.

-- ---------------------------------------------------------------------------
-- PREVIEW
-- ---------------------------------------------------------------------------
with starter_routines as (
  select r.id
  from public.routines r
  join public.programs p on p.id = r.program_id
  where p.name = 'Fitzella Starter'
    and r.name in ('Day A — Push / Legs', 'Day B — Pull / Press')
)
select
  (select count(*) from public.workout_sessions s
     where s.routine_id in (select id from starter_routines)
       and s.completed_at - s.started_at = interval '42 minutes'
       and not exists (
         select 1 from public.logged_sets ls
         where ls.session_id = s.id
           and not (ls.set_index in (1, 2, 3) and ls.weight = 135 and ls.reps in (7, 8))
       )) as demo_sessions,
  (select count(*) from public.goals
     where (goal_type, title) in (('strength', 'Bench 185 lb'),
                                  ('consistency', 'Train 3x / week'),
                                  ('body_comp', 'Reach 165 lb'))) as demo_goals,
  (select count(*) from public.body_measurements
     where (weight_lb, body_fat_pct) in ((170, 18.5), (177, 17.8), (184, 17.1))) as demo_measurements,
  (select count(*) from public.programs
     where name = 'Fitzella Starter' and is_ai_generated) as demo_programs;

-- ---------------------------------------------------------------------------
-- DELETE
-- ---------------------------------------------------------------------------
begin;

-- Sessions first: deleting the program would only null their routine_id.
-- logged_sets cascade with the session.
delete from public.workout_sessions s
where s.routine_id in (
    select r.id
    from public.routines r
    join public.programs p on p.id = r.program_id
    where p.name = 'Fitzella Starter'
      and r.name in ('Day A — Push / Legs', 'Day B — Pull / Press')
  )
  and s.completed_at - s.started_at = interval '42 minutes'
  and not exists (
    select 1 from public.logged_sets ls
    where ls.session_id = s.id
      and not (ls.set_index in (1, 2, 3) and ls.weight = 135 and ls.reps in (7, 8))
  );

delete from public.goals
where (goal_type, title) in (('strength', 'Bench 185 lb'),
                             ('consistency', 'Train 3x / week'),
                             ('body_comp', 'Reach 165 lb'));

delete from public.body_measurements
where (weight_lb, body_fat_pct) in ((170, 18.5), (177, 17.8), (184, 17.1));

-- routines, routine_exercises and plan_schedule cascade with the program.
-- Any real session logged on these routines keeps its denormalized
-- routine_name and just loses the routine link.
delete from public.programs
where name = 'Fitzella Starter' and is_ai_generated;

commit;
