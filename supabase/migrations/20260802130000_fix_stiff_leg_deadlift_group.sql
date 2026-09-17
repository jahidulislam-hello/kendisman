-- Data fix: "Dumbbell Stiff Leg Deadlift" was tagged muscle_group = 'core' in the
-- imported exercise library. A stiff-leg deadlift is a legs/back hinge, not core.
-- Surfaced by the onboarding generator's selection-quality pass. Guarded +
-- idempotent, and copies the existing canonical casing of the legs value.
update public.exercises
set muscle_group = (
  select muscle_group from public.exercises
  where is_custom = false and lower(muscle_group) = 'legs'
  limit 1
)
where is_custom = false
  and name = 'Dumbbell Stiff Leg Deadlift'
  and lower(muscle_group) = 'core';
