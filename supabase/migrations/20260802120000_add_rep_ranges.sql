-- Rep ranges for routine_exercises (onboarding rework, Phase 1).
--
-- target_reps stays as the legacy/working target for one release. The new
-- min/max columns are NULLABLE on purpose: the currently-shipped app writes only
-- target_reps, so forcing NOT NULL now would break its program inserts. A later
-- cleanup migration enforces NOT NULL and drops target_reps once every writer
-- (onboarding generator, manual builder, AI path) emits ranges.
alter table public.routine_exercises
  add column if not exists target_reps_min integer,
  add column if not exists target_reps_max integer;

-- Backfill existing rows: a fixed-rep prescription is a degenerate range where
-- min == max == the old target.
update public.routine_exercises
  set target_reps_min = coalesce(target_reps_min, target_reps),
      target_reps_max = coalesce(target_reps_max, target_reps)
  where target_reps_min is null or target_reps_max is null;

-- Guard the range's validity without requiring both columns to be present yet.
alter table public.routine_exercises
  drop constraint if exists routine_exercises_rep_range_valid;
alter table public.routine_exercises
  add constraint routine_exercises_rep_range_valid
    check (
      target_reps_min is null
      or target_reps_max is null
      or (target_reps_min >= 1 and target_reps_max >= target_reps_min)
    );
