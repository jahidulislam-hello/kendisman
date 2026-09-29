// View models for the Progress section, built from Supabase rows.

class ProgressWorkout {
  final String id;
  final String title;
  final DateTime date;
  final String time;
  final String routineTag;
  final bool tagAccent;
  final List<String> exercises;

  /// Lower-cased `exercises.muscle_group` values of the logged exercises.
  final Set<String> muscles;
  final int setsLogged;
  final String duration;
  final String volume;
  final int records;
  final List<SessionExercise> sessionExercises;

  const ProgressWorkout({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.routineTag,
    this.tagAccent = false,
    required this.exercises,
    this.muscles = const {},
    required this.setsLogged,
    required this.duration,
    required this.volume,
    required this.records,
    required this.sessionExercises,
  });
}

class SessionExercise {
  final String name;
  final String subtitle;
  final String initials;
  final List<SessionSet> sets;

  const SessionExercise({
    required this.name,
    required this.subtitle,
    required this.initials,
    required this.sets,
  });
}

class SessionSet {
  final int set;
  final String weightReps;
  final String oneRm;

  const SessionSet({
    required this.set,
    required this.weightReps,
    required this.oneRm,
  });
}

class ActiveGoal {
  final String id;
  final String type; // CONSISTENCY, STRENGTH
  final String title;
  final int percent;
  final String current;
  final String due;

  const ActiveGoal({
    required this.id,
    required this.type,
    required this.title,
    required this.percent,
    required this.current,
    required this.due,
  });
}
