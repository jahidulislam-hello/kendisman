-- Dedup flag for the trial nudge push notification: "logged exactly 1
-- workout during the 14-day AI Coach trial, and 2-3 days have passed with
-- no second workout logged." Fires once only, same pattern as
-- last_reminder_sent_date / last_milestone_streak_notified in
-- send-notifications -- a dedicated column rather than deriving "already
-- sent" from anything else, since there's nothing else that would tell the
-- cron job it already fired for this user.
alter table public.users add column trial_nudge_sent boolean not null default false;

comment on column public.users.trial_nudge_sent is
  'Set once the one-time trial nudge push ("Log 2 more workouts...") has '
  'been sent for this user -- see supabase/functions/send-notifications. '
  'Never reset; the nudge only ever fires once per account.';
