-- Fitzella core schema: profiles + programs + auth trigger
-- Applied against project wpknvsnroppszmkofmdk

create extension if not exists "pgcrypto";

-- ---------------------------------------------------------------------------
-- users (app profile; id matches auth.users.id)
-- ---------------------------------------------------------------------------
create table if not exists public.users (
  id uuid primary key references auth.users (id) on delete cascade,
  email text not null,
  mode text not null default 'manual',
  subscription_tier text not null default 'free',
  unit_preference text not null default 'kg',
  theme_preference text not null default 'system',
  sex text,
  username text,
  date_of_birth date,
  height_cm integer,
  photo_url text,
  created_at timestamptz not null default now(),
  push_token text,
  notifications_enabled boolean not null default true,
  rest_timer_default_override_seconds integer,
  rest_timer_exercise_overrides jsonb not null default '{}'::jsonb,
  rest_timer_enabled boolean not null default true,
  rpe_tracking_enabled boolean not null default false,
  trial_nudge_sent boolean not null default false,
  is_reviewer boolean not null default false,
  referral_code text not null default encode(gen_random_bytes(4), 'hex'),
  is_lifetime boolean not null default false,
  goal text,
  experience_level text,
  training_days_per_week integer,
  email_opt_in boolean not null default false,
  referral_source text,
  onboarded boolean not null default false
);

create unique index if not exists users_username_unique
  on public.users (lower(username))
  where username is not null;

create unique index if not exists users_referral_code_unique
  on public.users (referral_code);

-- ---------------------------------------------------------------------------
-- programs
-- ---------------------------------------------------------------------------
create table if not exists public.programs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  name text not null,
  is_ai_generated boolean not null default false,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create index if not exists programs_user_id_idx on public.programs (user_id);

-- ---------------------------------------------------------------------------
-- Auto-create profile row when a user signs up
-- ---------------------------------------------------------------------------
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.users (id, email)
  values (new.id, coalesce(new.email, ''))
  on conflict (id) do update
    set email = excluded.email;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- Backfill profiles for existing auth users
insert into public.users (id, email)
select id, coalesce(email, '')
from auth.users
on conflict (id) do nothing;

-- ---------------------------------------------------------------------------
-- RLS
-- ---------------------------------------------------------------------------
alter table public.users enable row level security;
alter table public.programs enable row level security;

drop policy if exists "users_select_own" on public.users;
create policy "users_select_own"
  on public.users for select
  using (auth.uid() = id);

drop policy if exists "users_update_own" on public.users;
create policy "users_update_own"
  on public.users for update
  using (auth.uid() = id)
  with check (auth.uid() = id);

drop policy if exists "users_insert_own" on public.users;
create policy "users_insert_own"
  on public.users for insert
  with check (auth.uid() = id);

drop policy if exists "programs_select_own" on public.programs;
create policy "programs_select_own"
  on public.programs for select
  using (auth.uid() = user_id);

drop policy if exists "programs_insert_own" on public.programs;
create policy "programs_insert_own"
  on public.programs for insert
  with check (auth.uid() = user_id);

drop policy if exists "programs_update_own" on public.programs;
create policy "programs_update_own"
  on public.programs for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "programs_delete_own" on public.programs;
create policy "programs_delete_own"
  on public.programs for delete
  using (auth.uid() = user_id);

grant usage on schema public to anon, authenticated;
grant select, insert, update on public.users to authenticated;
grant select, insert, update, delete on public.programs to authenticated;
