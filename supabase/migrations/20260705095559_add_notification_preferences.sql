-- Push notifications: per-user preference + device token.
-- No new RLS policies needed -- the existing users_select_own /
-- users_update_own policies are row-level, so they already cover these
-- new columns for the owning user. The daily-reminder/streak-alert Edge
-- Function (a later step) reads across all users via the service role
-- key, which bypasses RLS entirely, same pattern as ask-coach.

alter table public.users
  add column push_token text,
  add column notifications_enabled boolean not null default true;

comment on column public.users.notifications_enabled is
  'Defaults to true for new users per spec. Existing rows also default to
  true on this migration since the feature did not exist before -- no one
  has actually made a choice to turn it off yet.';
