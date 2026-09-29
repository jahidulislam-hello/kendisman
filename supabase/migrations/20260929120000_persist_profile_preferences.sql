-- Persist remaining profile preferences on the existing own-user profile row.
alter table public.users
  add column if not exists distance_preference text not null default 'mi'
    check (distance_preference in ('mi', 'km')),
  add column if not exists body_measurement_preference text not null default 'in'
    check (body_measurement_preference in ('in', 'cm')),
  add column if not exists notification_days smallint[] not null default array[0, 2, 4]::smallint[],
  add column if not exists language_preference text not null default 'English'
    check (language_preference in ('English', 'Spanish', 'French', 'German', 'Portuguese')),
  add column if not exists timer_sound_preference text not null default 'Default'
    check (timer_sound_preference in ('Default', 'Beep', 'Chime', 'Bell', 'Silent'));

grant update (
  distance_preference,
  body_measurement_preference,
  notification_days,
  language_preference,
  timer_sound_preference
) on public.users to authenticated;
