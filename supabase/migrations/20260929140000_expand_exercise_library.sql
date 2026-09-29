-- Expand the shared exercise library so every muscle group and equipment
-- type the app filters on has real options. Skips any name that already
-- exists, so it is safe to re-run and does not touch existing rows.

insert into public.exercises
  (name, muscle_group, equipment_type, is_custom, primary_muscles, secondary_muscles)
select v.name, v.muscle_group, v.equipment_type, false, v.primary_muscles, v.secondary_muscles
from (values
  -- chest
  ('Incline Barbell Bench Press', 'chest', 'barbell', array['Pectoralis Major (Upper)'], array['Anterior Deltoid', 'Triceps']),
  ('Decline Barbell Bench Press', 'chest', 'barbell', array['Pectoralis Major (Lower)'], array['Triceps', 'Anterior Deltoid']),
  ('Close-Grip Bench Press', 'chest', 'barbell', array['Pectoralis Major', 'Triceps'], array['Anterior Deltoid']),
  ('Dumbbell Bench Press', 'chest', 'dumbbell', array['Pectoralis Major'], array['Anterior Deltoid', 'Triceps']),
  ('Incline Dumbbell Press', 'chest', 'dumbbell', array['Pectoralis Major (Upper)'], array['Anterior Deltoid', 'Triceps']),
  ('Dumbbell Fly', 'chest', 'dumbbell', array['Pectoralis Major'], array['Anterior Deltoid']),
  ('Dumbbell Pullover', 'chest', 'dumbbell', array['Pectoralis Major', 'Latissimus Dorsi'], array['Triceps']),
  ('Machine Chest Press', 'chest', 'machine', array['Pectoralis Major'], array['Anterior Deltoid', 'Triceps']),
  ('Pec Deck', 'chest', 'machine', array['Pectoralis Major'], array['Anterior Deltoid']),
  ('Cable Fly', 'chest', 'cable', array['Pectoralis Major'], array['Anterior Deltoid']),
  ('Low-to-High Cable Fly', 'chest', 'cable', array['Pectoralis Major (Upper)'], array['Anterior Deltoid']),
  ('Chest Dip', 'chest', 'bodyweight', array['Pectoralis Major (Lower)'], array['Triceps', 'Anterior Deltoid']),
  ('Incline Push-Up', 'chest', 'bodyweight', array['Pectoralis Major'], array['Triceps', 'Anterior Deltoid']),
  ('Decline Push-Up', 'chest', 'bodyweight', array['Pectoralis Major (Upper)'], array['Triceps', 'Anterior Deltoid']),

  -- back
  ('Pendlay Row', 'back', 'barbell', array['Latissimus Dorsi', 'Rhomboids'], array['Trapezius', 'Biceps']),
  ('T-Bar Row', 'back', 'barbell', array['Latissimus Dorsi', 'Rhomboids'], array['Trapezius', 'Biceps']),
  ('Rack Pull', 'back', 'barbell', array['Erector Spinae', 'Trapezius'], array['Gluteus Maximus', 'Hamstrings']),
  ('One-Arm Dumbbell Row', 'back', 'dumbbell', array['Latissimus Dorsi'], array['Rhomboids', 'Biceps']),
  ('Chest-Supported Dumbbell Row', 'back', 'dumbbell', array['Rhomboids', 'Latissimus Dorsi'], array['Rear Deltoid', 'Biceps']),
  ('Seated Cable Row', 'back', 'cable', array['Latissimus Dorsi', 'Rhomboids'], array['Biceps', 'Trapezius']),
  ('Close-Grip Lat Pulldown', 'back', 'cable', array['Latissimus Dorsi'], array['Biceps', 'Rhomboids']),
  ('Straight-Arm Pulldown', 'back', 'cable', array['Latissimus Dorsi'], array['Triceps (Long Head)']),
  ('Machine Row', 'back', 'machine', array['Latissimus Dorsi', 'Rhomboids'], array['Biceps']),
  ('Assisted Pull-Up', 'back', 'machine', array['Latissimus Dorsi'], array['Biceps', 'Rhomboids']),
  ('Back Extension', 'back', 'machine', array['Erector Spinae'], array['Gluteus Maximus', 'Hamstrings']),
  ('Chin-Up', 'back', 'bodyweight', array['Latissimus Dorsi', 'Biceps'], array['Rhomboids']),
  ('Inverted Row', 'back', 'bodyweight', array['Latissimus Dorsi', 'Rhomboids'], array['Biceps', 'Rear Deltoid']),

  -- shoulders
  ('Push Press', 'shoulders', 'barbell', array['Anterior Deltoid'], array['Triceps', 'Quadriceps']),
  ('Barbell Upright Row', 'shoulders', 'barbell', array['Lateral Deltoid', 'Trapezius'], array['Biceps']),
  ('Barbell Shrug', 'shoulders', 'barbell', array['Trapezius'], array[]::text[]),
  ('Arnold Press', 'shoulders', 'dumbbell', array['Anterior Deltoid', 'Lateral Deltoid'], array['Triceps']),
  ('Dumbbell Lateral Raise', 'shoulders', 'dumbbell', array['Lateral Deltoid'], array['Trapezius']),
  ('Dumbbell Front Raise', 'shoulders', 'dumbbell', array['Anterior Deltoid'], array[]::text[]),
  ('Dumbbell Rear Delt Fly', 'shoulders', 'dumbbell', array['Rear Deltoid'], array['Rhomboids', 'Trapezius']),
  ('Dumbbell Shrug', 'shoulders', 'dumbbell', array['Trapezius'], array[]::text[]),
  ('Cable Lateral Raise', 'shoulders', 'cable', array['Lateral Deltoid'], array[]::text[]),
  ('Machine Shoulder Press', 'shoulders', 'machine', array['Anterior Deltoid'], array['Triceps', 'Lateral Deltoid']),
  ('Reverse Pec Deck', 'shoulders', 'machine', array['Rear Deltoid'], array['Rhomboids']),
  ('Handstand Push-Up', 'shoulders', 'bodyweight', array['Anterior Deltoid'], array['Triceps', 'Trapezius']),

  -- arms
  ('Barbell Curl', 'arms', 'barbell', array['Biceps'], array['Brachialis', 'Forearms']),
  ('EZ-Bar Curl', 'arms', 'barbell', array['Biceps'], array['Brachialis']),
  ('Skull Crusher', 'arms', 'barbell', array['Triceps'], array[]::text[]),
  ('Hammer Curl', 'arms', 'dumbbell', array['Brachialis', 'Brachioradialis'], array['Biceps']),
  ('Incline Dumbbell Curl', 'arms', 'dumbbell', array['Biceps (Long Head)'], array['Brachialis']),
  ('Concentration Curl', 'arms', 'dumbbell', array['Biceps'], array[]::text[]),
  ('Overhead Dumbbell Tricep Extension', 'arms', 'dumbbell', array['Triceps (Long Head)'], array[]::text[]),
  ('Dumbbell Kickback', 'arms', 'dumbbell', array['Triceps'], array[]::text[]),
  ('Wrist Curl', 'arms', 'dumbbell', array['Forearms'], array[]::text[]),
  ('Cable Curl', 'arms', 'cable', array['Biceps'], array['Brachialis']),
  ('Tricep Pushdown', 'arms', 'cable', array['Triceps'], array[]::text[]),
  ('Rope Pushdown', 'arms', 'cable', array['Triceps'], array[]::text[]),
  ('Overhead Cable Tricep Extension', 'arms', 'cable', array['Triceps (Long Head)'], array[]::text[]),
  ('Preacher Curl Machine', 'arms', 'machine', array['Biceps'], array['Brachialis']),
  ('Diamond Push-Up', 'arms', 'bodyweight', array['Triceps'], array['Pectoralis Major']),
  ('Bench Dip', 'arms', 'bodyweight', array['Triceps'], array['Anterior Deltoid']),

  -- legs
  ('Front Squat', 'legs', 'barbell', array['Quadriceps'], array['Gluteus Maximus', 'Core']),
  ('Barbell Hip Thrust', 'legs', 'barbell', array['Gluteus Maximus'], array['Hamstrings']),
  ('Sumo Deadlift', 'legs', 'barbell', array['Gluteus Maximus', 'Quadriceps'], array['Adductor Magnus', 'Hamstrings']),
  ('Barbell Lunge', 'legs', 'barbell', array['Quadriceps', 'Gluteus Maximus'], array['Hamstrings']),
  ('Goblet Squat', 'legs', 'dumbbell', array['Quadriceps'], array['Gluteus Maximus', 'Core']),
  ('Bulgarian Split Squat', 'legs', 'dumbbell', array['Quadriceps', 'Gluteus Maximus'], array['Hamstrings']),
  ('Dumbbell Romanian Deadlift', 'legs', 'dumbbell', array['Hamstrings'], array['Gluteus Maximus', 'Erector Spinae']),
  ('Dumbbell Step-Up', 'legs', 'dumbbell', array['Quadriceps', 'Gluteus Maximus'], array['Hamstrings']),
  ('Dumbbell Calf Raise', 'legs', 'dumbbell', array['Gastrocnemius'], array['Soleus']),
  ('Hack Squat', 'legs', 'machine', array['Quadriceps'], array['Gluteus Maximus']),
  ('Leg Extension', 'legs', 'machine', array['Quadriceps'], array[]::text[]),
  ('Lying Leg Curl', 'legs', 'machine', array['Hamstrings'], array['Gastrocnemius']),
  ('Seated Leg Curl', 'legs', 'machine', array['Hamstrings'], array[]::text[]),
  ('Standing Calf Raise', 'legs', 'machine', array['Gastrocnemius'], array['Soleus']),
  ('Seated Calf Raise', 'legs', 'machine', array['Soleus'], array['Gastrocnemius']),
  ('Hip Abduction Machine', 'legs', 'machine', array['Gluteus Medius'], array[]::text[]),
  ('Hip Adduction Machine', 'legs', 'machine', array['Adductors'], array[]::text[]),
  ('Cable Pull-Through', 'legs', 'cable', array['Gluteus Maximus', 'Hamstrings'], array[]::text[]),
  ('Cable Glute Kickback', 'legs', 'cable', array['Gluteus Maximus'], array[]::text[]),
  ('Glute Bridge', 'legs', 'bodyweight', array['Gluteus Maximus'], array['Hamstrings']),
  ('Jump Squat', 'legs', 'bodyweight', array['Quadriceps', 'Gluteus Maximus'], array['Gastrocnemius']),
  ('Wall Sit', 'legs', 'bodyweight', array['Quadriceps'], array[]::text[]),

  -- core
  ('Barbell Rollout', 'core', 'barbell', array['Rectus Abdominis'], array['Latissimus Dorsi', 'Obliques']),
  ('Dumbbell Side Bend', 'core', 'dumbbell', array['Obliques'], array[]::text[]),
  ('Russian Twist', 'core', 'dumbbell', array['Obliques'], array['Rectus Abdominis']),
  ('Cable Crunch', 'core', 'cable', array['Rectus Abdominis'], array['Obliques']),
  ('Cable Woodchopper', 'core', 'cable', array['Obliques'], array['Rectus Abdominis']),
  ('Pallof Press', 'core', 'cable', array['Obliques', 'Transverse Abdominis'], array[]::text[]),
  ('Ab Crunch Machine', 'core', 'machine', array['Rectus Abdominis'], array[]::text[]),
  ('Captain''s Chair Leg Raise', 'core', 'machine', array['Rectus Abdominis', 'Hip Flexors'], array['Obliques']),
  ('Crunch', 'core', 'bodyweight', array['Rectus Abdominis'], array[]::text[]),
  ('Hanging Leg Raise', 'core', 'bodyweight', array['Rectus Abdominis', 'Hip Flexors'], array['Obliques']),
  ('Lying Leg Raise', 'core', 'bodyweight', array['Rectus Abdominis', 'Hip Flexors'], array[]::text[]),
  ('Side Plank', 'core', 'bodyweight', array['Obliques'], array['Transverse Abdominis']),
  ('Mountain Climber', 'core', 'bodyweight', array['Rectus Abdominis', 'Hip Flexors'], array['Anterior Deltoid']),
  ('Dead Bug', 'core', 'bodyweight', array['Transverse Abdominis', 'Rectus Abdominis'], array[]::text[]),
  ('Bicycle Crunch', 'core', 'bodyweight', array['Obliques', 'Rectus Abdominis'], array[]::text[])
) as v(name, muscle_group, equipment_type, primary_muscles, secondary_muscles)
where not exists (
  select 1 from public.exercises e
  where lower(e.name) = lower(v.name) and e.is_custom = false
);
