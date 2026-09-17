-- Per-user toggle for the RPE (rate of perceived exertion) field on the
-- set-logging screen. When false, the RPE column/input is hidden entirely and
-- the row reclaims that space; existing logged_sets.rpe values are never
-- touched. Defaults to false: RPE is off unless a user turns it on. (Unlike
-- rest_timer_enabled, which defaults true -- RPE is an opt-in advanced field.)
-- No RPE data exists at the time of this migration, so defaulting every row to
-- false disrupts nothing.
alter table public.users
  add column if not exists rpe_tracking_enabled boolean not null default false;
