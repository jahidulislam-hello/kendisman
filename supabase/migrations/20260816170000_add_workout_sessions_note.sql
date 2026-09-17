-- Free-form per-session note, set from the workout-options menu on the
-- History session-detail screen. Nullable; absent for existing sessions.
alter table public.workout_sessions add column if not exists note text;
