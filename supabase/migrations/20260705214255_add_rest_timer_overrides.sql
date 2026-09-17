-- User-configurable rest timer overrides. The classification-based default
-- (90s compound / 60s isolation, computed client-side from the exercise
-- name) is used whenever neither override below applies.
--
-- rest_timer_default_override_seconds: null means "no global override, use
-- the per-exercise classification default."
--
-- rest_timer_exercise_overrides: exercise_id (as a text key) -> seconds.
-- A JSONB map rather than a separate table -- this is a small, per-user
-- settings dictionary bounded by the size of their exercise library, not an
-- ever-growing log, so it doesn't need its own RLS-protected table.

alter table public.users
  add column rest_timer_default_override_seconds integer,
  add column rest_timer_exercise_overrides jsonb not null default '{}'::jsonb;
