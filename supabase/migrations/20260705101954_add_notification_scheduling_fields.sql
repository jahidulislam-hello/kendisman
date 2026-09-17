-- Fields the scheduled reminder/streak-alert Edge Function needs.
--
-- timezone: "6pm" only means something per-user if we know their local
-- time. IANA name (e.g. "America/New_York"), captured client-side via
-- Intl.DateTimeFormat().resolvedOptions().timeZone. Defaults to UTC until
-- the client reports a real value.
--
-- last_reminder_sent_date: the local calendar date (in the user's own
-- timezone) we last sent a daily reminder/streak-risk notification.
-- Prevents duplicate sends if the schedule fires more than once within
-- the same local hour.
--
-- last_milestone_streak_notified: the highest streak length (7, 30, ...)
-- already congratulated, so hitting the same milestone twice (e.g. the
-- job re-checking before the day rolls over) doesn't re-send it.

alter table public.users
  add column timezone text not null default 'UTC',
  add column last_reminder_sent_date date,
  add column last_milestone_streak_notified integer not null default 0;
