-- Weekday scheduling: assign a routine to each weekday of a program (a plan).
-- A weekday with no row is a rest day. Programs with no plan_schedule rows keep
-- the round-robin "next day" behavior -- this is purely opt-in, no backfill, so
-- existing users are unaffected until they build a schedule.

create table public.plan_schedule (
  id uuid primary key default gen_random_uuid(),
  program_id uuid not null references public.programs(id) on delete cascade,
  weekday smallint not null check (weekday between 0 and 6),  -- 0=Mon .. 6=Sun
  routine_id uuid not null references public.routines(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique (program_id, weekday)
);

create index plan_schedule_program_idx on public.plan_schedule (program_id);

alter table public.plan_schedule enable row level security;

-- Owner via program_id -> programs.user_id (mirrors programs_all_own).
create policy "plan_schedule_all_own" on public.plan_schedule
  for all
  using (
    exists (select 1 from public.programs p where p.id = plan_schedule.program_id and p.user_id = auth.uid())
  )
  with check (
    exists (select 1 from public.programs p where p.id = plan_schedule.program_id and p.user_id = auth.uid())
  );
