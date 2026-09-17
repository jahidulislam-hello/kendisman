-- Wraps the existing single-routine model in an explicit multi-day
-- "program" concept, so a program can have multiple day-routines (Day 1,
-- Day 2, ...) that rotate across sessions, and "active program" becomes an
-- explicit flag instead of the previous "most recently modified routine"
-- heuristic (see fetchActiveRoutine in mobile/src/lib/workoutData.ts).
--
-- routine_exercises, workout_sessions, logged_sets, ai_coach_notes, and the
-- progression engine are all untouched by this migration -- a "day" is
-- still just a routine row (routines.user_id is kept, not just
-- programs.user_id, so their existing RLS policies and queries keep
-- working unmodified), so all of that machinery continues to work exactly
-- as before.

create table public.programs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  name text not null,
  is_ai_generated boolean not null default false,
  is_active boolean not null default false,
  created_at timestamptz not null default now(),
  last_modified_at timestamptz not null default now()
);

create index programs_user_id_idx on public.programs (user_id);

-- Enforces "at most one active program per user" at the database level --
-- switching programs means deactivating the old one and activating the
-- new one, not just inserting/flagging a new active row.
create unique index programs_one_active_per_user_idx on public.programs (user_id) where is_active;

alter table public.routines
  add column program_id uuid references public.programs (id) on delete cascade,
  add column day_index integer not null default 0;

-- Backfill: wrap each existing routine in its own implicit single-day
-- program (same name, marked active) so current behavior and history are
-- unaffected. Safe to match on (user_id, name, created_at) here because,
-- at the time of this migration, every user has at most one routine.
with new_programs as (
  insert into public.programs (user_id, name, is_ai_generated, is_active, created_at, last_modified_at)
  select user_id, name, is_ai_generated, true, created_at, last_modified_at
  from public.routines
  returning id, user_id, name, created_at
)
update public.routines r
set program_id = np.id
from new_programs np
where np.user_id = r.user_id and np.name = r.name and np.created_at = r.created_at;

alter table public.routines
  alter column program_id set not null;

create index routines_program_id_idx on public.routines (program_id);

alter table public.programs enable row level security;

create policy "programs_all_own" on public.programs
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
