/// Mock data for Progress section (frontend-only).

class ProgressWorkout {
  final String id;
  final String title;
  final DateTime date;
  final String time;
  final String routineTag;
  final bool tagAccent;
  final List<String> exercises;
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

class PersonalRecordItem {
  final String id;
  final String name;
  final String category; // All, Upper Body, Lower Body, Core
  final String record;
  final String delta;
  final DateTime date;
  final String previous;
  final String current;

  const PersonalRecordItem({
    required this.id,
    required this.name,
    required this.category,
    required this.record,
    required this.delta,
    required this.date,
    required this.previous,
    required this.current,
  });
}

class MainExerciseItem {
  final String id;
  final String name;
  final String muscle;
  final int sessions;
  final String totalVolume;

  const MainExerciseItem({
    required this.id,
    required this.name,
    required this.muscle,
    required this.sessions,
    required this.totalVolume,
  });
}

class ExerciseOption {
  final String id;
  final String name;
  final String muscle;

  const ExerciseOption({
    required this.id,
    required this.name,
    required this.muscle,
  });
}

class ExerciseHistorySession {
  final String dateLabel;
  final List<ExerciseHistorySet> sets;

  const ExerciseHistorySession({
    required this.dateLabel,
    required this.sets,
  });
}

class ExerciseHistorySet {
  final int set;
  final String weightReps;
  final String oneRm;
  final bool isPr;

  const ExerciseHistorySet({
    required this.set,
    required this.weightReps,
    required this.oneRm,
    this.isPr = false,
  });
}

class BestSetItem {
  final String weightReps;
  final String date;
  final String oneRm;

