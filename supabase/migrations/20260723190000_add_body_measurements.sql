-- Body measurements: per-user log of body weight (canonical lb, like every
-- other weight in the app) and body-fat %. One row per logged entry; either
-- field may be null but not both. Same per-user RLS scoping as the rest of the
-- schema.
create table public.body_measurements (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  measured_on date not null default current_date,
  weight_lb numeric(6, 2),
  body_fat_pct numeric(4, 1),
  created_at timestamptz not null default now(),
  check (weight_lb is not null or body_fat_pct is not null)
);

create index body_measurements_user_id_measured_on_idx
  on public.body_measurements (user_id, measured_on);

alter table public.body_measurements enable row level security;

create policy "body_measurements_select_own" on public.body_measurements
  for select using (auth.uid() = user_id);
create policy "body_measurements_insert_own" on public.body_measurements
  for insert with check (auth.uid() = user_id);
create policy "body_measurements_update_own" on public.body_measurements
  for update using (auth.uid() = user_id);
create policy "body_measurements_delete_own" on public.body_measurements
  for delete using (auth.uid() = user_id);
