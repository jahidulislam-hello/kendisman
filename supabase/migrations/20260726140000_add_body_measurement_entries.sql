-- Circumference body measurements (neck, chest, arms, legs, etc.), one row per
-- (type, date, value). A long/EAV table rather than 13 sparse columns so each
-- measurement type is its own trackable series with its own trend.
--
-- Purely additive: the existing body_measurements table (weight + body fat) is
-- untouched. Values are stored canonically in CENTIMETRES (like body weight is
-- stored canonically in lb); the client converts to cm or inches at the UI
-- boundary based on the user's kg/lb unit_preference (kg -> cm, lb -> in).
--
-- Left/Right are separate types so asymmetry can be tracked.
create table public.body_measurement_entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  measurement_type text not null check (
    measurement_type in (
      'neck', 'shoulders', 'chest', 'waist', 'hips',
      'bicep_left', 'bicep_right',
      'forearm_left', 'forearm_right',
      'thigh_left', 'thigh_right',
      'calf_left', 'calf_right'
    )
  ),
  value_cm numeric(6, 2) not null check (value_cm > 0),
  measured_on date not null default current_date,
  created_at timestamptz not null default now()
);

create index body_measurement_entries_user_type_date_idx
  on public.body_measurement_entries (user_id, measurement_type, measured_on);

alter table public.body_measurement_entries enable row level security;

create policy "body_measurement_entries_select_own" on public.body_measurement_entries
  for select using (auth.uid() = user_id);
create policy "body_measurement_entries_insert_own" on public.body_measurement_entries
  for insert with check (auth.uid() = user_id);
create policy "body_measurement_entries_update_own" on public.body_measurement_entries
  for update using (auth.uid() = user_id);
create policy "body_measurement_entries_delete_own" on public.body_measurement_entries
  for delete using (auth.uid() = user_id);
