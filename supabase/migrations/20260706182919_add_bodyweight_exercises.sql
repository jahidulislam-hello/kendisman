-- The only bodyweight-equipment exercise in the library so far is Pull-Up
-- (back). Onboarding's "bodyweight only" equipment tier needs real coverage
-- across muscle groups to produce a usable starter program, not a
-- one-exercise routine.

insert into public.exercises (name, muscle_group, equipment_type, is_custom) values
  ('Push-Up', 'chest', 'bodyweight', false),
  ('Bodyweight Squat', 'legs', 'bodyweight', false),
  ('Walking Lunge', 'legs', 'bodyweight', false),
  ('Pike Push-Up', 'shoulders', 'bodyweight', false),
  ('Tricep Dip', 'arms', 'bodyweight', false);