  const BestSetItem({
    required this.weightReps,
    required this.date,
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

class ProgressMockData {
  static const dateRanges = ['This week', 'This month', 'Last 3 months', 'All time'];
  static const muscleGroups = ['Arms', 'Back', 'Chest', 'Legs', 'Shoulders'];
  static const routineDays = ['Day 1', 'Legs', 'Pull', 'Push'];

  static final workouts = <ProgressWorkout>[
    ProgressWorkout(
      id: 'w1',
      title: 'Thursday',
      date: DateTime(2026, 9, 10),
      time: '12:22',
      routineTag: 'Quick Workout',
      tagAccent: true,
      exercises: const ['Cable Crunch'],
      setsLogged: 3,
      duration: '0m',
      volume: '960 lb',
      records: 0,
      sessionExercises: const [
        SessionExercise(
          name: 'Cable Crunch',
          subtitle: 'Abdominals • Cable',
          initials: 'CC',
          sets: [
            SessionSet(set: 1, weightReps: '40 lb × 8 reps', oneRm: '50.5 lb'),
            SessionSet(set: 2, weightReps: '40 lb × 8 reps', oneRm: '50.5 lb'),
            SessionSet(set: 3, weightReps: '40 lb × 8 reps', oneRm: '50.5 lb'),
          ],
        ),
      ],
    ),
    ProgressWorkout(
      id: 'w2',
      title: 'Friday',
      date: DateTime(2026, 9, 5),
      time: '11:59',
      routineTag: 'Day 1',
      tagAccent: true,
      exercises: const ['Barbell Row', 'Barbell Bench Press'],
      setsLogged: 6,
      duration: '48m',
      volume: '12,400 lb',
      records: 1,
      sessionExercises: const [
        SessionExercise(
          name: 'Barbell Row',
          subtitle: 'Back • Barbell',
          initials: 'BR',
          sets: [
            SessionSet(set: 1, weightReps: '135 lb × 8 reps', oneRm: '170 lb'),
            SessionSet(set: 2, weightReps: '135 lb × 8 reps', oneRm: '170 lb'),
            SessionSet(set: 3, weightReps: '135 lb × 8 reps', oneRm: '170 lb'),
          ],
        ),
        SessionExercise(
          name: 'Barbell Bench Press',
          subtitle: 'Chest • Barbell',
          initials: 'BB',
          sets: [
            SessionSet(set: 1, weightReps: '155 lb × 5 reps', oneRm: '180 lb'),
            SessionSet(set: 2, weightReps: '155 lb × 5 reps', oneRm: '180 lb'),
            SessionSet(set: 3, weightReps: '155 lb × 5 reps', oneRm: '180 lb'),
          ],
        ),
      ],
    ),
    ProgressWorkout(
      id: 'w3',
      title: 'Wednesday',
      date: DateTime(2026, 9, 3),
      time: '18:20',
      routineTag: 'Legs',
      exercises: const ['Leg Press', 'Barbell Back Squat', 'Romanian Deadlift'],
      setsLogged: 9,
      duration: '62m',
      volume: '28,500 lb',
      records: 2,
      sessionExercises: const [
        SessionExercise(
          name: 'Leg Press',
          subtitle: 'Quads • Machine',
          initials: 'LP',
          sets: [
            SessionSet(set: 1, weightReps: '307.5 lb × 11 reps', oneRm: '420 lb'),
            SessionSet(set: 2, weightReps: '307.5 lb × 11 reps', oneRm: '420 lb'),
            SessionSet(set: 3, weightReps: '307.5 lb × 10 reps', oneRm: '410 lb'),
          ],
        ),
      ],
    ),
    ProgressWorkout(
      id: 'w4',
      title: 'Monday',
      date: DateTime(2026, 9, 1),
      time: '07:45',
      routineTag: 'Push',
      exercises: const ['Barbell Bench Press', 'Cable Fly', 'Overhead Press'],
      setsLogged: 8,
      duration: '55m',
      volume: '15,200 lb',
      records: 0,
      sessionExercises: const [],
    ),
    ProgressWorkout(
      id: 'w5',
      title: 'Saturday',
      date: DateTime(2026, 8, 30),
      time: '10:15',
      routineTag: 'Pull',
      exercises: const ['Barbell Row', 'Lat Pulldown', 'Face Pull'],
      setsLogged: 7,
      duration: '50m',
      volume: '14,800 lb',
      records: 1,
      sessionExercises: const [],
    ),
    for (var i = 0; i < 22; i++)
      ProgressWorkout(
        id: 'w${i + 6}',
        title: const ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'][i % 7],
        date: DateTime(2026, 8, 28).subtract(Duration(days: i * 2)),
        time: '${10 + (i % 8)}:${((i * 7) % 60).toString().padLeft(2, '0')}',
        routineTag: const ['Day 1', 'Legs', 'Pull', 'Push'][i % 4],
        tagAccent: i % 4 == 0,
        exercises: i % 4 == 1
            ? const ['Leg Press', 'Barbell Back Squat']
            : i % 4 == 2
                ? const ['Barbell Row', 'Lat Pulldown']
                : i % 4 == 3
                    ? const ['Barbell Bench Press', 'Cable Fly']
                    : const ['Barbell Row', 'Barbell Bench Press'],
        setsLogged: 6 + (i % 4),
        duration: '${40 + i}m',
        volume: '${10000 + i * 500} lb',
        records: i % 3,
        sessionExercises: const [],
      ),
  ];

  static final personalRecords = <PersonalRecordItem>[
    PersonalRecordItem(
      id: 'leg-press',
      name: 'Leg Press',
      category: 'Lower Body',
      record: '307.5 lb × 11',
      delta: '+2.5lb',
      date: DateTime(2026, 9, 1),
      previous: '305 lb × 12',
      current: '307.5 lb × 11',
    ),
    PersonalRecordItem(
      id: 'barbell-back-squat',
      name: 'Barbell Back Squat',
      category: 'Lower Body',
      record: '225 lb × 7',
      delta: '+5lb',
      date: DateTime(2026, 8, 28),
      previous: '220 lb × 7',
      current: '225 lb × 7',
    ),
    PersonalRecordItem(
      id: 'romanian-deadlift',
      name: 'Romanian Deadlift',
      category: 'Lower Body',
      record: '185 lb × 8',
      delta: '+5lb',
      date: DateTime(2026, 8, 25),
      previous: '180 lb × 8',
      current: '185 lb × 8',
    ),
    PersonalRecordItem(
      id: 'barbell-bench-press',
      name: 'Barbell Bench Press',
      category: 'Upper Body',
      record: '155 lb × 5',
      delta: '+5lb',
      date: DateTime(2026, 9, 5),
      previous: '150 lb × 5',
      current: '155 lb × 5',
    ),
    PersonalRecordItem(
      id: 'barbell-row',
      name: 'Barbell Row',
      category: 'Upper Body',
      record: '135 lb × 8',
      delta: '+5lb',
      date: DateTime(2026, 9, 5),
      previous: '130 lb × 8',
      current: '135 lb × 8',
    ),
    PersonalRecordItem(
      id: 'cable-crunch',
      name: 'Cable Crunch',
      category: 'Core',
      record: '40 lb × 8',
      delta: '+5lb',
      date: DateTime(2026, 9, 10),
      previous: '35 lb × 8',
      current: '40 lb × 8',
    ),
  ];

  static const mainExercises = <MainExerciseItem>[
    MainExerciseItem(id: 'barbell-bench-press', name: 'Barbell Bench Press', muscle: 'Chest', sessions: 10, totalVolume: '35,913 lb'),
    MainExerciseItem(id: 'leg-press', name: 'Leg Press', muscle: 'Legs', sessions: 9, totalVolume: '84,555 lb'),
    MainExerciseItem(id: 'standing-calf-raise', name: 'Standing Calf Raise', muscle: 'Legs', sessions: 9, totalVolume: '67,420 lb'),
    MainExerciseItem(id: 'barbell-back-squat', name: 'Barbell Back Squat', muscle: 'Legs', sessions: 9, totalVolume: '48,768 lb'),
    MainExerciseItem(id: 'romanian-deadlift', name: 'Romanian Deadlift', muscle: 'Legs', sessions: 9, totalVolume: '38,770 lb'),
    MainExerciseItem(id: 'barbell-row', name: 'Barbell Row', muscle: 'Back', sessions: 9, totalVolume: '33,903 lb'),
  ];

  static const exerciseOptions = <ExerciseOption>[
    ExerciseOption(id: 'barbell-back-squat', name: 'Barbell Back Squat', muscle: 'LEGS'),
    ExerciseOption(id: 'barbell-bench-press', name: 'Barbell Bench Press', muscle: 'CHEST'),
    ExerciseOption(id: 'barbell-row', name: 'Barbell Row', muscle: 'BACK'),
    ExerciseOption(id: 'cable-crunch', name: 'Cable Crunch', muscle: 'CORE'),
    ExerciseOption(id: 'conventional-deadlift', name: 'Conventional Deadlift', muscle: 'BACK'),
    ExerciseOption(id: 'leg-press', name: 'Leg Press', muscle: 'LEGS'),
  ];

  static const muscleDistribution = <String, int>{
    'Chest': 71,
    'Back': 134,
    'Shoulders': 54,
    'Arms': 57,
    'Legs': 165,
    'Core': 6,
  };

  static const musclePercents = <String, int>{
    'Legs': 34,
    'Back': 28,
    'Chest': 15,
    'Arms': 12,
    'Shoulders': 11,
    'Core': 1,
  };

  static Map<String, List<ExerciseHistorySession>> exerciseHistory = {
    'leg-press': const [
      ExerciseHistorySession(
        dateLabel: 'Tuesday, 1 Sept',
        sets: [
          ExerciseHistorySet(set: 1, weightReps: '307.5 lb × 11', oneRm: '420 lb', isPr: true),
          ExerciseHistorySet(set: 2, weightReps: '307.5 lb × 11', oneRm: '420 lb', isPr: true),
          ExerciseHistorySet(set: 3, weightReps: '307.5 lb × 10', oneRm: '410 lb'),
        ],
      ),
      ExerciseHistorySession(
        dateLabel: 'Tuesday, 25 Aug',
        sets: [
          ExerciseHistorySet(set: 1, weightReps: '305 lb × 12', oneRm: '427 lb', isPr: true),
          ExerciseHistorySet(set: 2, weightReps: '305 lb × 12', oneRm: '427 lb', isPr: true),
          ExerciseHistorySet(set: 3, weightReps: '305 lb × 10', oneRm: '407 lb'),
        ],
      ),
      ExerciseHistorySession(
        dateLabel: 'Tuesday, 18 Aug',
        sets: [
          ExerciseHistorySet(set: 1, weightReps: '300 lb × 10', oneRm: '400 lb', isPr: true),
          ExerciseHistorySet(set: 2, weightReps: '300 lb × 10', oneRm: '400 lb', isPr: true),
          ExerciseHistorySet(set: 3, weightReps: '300 lb × 10', oneRm: '400 lb', isPr: true),
        ],
      ),
    ],
    'barbell-back-squat': const [
      ExerciseHistorySession(
        dateLabel: 'Sunday, 6 Sept',
        sets: [
          ExerciseHistorySet(set: 1, weightReps: '262.5 lb × 4', oneRm: '298 lb', isPr: true),
          ExerciseHistorySet(set: 2, weightReps: '262.5 lb × 3', oneRm: '289 lb'),
          ExerciseHistorySet(set: 3, weightReps: '262.5 lb × 3', oneRm: '289 lb'),
        ],
      ),
      ExerciseHistorySession(
        dateLabel: 'Sunday, 30 Aug',
        sets: [
          ExerciseHistorySet(set: 1, weightReps: '262.5 lb × 4', oneRm: '298 lb', isPr: true),
          ExerciseHistorySet(set: 2, weightReps: '262.5 lb × 3', oneRm: '289 lb'),
          ExerciseHistorySet(set: 3, weightReps: '262.5 lb × 3', oneRm: '289 lb'),
        ],
      ),
      ExerciseHistorySession(
        dateLabel: 'Sunday, 23 Aug',
        sets: [
          ExerciseHistorySet(set: 1, weightReps: '260 lb × 4', oneRm: '295 lb', isPr: true),
          ExerciseHistorySet(set: 2, weightReps: '260 lb × 4', oneRm: '295 lb', isPr: true),
          ExerciseHistorySet(set: 3, weightReps: '260 lb × 2', oneRm: '277 lb'),
        ],
      ),
    ],
  };

  static Map<String, Map<String, String>> exerciseStats = {
    'leg-press': {
      'est1rm': '420 lb',
      'pr': '307.5 lb',
      'volume': '84,555 lb',
      'reps': '292',
      'name': 'Leg Press',
      'primaryMuscle': 'QUADS (PRIMARY)',
      'secondaryMuscles': 'GLUTES',
    },
    'barbell-back-squat': {
      'est1rm': '298 lb',
      'pr': '262.5 lb',
      'volume': '48,768 lb',
      'reps': '97',
      'name': 'Barbell Back Squat',
      'primaryMuscle': 'QUADS (PRIMARY)',
      'secondaryMuscles': 'GLUTES,HAMSTRINGS',
    },
    'conventional-deadlift': {
      'est1rm': '298 lb',
      'pr': '262.5 lb',
      'volume': '23,795 lb',
      'reps': '97',
      'name': 'Conventional Deadlift',
      'primaryMuscle': 'BACK (PRIMARY)',
      'secondaryMuscles': 'HAMSTRINGS,GLUTES',
    },
  };

  static Map<String, List<BestSetItem>> bestSets = {
    'leg-press': const [
      BestSetItem(weightReps: '305 lb × 12', date: '25 Aug 2026', oneRm: '427 lb'),
      BestSetItem(weightReps: '307.5 lb × 11', date: '1 Sept 2026', oneRm: '420 lb'),
      BestSetItem(weightReps: '307.5 lb × 10', date: '1 Sept 2026', oneRm: '410 lb'),
      BestSetItem(weightReps: '305 lb × 10', date: '25 Aug 2026', oneRm: '407 lb'),
      BestSetItem(weightReps: '295 lb × 11', date: '11 Aug 2026', oneRm: '403 lb'),
      BestSetItem(weightReps: '300 lb × 10', date: '18 Aug 2026', oneRm: '400 lb'),
    ],
    'barbell-back-squat': const [
      BestSetItem(weightReps: '262.5 lb × 4', date: '6 Sept 2026', oneRm: '298 lb'),
      BestSetItem(weightReps: '260 lb × 4', date: '23 Aug 2026', oneRm: '295 lb'),
    ],
    'conventional-deadlift': const [
      BestSetItem(weightReps: '305 lb × 12', date: '25 Aug 2026', oneRm: '427 lb'),
      BestSetItem(weightReps: '307.5 lb × 11', date: '1 Sept 2026', oneRm: '420 lb'),
      BestSetItem(weightReps: '307.5 lb × 10', date: '1 Sept 2026', oneRm: '410 lb'),
      BestSetItem(weightReps: '305 lb × 10', date: '25 Aug 2026', oneRm: '407 lb'),
    ],
  };

  static const legPressInstructions = [
    'Sit back fully with your whole back supported on the pad.',
    'Place your feet about shoulder-width on the platform.',
    'Release the safety catches and hold the handles.',
    'Lower the platform by bending your knees toward your chest.',
    'Stop before your lower back rounds or lifts off the pad.',
    'Press back up through your whole foot.',
    'Keep a slight bend in the knees at the top; do not lock them out hard.',
  ];

  static const activeGoals = <ActiveGoal>[
    ActiveGoal(
      id: 'g1',
      type: 'CONSISTENCY',
      title: 'Reach 185 lb bodyweight',
      percent: 1,
      current: '2 lb',
      due: '2 Dec 2026',
    ),
    ActiveGoal(
      id: 'g2',
      type: 'STRENGTH',
      title: 'Bench press 185 lb for 5',
      percent: 84,
      current: '155 lb',
      due: '18 Oct 2026',
    ),
  ];

  static String exerciseName(String id) {
    final fromStats = exerciseStats[id]?['name'];
    if (fromStats != null) return fromStats;
    for (final e in exerciseOptions) {
      if (e.id == id) return e.name;
    }
    for (final e in personalRecords) {
      if (e.id == id) return e.name;
    }
    for (final e in mainExercises) {
      if (e.id == id) return e.name;
    }
    return id;
  }
}
