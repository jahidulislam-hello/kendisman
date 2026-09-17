-- Per-set routine targets: the single-routine editor lets each set carry its
-- own reps/weight (a grid), where routine_exercises only held one uniform
-- target. Additive and backward-compatible -- a routine_exercise with no rows
-- here keeps behaving as N identical sets from the summary columns
-- (target_sets/target_reps*/target_weight, which are retained).

create table public.routine_exercise_sets (
  id uuid primary key default gen_random_uuid(),
  routine_exercise_id uuid not null references public.routine_exercises(id) on delete cascade,
  set_index integer not null,
  target_reps integer,
  target_weight numeric,
  created_at timestamptz not null default now(),
  unique (routine_exercise_id, set_index)
);

create index routine_exercise_sets_re_idx on public.routine_exercise_sets (routine_exercise_id);

alter table public.routine_exercise_sets enable row level security;

-- Owner via routine_exercise -> routine -> user, mirroring routine_exercises_all_own.
create policy "routine_exercise_sets_all_own" on public.routine_exercise_sets
  for all
  using (
    exists (
      select 1
      from public.routine_exercises re
      join public.routines r on r.id = re.routine_id
      where re.id = routine_exercise_sets.routine_exercise_id and r.user_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1
      from public.routine_exercises re
      join public.routines r on r.id = re.routine_id
      where re.id = routine_exercise_sets.routine_exercise_id and r.user_id = auth.uid()
    )
  );
