-- Backfill migration for public.workout_supersets.
--
-- This table was originally created directly against the database when superset
-- support was added, so it never had a committed migration. This file
-- reproduces the live definition exactly so the schema is rebuildable from the
-- repo. Every statement is idempotent (guards against already existing), so
-- applying it to the live database -- where the table already exists -- is a
-- safe no-op, while a fresh database gets the full definition.
--
-- One row per exercise that belongs to a superset group within a session:
-- (session_id, exercise_id) is unique, and group_id ties a group's members
-- together. Deleting the session cascades these away (see the FK below), which
-- is what the "Discard workout" flow relies on.

create table if not exists public.workout_supersets (
  id uuid primary key default gen_random_uuid(),
  session_id uuid not null references public.workout_sessions (id) on delete cascade,
  exercise_id uuid not null references public.exercises (id) on delete cascade,
  group_id uuid not null,
  created_at timestamptz not null default now(),
  unique (session_id, exercise_id)
);

create index if not exists workout_supersets_session_id_idx
  on public.workout_supersets (session_id);

alter table public.workout_supersets enable row level security;

-- A user may only touch superset rows for a session they own. SELECT / INSERT /
-- DELETE only -- the client never updates a membership row, it deletes and
-- re-inserts. Guarded via pg_policies so an existing database's policies are
-- left untouched (no drop/recreate on the live DB).
do $$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'workout_supersets'
      and policyname = 'workout_supersets_select_own'
  ) then
    create policy "workout_supersets_select_own" on public.workout_supersets
      for select using (
        exists (
          select 1 from public.workout_sessions ws
          where ws.id = workout_supersets.session_id and ws.user_id = auth.uid()
        )
      );
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'workout_supersets'
      and policyname = 'workout_supersets_insert_own'
  ) then
    create policy "workout_supersets_insert_own" on public.workout_supersets
      for insert with check (
        exists (
          select 1 from public.workout_sessions ws
          where ws.id = workout_supersets.session_id and ws.user_id = auth.uid()
        )
      );
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'workout_supersets'
      and policyname = 'workout_supersets_delete_own'
  ) then
    create policy "workout_supersets_delete_own" on public.workout_supersets
      for delete using (
        exists (
          select 1 from public.workout_sessions ws
          where ws.id = workout_supersets.session_id and ws.user_id = auth.uid()
        )
      );
  end if;
end $$;
