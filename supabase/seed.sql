-- Starter reference exercises so the app has something to display before
-- real content/admin tooling exists. Runs via `supabase db reset` / `db seed`,
-- using the service role path (not RLS), same as production seeding would.

insert into public.exercises (name, muscle_group, equipment_type, is_custom) values
  ('Barbell Back Squat', 'legs', 'barbell', false),
  ('Barbell Bench Press', 'chest', 'barbell', false),
  ('Conventional Deadlift', 'back', 'barbell', false),
  ('Overhead Press', 'shoulders', 'barbell', false),
  ('Barbell Row', 'back', 'barbell', false),
  ('Pull-Up', 'back', 'bodyweight', false),
  ('Dumbbell Bicep Curl', 'arms', 'dumbbell', false),
  ('Leg Press', 'legs', 'machine', false);
