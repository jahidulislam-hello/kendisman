-- Rest days as first-class program days.
--
-- `routines` rows are a program's days (ordered by day_index). A rest day is
-- just a day with no exercises and this flag set, so it keeps its place in the
-- rotation instead of being an absence the app has to infer.
alter table public.routines
  add column if not exists is_rest_day boolean not null default false;

comment on column public.routines.is_rest_day is
  'True for a scheduled rest day: no exercises, surfaces the Rest Day screen. '
  'Because a rest day never produces a workout_session, the round-robin day '
  'pointer (completed session count % day count) cannot advance past it on its '
  'own -- fetchActiveRoutine retires one rest day per whole calendar day '
  'elapsed since the last completed session.';
