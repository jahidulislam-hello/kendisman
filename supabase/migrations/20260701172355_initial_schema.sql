-- IronCoach initial schema (spec Section 3)
-- Auth identity lives in Supabase's built-in auth.users; public.users is the
-- app-facing profile row (1:1 with auth.users) holding IronCoach-specific settings.

-- ---------------------------------------------------------------------------
-- Enums
-- ---------------------------------------------------------------------------

create type public.user_mode as enum ('manual', 'ai_suggest', 'ai_coach');

-- Tier names only. Real prices are configured in App Store Connect / Play
-- Console / RevenueCat, not in this schema, since pricing isn't locked in yet.
create type public.subscription_tier as enum ('free', 'plus', 'premium');

create type public.unit_preference as enum ('lb', 'kg');

create type public.coach_note_change_type as enum (
  'weight_up',
  'weight_down',
  'volume_up',
  'volume_down',
  'hold',
  'new_exercise'
);

-- ---------------------------------------------------------------------------
-- users (app profile, extends auth.users)
-- ---------------------------------------------------------------------------

create table public.users (
  id uuid primary key references auth.users (id) on delete cascade,
  email text not null,
  auth_provider text not null default 'email',
  mode public.user_mode not null default 'ai_suggest',
  subscription_tier public.subscription_tier not null default 'free',
  unit_preference public.unit_preference not null default 'lb',
  created_at timestamptz not null default now()
);

comment on column public.users.mode is
  'Default is ai_suggest: showcases the AI differentiator immediately, with '
  'approval-before-lock keeping trust risk low (spec Section 8/9).';

-- Auto-create a public.users profile whenever a new auth.users row appears.
create function public.handle_new_auth_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.users (id, email, auth_provider)
  values (
    new.id,
    new.email,
    coalesce(new.raw_app_meta_data ->> 'provider', 'email')
  );
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_auth_user();

-- ---------------------------------------------------------------------------
-- exercises (reference library, shared + user-custom)
-- ---------------------------------------------------------------------------

create table public.exercises (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  muscle_group text not null,
  equipment_type text not null,
  video_url text,
  is_custom boolean not null default false,
  created_by_user_id uuid references public.users (id) on delete set null,
  created_at timestamptz not null default now(),

  constraint custom_exercise_has_creator
    check (is_custom = false or created_by_user_id is not null)
);

create index exercises_created_by_user_id_idx on public.exercises (created_by_user_id);

-- ---------------------------------------------------------------------------
-- routines
-- ---------------------------------------------------------------------------

create table public.routines (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  name text not null,
  is_ai_generated boolean not null default false,
  created_at timestamptz not null default now(),
  last_modified_at timestamptz not null default now()
);

create index routines_user_id_idx on public.routines (user_id);

-- ---------------------------------------------------------------------------
-- routine_exercises
-- ---------------------------------------------------------------------------

create table public.routine_exercises (
  id uuid primary key default gen_random_uuid(),
  routine_id uuid not null references public.routines (id) on delete cascade,
  exercise_id uuid not null references public.exercises (id) on delete restrict,
  order_index integer not null,
  target_sets integer not null,
  target_reps integer not null,
  target_weight numeric(6, 2) not null
);

create index routine_exercises_routine_id_idx on public.routine_exercises (routine_id);
create index routine_exercises_exercise_id_idx on public.routine_exercises (exercise_id);

-- ---------------------------------------------------------------------------
-- workout_sessions
-- ---------------------------------------------------------------------------

create table public.workout_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  routine_id uuid references public.routines (id) on delete set null,
  started_at timestamptz not null default now(),
  completed_at timestamptz,
  mode_at_time public.user_mode not null
);

comment on column public.workout_sessions.mode_at_time is
  'Snapshot of the user''s mode when this session happened, so mode can '
  'change later without rewriting history (spec Section 3 design note) '
  '-- needed to compare retention/progression outcomes across modes.';

