-- Goals: user-set training targets shown on the Progress > Goals sub-tab.
--
-- Progress is NOT stored -- it's computed client-side from existing data
-- (personal records for strength, body_measurements for body comp, completed
-- workout_sessions for consistency). This table only holds the target itself.
--
-- goal_type:
--   'strength'    -- reach a target working-set weight on one exercise (exercise_id).
--                    target_value is canonical lb. direction is always 'increase'.
--   'body_comp'   -- reach a target body-fat % or body weight (metric).
--                    target_value is % (body_fat) or canonical lb (weight).
--                    start_value is the measurement captured when the goal was
--                    created, so decrease goals can show real progress.
--                    direction is inferred at creation (target below start = decrease).
--   'consistency' -- train N sessions per week. target_value is sessions/week.
--                    Ongoing: no due_date, never auto-completes (recurs weekly).
create table if not exists public.goals (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null references auth.users (id) on delete cascade,
  goal_type    text not null check (goal_type in ('strength', 'body_comp', 'consistency')),
  title        text not null,
  exercise_id  uuid references public.exercises (id) on delete set null,
  metric       text check (metric in ('body_fat', 'weight')),
  target_value numeric not null,
  start_value  numeric,
  direction    text not null default 'increase' check (direction in ('increase', 'decrease')),
  due_date     date,
  status       text not null default 'active' check (status in ('active', 'completed')),
  completed_at timestamptz,
  created_at   timestamptz not null default now()
);

create index if not exists goals_user_status_idx on public.goals (user_id, status);

alter table public.goals enable row level security;

create policy "goals_select_own" on public.goals
  for select using (auth.uid() = user_id);
create policy "goals_insert_own" on public.goals
  for insert with check (auth.uid() = user_id);
create policy "goals_update_own" on public.goals
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "goals_delete_own" on public.goals
  for delete using (auth.uid() = user_id);
