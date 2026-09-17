-- Per-user toggle to disable the rest timer entirely. When false, logging a
-- set does not open the countdown and the manual launch is hidden. Defaults to
-- true so existing accounts keep their current behaviour.
alter table public.users
  add column if not exists rest_timer_enabled boolean not null default true;