create index workout_sessions_user_id_idx on public.workout_sessions (user_id);
create index workout_sessions_routine_id_idx on public.workout_sessions (routine_id);

-- ---------------------------------------------------------------------------
-- logged_sets
-- ---------------------------------------------------------------------------

create table public.logged_sets (
  id uuid primary key default gen_random_uuid(),
  session_id uuid not null references public.workout_sessions (id) on delete cascade,
  exercise_id uuid not null references public.exercises (id) on delete restrict,
  set_index integer not null,
  reps integer not null,
  weight numeric(6, 2) not null,
  rpe numeric(3, 1),
  completed_at timestamptz not null default now()
);

create index logged_sets_session_id_idx on public.logged_sets (session_id);
create index logged_sets_exercise_id_idx on public.logged_sets (exercise_id);

-- ---------------------------------------------------------------------------
-- ai_coach_notes
-- ---------------------------------------------------------------------------

create table public.ai_coach_notes (
  id uuid primary key default gen_random_uuid(),
  session_id uuid not null references public.workout_sessions (id) on delete cascade,
  exercise_id uuid not null references public.exercises (id) on delete restrict,
  reasoning_text text not null,
  change_type public.coach_note_change_type not null,
  created_at timestamptz not null default now()
);

create index ai_coach_notes_session_id_idx on public.ai_coach_notes (session_id);

-- ---------------------------------------------------------------------------
-- Row Level Security — every user only ever sees/writes their own data.
-- Exercise library is readable by everyone (it's a shared reference list);
-- only the owner can write a custom exercise they created.
-- ---------------------------------------------------------------------------

alter table public.users enable row level security;
alter table public.exercises enable row level security;
alter table public.routines enable row level security;
alter table public.routine_exercises enable row level security;
alter table public.workout_sessions enable row level security;
alter table public.logged_sets enable row level security;
alter table public.ai_coach_notes enable row level security;

create policy "users_select_own" on public.users
  for select using (auth.uid() = id);
create policy "users_update_own" on public.users
  for update using (auth.uid() = id);

create policy "exercises_select_all" on public.exercises
  for select using (true);

-- Only custom exercises can be inserted by regular users, and only under
-- their own name. Canonical/reference-library rows (is_custom = false) are
-- seeded by migrations or the service role, which bypasses RLS entirely --
-- there is deliberately no policy letting a regular user create one.
create policy "exercises_insert_own_custom" on public.exercises
  for insert with check (is_custom = true and auth.uid() = created_by_user_id);
create policy "exercises_update_own_custom" on public.exercises
  for update using (is_custom = true and auth.uid() = created_by_user_id);
create policy "exercises_delete_own_custom" on public.exercises
  for delete using (is_custom = true and auth.uid() = created_by_user_id);

create policy "routines_all_own" on public.routines
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "routine_exercises_all_own" on public.routine_exercises
  for all using (
    exists (
      select 1 from public.routines r
      where r.id = routine_exercises.routine_id and r.user_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1 from public.routines r
      where r.id = routine_exercises.routine_id and r.user_id = auth.uid()
    )
  );

create policy "workout_sessions_all_own" on public.workout_sessions
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "logged_sets_all_own" on public.logged_sets
  for all using (
    exists (
      select 1 from public.workout_sessions s
      where s.id = logged_sets.session_id and s.user_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1 from public.workout_sessions s
      where s.id = logged_sets.session_id and s.user_id = auth.uid()
    )
  );

create policy "ai_coach_notes_select_own" on public.ai_coach_notes
  for select using (
    exists (
      select 1 from public.workout_sessions s
      where s.id = ai_coach_notes.session_id and s.user_id = auth.uid()
    )
  );

-- Coach notes are written by the server-side progression engine (service
-- role, which bypasses RLS), not directly by end users, so there is no
-- insert/update/delete policy for regular users here.
