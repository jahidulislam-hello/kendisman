-- Add the 'muscle_gain' goal type. Muscle-gain goals track lean body mass
-- (weight x (1 - bodyfat%)), computed from the same body measurements the app
-- already keeps, so no new tracked column is needed.
alter table public.goals drop constraint goals_goal_type_check;
alter table public.goals add constraint goals_goal_type_check
  check (goal_type = any (array['strength'::text, 'body_comp'::text, 'consistency'::text, 'muscle_gain'::text]));
