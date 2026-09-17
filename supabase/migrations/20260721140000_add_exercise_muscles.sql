-- Richer per-exercise muscle data: primary + secondary movers, stored as
-- text[] on the exercises table (display-only reference data for the Exercise
-- Detail and how-to screens). The existing single `muscle_group` column is
-- left untouched -- MuscleBody and the exercise library still key off it; these
-- arrays are the more granular anatomical breakdown shown alongside it.
alter table public.exercises
  add column if not exists primary_muscles   text[] not null default '{}',
  add column if not exists secondary_muscles text[] not null default '{}';

update public.exercises set
  primary_muscles   = array['Quadriceps'],
  secondary_muscles = array['Gluteus Maximus','Hamstrings','Erector Spinae','Adductor Magnus']
where name = 'Barbell Back Squat';

update public.exercises set
  primary_muscles   = array['Pectoralis Major Sternal Head'],
  secondary_muscles = array['Deltoid Anterior','Pectoralis Major Clavicular Head','Triceps Brachii']
where name = 'Barbell Bench Press';

update public.exercises set
  primary_muscles   = array['Latissimus Dorsi'],
  secondary_muscles = array['Trapezius Middle','Rhomboids','Biceps Brachii','Deltoid Posterior']
where name = 'Barbell Row';

update public.exercises set
  primary_muscles   = array['Quadriceps'],
  secondary_muscles = array['Gluteus Maximus','Hamstrings','Adductor Magnus']
where name = 'Bodyweight Squat';

update public.exercises set
  primary_muscles   = array['Erector Spinae','Gluteus Maximus'],
  secondary_muscles = array['Hamstrings','Quadriceps','Trapezius','Latissimus Dorsi','Forearm Flexors']
where name = 'Conventional Deadlift';

update public.exercises set
  primary_muscles   = array['Biceps Brachii'],
  secondary_muscles = array['Brachialis','Brachioradialis']
where name = 'Dumbbell Bicep Curl';

update public.exercises set
  primary_muscles   = array['Pectoralis Major Clavicular Head'],
  secondary_muscles = array['Deltoid Anterior','Triceps Brachii']
where name = 'Dumbbell Incline Press';

update public.exercises set
  primary_muscles   = array['Deltoid Lateral'],
  secondary_muscles = array['Deltoid Anterior','Trapezius Upper','Supraspinatus']
where name = 'Dumbbell Lateral Raise';

update public.exercises set
  primary_muscles   = array['Triceps Brachii'],
  secondary_muscles = array['Anconeus']
where name = 'Dumbbell Triceps Extension';

update public.exercises set
  primary_muscles   = array['Latissimus Dorsi'],
  secondary_muscles = array['Biceps Brachii','Trapezius Middle','Rhomboids','Deltoid Posterior']
where name = 'Lat Pulldown';

update public.exercises set
  primary_muscles   = array['Quadriceps'],
  secondary_muscles = array['Gluteus Maximus','Hamstrings','Adductor Magnus']
where name = 'Leg Press';

update public.exercises set
  primary_muscles   = array['Deltoid Anterior'],
  secondary_muscles = array['Deltoid Lateral','Triceps Brachii','Trapezius Upper','Serratus Anterior']
where name = 'Overhead Press';

update public.exercises set
  primary_muscles   = array['Deltoid Anterior'],
  secondary_muscles = array['Triceps Brachii','Pectoralis Major Sternal Head','Trapezius Upper']
where name = 'Pike Push-Up';

update public.exercises set
  primary_muscles   = array['Latissimus Dorsi'],
  secondary_muscles = array['Biceps Brachii','Trapezius Middle','Rhomboids','Deltoid Posterior']
where name = 'Pull-Up';

update public.exercises set
  primary_muscles   = array['Pectoralis Major Sternal Head'],
  secondary_muscles = array['Deltoid Anterior','Triceps Brachii','Serratus Anterior']
where name = 'Push-Up';

update public.exercises set
  primary_muscles   = array['Triceps Brachii'],
  secondary_muscles = array['Deltoid Anterior','Pectoralis Major Sternal Head']
where name = 'Tricep Dip';

update public.exercises set
  primary_muscles   = array['Quadriceps'],
  secondary_muscles = array['Gluteus Maximus','Hamstrings','Adductor Magnus']
where name = 'Walking Lunge';
