-- Curated program library (the "Programs" feature). Shared, read-only content
-- seeded via SQL/service role -- NOT user-owned like public.programs. Activating
-- a template copies it into the user's own programs/routines/routine_exercises.

create table if not exists public.program_templates (
  id            uuid primary key default gen_random_uuid(),
  slug          text unique not null,
  name          text not null,
  level         text not null check (level in ('Beginner', 'Intermediate', 'Advanced')),
  equipment     text not null check (equipment in ('Gym Equipment', 'Dumbbells', 'Bodyweight')),
  goal          text not null check (goal in ('strength', 'muscle', 'weight_loss')),
  days_per_week int  not null,
  description   text not null,
  cover_photo   text,                         -- object path in the program-covers bucket
  sort_order    int  not null default 0,
  is_published  boolean not null default true,
  created_at    timestamptz not null default now()
);

create table if not exists public.program_template_days (
  id          uuid primary key default gen_random_uuid(),
  template_id uuid not null references public.program_templates (id) on delete cascade,
  day_index   int  not null,
  name        text not null,
  unique (template_id, day_index)
);

create table if not exists public.program_template_exercises (
  id              uuid primary key default gen_random_uuid(),
  day_id          uuid not null references public.program_template_days (id) on delete cascade,
  exercise_id     uuid not null references public.exercises (id),
  order_index     int  not null,
  target_sets     int  not null,
  target_reps_min int  not null,
  target_reps_max int  not null,
  unique (day_id, order_index)
);

create index if not exists program_template_days_template_idx on public.program_template_days (template_id, day_index);
create index if not exists program_template_exercises_day_idx on public.program_template_exercises (day_id, order_index);

-- Read-only library: any signed-in user may browse; writes are service-role only
-- (seeds bypass RLS), so no insert/update/delete policies are defined.
alter table public.program_templates enable row level security;
alter table public.program_template_days enable row level security;
alter table public.program_template_exercises enable row level security;

create policy "program_templates_read" on public.program_templates for select to authenticated using (true);
create policy "program_template_days_read" on public.program_template_days for select to authenticated using (true);
create policy "program_template_exercises_read" on public.program_template_exercises for select to authenticated using (true);
