import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'package:fitzella/core/providers/auth_provider.dart';
import 'package:fitzella/core/services/profile_prefs_service.dart';
import 'package:fitzella/core/services/fitness_data_service.dart';
import 'package:fitzella/features/auth/auth_screens.dart';
import 'package:fitzella/features/auth/login_choices_screen.dart';
import 'package:fitzella/features/onboarding/onboarding_screens.dart';
import 'package:fitzella/features/splash/splash_screen.dart';
import 'package:fitzella/features/splash/welcome_screen.dart';
import 'package:fitzella/features/home/home_screens.dart';
import 'package:fitzella/features/progress/progress_screens.dart';
import 'package:fitzella/features/profile/profile_screens.dart';
import 'package:fitzella/features/workout/workout_screens.dart';
import 'package:fitzella/features/workout/data/workout_data.dart';
import 'package:fitzella/core/theme/theme_provider.dart';

/// Notifies [GoRouter] when Supabase auth state changes (e.g. email confirm deep link).
class _AuthRefresh extends ChangeNotifier {
  _AuthRefresh() {
    _sub = Supabase.instance.client.auth.onAuthStateChange.listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

/// App router provider
final appRouterProvider = Provider<GoRouter>((ref) {
  return AppRouter(ref: ref).router;
});

class AppRouter {
  final Ref ref;
  late final GoRouter router;
  final _authRefresh = _AuthRefresh();

  AppRouter({required this.ref}) {
    ref.onDispose(_authRefresh.dispose);
    router = GoRouter(
      initialLocation: '/splash',
      refreshListenable: _authRefresh,
      redirect: _redirect,
      routes: _routes,
      errorBuilder: (context, state) => _ErrorScreen(error: state.error),
    );
  }

  String? _redirect(BuildContext context, GoRouterState state) {
    final loc = state.matchedLocation;
    if (loc == '/auth') return '/auth/login';
    if (loc == '/onboarding') return '/onboarding/welcome';
    if (loc == '/' || loc.isEmpty) return '/splash';

    // Let splash decide the first destination after cold start.
    if (loc == '/splash') return null;

    final auth = ref.read(authNotifierProvider);
    final session = auth.session;
    final pendingRecovery = auth.pendingPasswordRecovery;
    final isAuthRoute = loc.startsWith('/auth');
    final isOnboarding = loc.startsWith('/onboarding');
    final isAppShell = loc.startsWith('/home') ||
        loc.startsWith('/workout') ||
        loc.startsWith('/progress') ||
        loc.startsWith('/profile') ||
        loc.startsWith('/library') ||
        loc.startsWith('/add-exercise') ||
        loc.startsWith('/compare-exercises') ||
        loc.startsWith('/share-workout');

    // Signed out → keep auth/welcome public; block app + onboarding.
    if (session == null) {
      if (isAppShell || isOnboarding) return '/welcome';
      return null;
    }

    // Password recovery session must finish reset before using the app.
    if (pendingRecovery) {
      final onRecovery =
          loc == '/auth/reset-password' || loc.startsWith('/auth/verify-otp');
      if (!onRecovery) return '/auth/reset-password';
      return null;
    }

    final cached = ref.read(cachedProfileProvider);
    final cachedOnboarded =
        cached?.userId == session.user.id && cached?.onboarded == true;
    final onboarded = (auth.profile?.id == session.user.id &&
            auth.profile?.onboarded == true) ||
        cachedOnboarded;

    // After email confirmation deep link / successful login, leave auth/welcome.
    if (isAuthRoute || loc == '/welcome') {
      return onboarded ? '/home' : '/onboarding/welcome';
    }

    // Guard main tabs until profile setup is finished.
    if (!onboarded && isAppShell) {
      return '/onboarding/welcome';
    }

    return null;
  }

  List<RouteBase> get _routes => [
        GoRoute(
          path: '/splash',
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/welcome',
          name: 'welcome-intro',
          builder: (context, state) => const WelcomeScreen(),
        ),
        GoRoute(
          path: '/auth',
          name: 'auth',
          redirect: (context, state) {
            if (state.uri.path == '/auth') return '/auth/login';
            return null;
          },
          routes: [
            GoRoute(
              path: 'continue',
              name: 'auth-continue',
              builder: (context, state) => const LoginChoicesScreen(),
            ),
            GoRoute(
              path: 'login',
              name: 'login',
              builder: (context, state) => const LoginScreen(),
            ),
            GoRoute(
              path: 'signup',
              name: 'signup',
              builder: (context, state) => const SignupScreen(),
            ),
            GoRoute(
              path: 'verify-otp',
              name: 'verify-otp',
              builder: (context, state) => VerifyOtpScreen(
                email: state.uri.queryParameters['email'] ?? '',
                purpose: state.uri.queryParameters['purpose'] ?? 'signup',
              ),
            ),
            GoRoute(
              path: 'forgot-password',
              name: 'forgot-password',
              builder: (context, state) => const ForgotPasswordScreen(),
            ),
            GoRoute(
              path: 'reset-password',
              name: 'reset-password',
              builder: (context, state) => const ResetPasswordScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/onboarding',
          name: 'onboarding',
          redirect: (context, state) {
            if (state.uri.path == '/onboarding') return '/onboarding/welcome';
            return null;
          },
          routes: [
            GoRoute(
              path: 'welcome',
              name: 'welcome',
              builder: (context, state) => const OnboardingWelcomeScreen(),
            ),
            GoRoute(
              path: 'units',
              name: 'onboarding-units',
              builder: (context, state) => const OnboardingUnitsScreen(),
            ),
            GoRoute(
              path: 'gender',
              name: 'gender',
              builder: (context, state) => const OnboardingGenderScreen(),
            ),
            GoRoute(
              path: 'birthday',
              name: 'birthday',
              builder: (context, state) => const OnboardingBirthdayScreen(),
            ),
            GoRoute(
              path: 'weight',
              name: 'weight',
              builder: (context, state) => const OnboardingWeightScreen(),
            ),
            GoRoute(
              path: 'height',
              name: 'height',
              builder: (context, state) => const OnboardingHeightScreen(),
            ),
            GoRoute(
              path: 'goal',
              name: 'goal',
              builder: (context, state) => const OnboardingGoalScreen(),
            ),
            GoRoute(
              path: 'equipment',
              name: 'equipment',
              builder: (context, state) => const OnboardingEquipmentScreen(),
            ),
            GoRoute(
              path: 'experience',
              name: 'experience',
              builder: (context, state) => const OnboardingExperienceScreen(),
            ),
            GoRoute(
              path: 'frequency',
              name: 'frequency',
              builder: (context, state) => const OnboardingFrequencyScreen(),
            ),
            GoRoute(
              path: 'apple-health',
              name: 'apple-health',
              builder: (context, state) => const OnboardingAppleHealthScreen(),
            ),
            GoRoute(
              path: 'paywall',
              name: 'onboarding-paywall',
              builder: (context, state) => const OnboardingPaywallScreen(),
            ),
            GoRoute(
              path: 'ready',
              name: 'ready',
              builder: (context, state) => const OnboardingReadyScreen(),
            ),
          ],
        ),
        ShellRoute(
          builder: (context, state, child) => MainTabScaffold(child: child),
          routes: [
            GoRoute(
              path: '/home',
              name: 'home',
              builder: (context, state) => const HomeScreen(),
              routes: [
                GoRoute(
                  path: 'achievements',
                  name: 'home-achievements',
                  builder: (context, state) => const AchievementScreen(),
                ),
                GoRoute(
                  path: 'program-detail/:programId',
                  name: 'program-detail',
                  builder: (context, state) => ProgramDetailScreen(
                    programId: state.pathParameters['programId']!,
                  ),
                ),
                GoRoute(
                  path: 'workout-summary/:sessionId',
                  name: 'workout-summary',
                  builder: (context, state) => WorkoutSummaryScreen(
                    sessionId: state.pathParameters['sessionId']!,
                  ),
                ),
              ],
            ),
            GoRoute(
              path: '/workout',
              name: 'workout',
              builder: (context, state) => const WorkoutScreen(),
              routes: [
                GoRoute(
                  path: 'active',
                  name: 'active-workout',
                  builder: (context, state) => const ActiveWorkoutScreen(),
                ),
                GoRoute(
                  path: 'add-exercise',
                  name: 'workout-add-exercise',
                  builder: (context, state) => const WorkoutAddExerciseScreen(),
                ),
                GoRoute(
                  path: 'routines',
                  name: 'your-routines',
                  builder: (context, state) => const YourRoutinesScreen(),
                ),
                GoRoute(
                  path: 'build-routine',
                  name: 'build-routine',
                  builder: (context, state) =>
                      const WorkoutBuildRoutineScreen(),
                ),
                GoRoute(
                  path: 'weekly-schedule',
                  name: 'weekly-schedule',
                  builder: (context, state) => WeeklyScheduleScreen(
                    plan:
                        state.extra is PlanDef ? state.extra as PlanDef : null,
                  ),
                ),
                GoRoute(
                  path: 'new-routine',
                  name: 'workout-new-routine',
                  builder: (context, state) => const WorkoutNewRoutineScreen(),
                ),
                GoRoute(
                  path: 'summary',
                  name: 'workout-summary-session',
                  builder: (context, state) => const WorkoutCompleteScreen(),
                ),
                GoRoute(
                  path: 'exercise-detail/:exerciseId',
                  name: 'exercise-detail',
                  builder: (context, state) => ExerciseDetailScreen(
                    exerciseId: state.pathParameters['exerciseId']!,
                  ),
                ),
                GoRoute(
                  path: 'routine-editor/:routineId?',
                  name: 'routine-editor',
                  builder: (context, state) => RoutineEditorScreen(
                    routineId: state.pathParameters['routineId'],
                  ),
                ),
              ],
            ),
            GoRoute(
              path: '/progress',
              name: 'progress',
              builder: (context, state) => const ProgressScreen(),
              routes: [
                GoRoute(
                  path: 'personal-records',
                  name: 'personal-records',
                  builder: (context, state) => const PersonalRecordsScreen(),
                ),
                GoRoute(
                  path: 'personal-record/:exerciseId',
                  name: 'personal-record',
                  builder: (context, state) => ProgressExerciseDetailScreen(
                    exerciseId: state.pathParameters['exerciseId']!,
                  ),
                ),
                GoRoute(
                  path: 'compare-exercises',
                  name: 'compare-exercises',
                  builder: (context, state) => const CompareExercisesScreen(),
                ),
                GoRoute(
                  path: 'main-exercises',
                  name: 'main-exercises',
                  builder: (context, state) => const MainExercisesScreen(),
                ),
                GoRoute(
                  path: 'exercise/:exerciseId',
                  name: 'exercise-progress-detail',
                  builder: (context, state) => ProgressExerciseDetailScreen(
                    exerciseId: state.pathParameters['exerciseId']!,
                  ),
                ),
                GoRoute(
                  path: 'create-goal',
                  name: 'create-goal',
                  builder: (context, state) => const CreateGoalScreen(),
                ),
              ],
            ),
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) => const ProfileScreen(),
              routes: [
                GoRoute(
                  path: 'edit',
                  name: 'edit-profile',
                  builder: (context, state) => const EditProfileScreen(),
                ),
                GoRoute(
                  path: 'account',
                  name: 'account',
                  builder: (context, state) => const AccountScreen(),
                ),
                GoRoute(
                  path: 'account-privacy',
                  name: 'account-privacy',
                  builder: (context, state) => const AccountPrivacyScreen(),
                ),
                GoRoute(
                  path: 'appearance',
                  name: 'appearance',
                  builder: (context, state) => const AppearanceScreen(),
                ),
                GoRoute(
                  path: 'units',
                  name: 'profile-units',
                  builder: (context, state) => const UnitsScreen(),
                ),
                GoRoute(
                  path: 'language',
                  name: 'language',
                  builder: (context, state) => const LanguageScreen(),
                ),
                GoRoute(
                  path: 'notifications',
                  name: 'notifications',
                  builder: (context, state) => const WorkoutRemindersScreen(),
                ),
                GoRoute(
                  path: 'timer-sound',
                  name: 'timer-sound',
                  builder: (context, state) => const TimerSoundScreen(),
                ),
                GoRoute(
                  path: 'rest-timer-settings',
                  name: 'rest-timer-settings',
                  builder: (context, state) => const RestTimerSettingsScreen(),
                ),
                GoRoute(
                  path: 'subscription',
                  name: 'subscription',
                  builder: (context, state) => const ManageSubscriptionScreen(),
                ),
                GoRoute(
                  path: 'referral',
                  name: 'referral',
                  builder: (context, state) => const ReferralScreen(),
                ),
                GoRoute(
                  path: 'import-data',
                  name: 'import-data',
                  builder: (context, state) => const ImportDataScreen(),
                ),
                GoRoute(
                  path: 'export-import',
                  name: 'export-import',
                  builder: (context, state) => const ExportImportScreen(),
                ),
                GoRoute(
                  path: 'help',
                  name: 'help',
                  builder: (context, state) => const GetHelpScreen(),
                ),
                GoRoute(
                  path: 'feedback',
                  name: 'feedback',
                  builder: (context, state) => const ContactUsScreen(),
                ),
                GoRoute(
                  path: 'feedback-compose',
                  name: 'feedback-compose',
                  builder: (context, state) => FeedbackComposeScreen(
                    category: state.uri.queryParameters['category'] ??
                        'general_feedback',
                  ),
                ),
                GoRoute(
                  path: 'about',
                  name: 'about',
                  builder: (context, state) => const AboutScreen(),
                ),
                GoRoute(
                  path: 'goals',
                  name: 'goals',
                  builder: (context, state) => const CreateGoalScreen(),
                ),
                GoRoute(
                  path: 'goal-detail/:goalId',
                  name: 'goal-detail',
                  builder: (context, state) => GoalDetailScreen(
                    goalId: state.pathParameters['goalId']!,
                  ),
                ),
                GoRoute(
                  path: 'program-manager',
                  name: 'program-manager',
                  builder: (context, state) => const YourRoutinesScreen(),
                ),
                GoRoute(
                  path: 'program-templates',
                  name: 'program-templates',
                  builder: (context, state) => const YourRoutinesScreen(),
                ),
                GoRoute(
                  path: 'program-template-detail/:templateId',
                  name: 'program-template-detail',
                  builder: (context, state) => ProgramDetailScreen(
                    programId: state.pathParameters['templateId']!,
                  ),
                ),
                GoRoute(
                  path: 'program-builder',
                  name: 'program-builder',
                  builder: (context, state) => const WorkoutBuildRoutineScreen(),
                ),
                GoRoute(
                  path: 'add-exercise',
                  name: 'profile-add-exercise',
                  builder: (context, state) => const WorkoutAddExerciseScreen(),
                ),
                GoRoute(
                  path: 'new-routine',
                  name: 'new-routine',
                  builder: (context, state) => const WorkoutNewRoutineScreen(),
                ),
                GoRoute(
                  path: 'program-preview/:programId',
                  name: 'program-preview',
                  builder: (context, state) => ProgramDetailScreen(
                    programId: state.pathParameters['programId']!,
                  ),
                ),
                GoRoute(
                  path: 'choose-plan',
                  name: 'choose-plan',
                  builder: (context, state) => const ChoosePlanScreen(),
                ),
                GoRoute(
                  path: 'paywall',
                  name: 'paywall',
                  builder: (context, state) => const PaywallScreen(),
                ),
                GoRoute(
                  path: 'ai-questionnaire',
                  name: 'ai-questionnaire',
                  builder: (context, state) =>
                      const AIProgramQuestionnaireScreen(),
                ),
                GoRoute(
                  path: 'ai-coach-report',
                  name: 'ai-coach-report',
                  builder: (context, state) => const AICoachReportScreen(),
                ),
                GoRoute(
                  path: 'ask-coach',
                  name: 'ask-coach',
                  builder: (context, state) => const AskCoachScreen(),
                ),
                GoRoute(
                  path: 'body-profile',
                  name: 'body-profile',
                  builder: (context, state) => const BodyProfileScreen(),
                ),
                GoRoute(
                  path: 'plan-schedule',
                  name: 'plan-schedule',
                  builder: (context, state) => const ActiveProgramScheduleScreen(),
                ),
                GoRoute(
                  path: 'new-plan',
                  name: 'new-plan',
                  builder: (context, state) =>
                      const WorkoutBuildRoutineScreen(),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/library',
          name: 'library',
          builder: (context, state) => const LibraryScreen(),
        ),
        GoRoute(
          path: '/add-exercise',
          name: 'add-exercise',
          builder: (context, state) => const WorkoutAddExerciseScreen(),
        ),
        GoRoute(
          path: '/compare-exercises',
          name: 'compare-exercises-global',
          builder: (context, state) => const CompareExercisesScreen(),
        ),
        GoRoute(
          path: '/share-workout/:sessionId',
          name: 'share-workout',
          builder: (context, state) => ShareWorkoutScreen(
            sessionId: state.pathParameters['sessionId']!,
          ),
        ),
      ];
}

class MainTabScaffold extends StatelessWidget {
  final Widget child;
  const MainTabScaffold({super.key, required this.child});

  int _indexForLocation(String location) {
    if (location.startsWith('/workout')) return 1;
    if (location.startsWith('/progress')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final index = _indexForLocation(location);
    final showBottomNav = location == '/home' ||
        location == '/workout' ||
        location == '/progress' ||
        location == '/profile';

    return Scaffold(
      body: child,
      bottomNavigationBar: showBottomNav
          ? NavigationBar(
              selectedIndex: index,
              onDestinationSelected: (i) {
                switch (i) {
                  case 0:
                    context.go('/home');
                  case 1:
                    context.go('/workout');
                  case 2:
                    context.go('/progress');
                  case 3:
                    context.go('/profile');
                }
              },
              destinations: const [
                NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home),
                    label: 'Home'),
                NavigationDestination(
                    icon: Icon(Icons.fitness_center_outlined),
                    selectedIcon: Icon(Icons.fitness_center),
                    label: 'Workout'),
                NavigationDestination(
                    icon: Icon(Icons.insights_outlined),
                    selectedIcon: Icon(Icons.insights),
                    label: 'Progress'),
                NavigationDestination(
                    icon: Icon(Icons.person_outline),
                    selectedIcon: Icon(Icons.person),
                    label: 'Profile'),
              ],
            )
          : null,
    );
  }
}

class ProgramDetailScreen extends ConsumerWidget {
  final String programId;
  const ProgramDetailScreen({super.key, required this.programId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final programs = ref.watch(routineLibraryProvider);
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Program')),
      body: programs.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _RouteLoadError(
          message: 'Could not load this program: $error',
          retry: () => ref.invalidate(routineLibraryProvider),
        ),
        data: (rows) {
          final program = rows.where((row) => row['id'] == programId).firstOrNull;
          if (program == null) {
            return const Center(child: Text('This program is unavailable.'));
          }
          final routines =
              (program['routines'] as List? ?? const []).cast<Map<String, dynamic>>()
                ..sort((a, b) => (a['day_index'] as int? ?? 0)
                    .compareTo(b['day_index'] as int? ?? 0));
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(program['name'] as String? ?? 'Program',
                  style: TextStyle(color: colors.textPrimary, fontSize: 26, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(program['is_active'] == true ? 'Active program' : 'Saved program',
                  style: TextStyle(color: colors.textSecondary)),
              const SizedBox(height: 20),
              ...routines.map((routine) {
                final exercises = (routine['routine_exercises'] as List? ?? const [])
                    .cast<Map<String, dynamic>>()
                  ..sort((a, b) => (a['order_index'] as int? ?? 0)
                      .compareTo(b['order_index'] as int? ?? 0));
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(routine['name'] as String? ?? 'Workout',
                            style: const TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        if (exercises.isEmpty)
                          const Text('No exercises in this workout.')
                        else
                          ...exercises.map((exercise) {
                            final detail = exercise['exercises'] as Map<String, dynamic>?;
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(detail?['name'] as String? ?? 'Exercise'),
                              subtitle: Text(
                                '${exercise['target_sets'] ?? '—'} sets × ${exercise['target_reps'] ?? '—'} reps',
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                );
              }),
              if (program['is_active'] != true) ...[
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () async {
                    try {
                      await ref.read(fitnessDataServiceProvider).activateProgram(programId);
                      ref.invalidate(routineLibraryProvider);
                      ref.invalidate(homeSummaryProvider);
                    } catch (error) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Could not activate program: $error')),
                        );
                      }
                    }
                  },
                  child: const Text('Activate program'),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class WorkoutSummaryScreen extends ConsumerWidget {
  final String sessionId;
  const WorkoutSummaryScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final session = ref.watch(workoutSessionDetailProvider(sessionId));
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Workout summary')),
      body: session.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _RouteLoadError(
          message: 'Could not load this workout: $error',
          retry: () => ref.invalidate(workoutSessionDetailProvider(sessionId)),
        ),
        data: (row) {
          if (row == null) return const Center(child: Text('Workout not found.'));
          final sets = (row['logged_sets'] as List? ?? const [])
              .cast<Map<String, dynamic>>();
          final routine = row['routines'] as Map<String, dynamic>?;
          final title = row['routine_name'] as String? ??
              routine?['name'] as String? ??
              'Workout';
          final start = DateTime.tryParse(row['started_at'] as String? ?? '');
          final volume = sets.fold<double>(0, (total, set) =>
              total + ((set['weight'] as num?)?.toDouble() ?? 0) *
                  ((set['reps'] as num?)?.toInt() ?? 0));
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(title, style: TextStyle(color: colors.textPrimary, fontSize: 26, fontWeight: FontWeight.w800)),
              if (start != null) ...[
                const SizedBox(height: 6),
                Text(start.toLocal().toString().split('.').first,
                    style: TextStyle(color: colors.textSecondary)),
              ],
              const SizedBox(height: 16),
              Text('${sets.length} sets · ${volume.round()} lb total volume',
                  style: TextStyle(color: colors.textSecondary)),
              const SizedBox(height: 12),
              if (sets.isEmpty)
                const Text('No sets were logged.')
              else
                ...sets.map((set) {
                  final exercise = set['exercises'] as Map<String, dynamic>?;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(exercise?['name'] as String? ?? 'Exercise'),
                    subtitle: Text(
                      '${set['weight'] ?? 0} lb × ${set['reps'] ?? 0} reps',
                    ),
                    trailing: Text('Set ${set['set_index'] ?? ''}'),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}

class ExerciseDetailScreen extends StatelessWidget {
  final String exerciseId;
  const ExerciseDetailScreen({super.key, required this.exerciseId});
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('Exercise Detail: $exerciseId')));
}

class RoutineEditorScreen extends StatelessWidget {
  final String? routineId;
  const RoutineEditorScreen({super.key, this.routineId});
  @override
  Widget build(BuildContext context) => Scaffold(
      body: Center(child: Text('Routine Editor: ${routineId ?? 'new'}')));
}

class AccountPrivacyScreen extends StatelessWidget {
  const AccountPrivacyScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Account Privacy Screen')));
}

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Referral Screen')));
}

class ImportDataScreen extends StatelessWidget {
  const ImportDataScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Import Data Screen')));
}

class GoalDetailScreen extends ConsumerWidget {
  final String goalId;
  const GoalDetailScreen({super.key, required this.goalId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final goal = ref.watch(goalDetailProvider(goalId));
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Goal details')),
      body: goal.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _RouteLoadError(
          message: 'Could not load this goal: $error',
          retry: () => ref.invalidate(goalDetailProvider(goalId)),
        ),
        data: (row) {
          if (row == null) return const Center(child: Text('Goal not found.'));
          final title = row['title'] as String? ?? 'Goal';
          final target = (row['target_value'] as num?)?.toDouble() ?? 0;
          final current = (row['current_value'] as num?)?.toDouble() ?? 0;
          final progress = ((row['progress_percent'] as num?)?.toDouble() ?? 0)
              .clamp(0, 100);
          final completed = row['status'] == 'completed';
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(title, style: TextStyle(color: colors.textPrimary, fontSize: 26, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              Text(completed ? 'Completed' : 'In progress',
                  style: TextStyle(color: completed ? colors.success : colors.accent, fontWeight: FontWeight.w700)),
              const SizedBox(height: 20),
              LinearProgressIndicator(value: progress / 100),
              const SizedBox(height: 10),
              Text('${progress.round()}% complete',
                  style: TextStyle(color: colors.textSecondary)),
              const SizedBox(height: 16),
              Text('Current: ${current.toStringAsFixed(1)} · Target: ${target.toStringAsFixed(1)}',
                  style: TextStyle(color: colors.textPrimary)),
              if (!completed) ...[
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () async {
                    try {
                      await ref.read(fitnessDataServiceProvider).completeGoal(goalId);
                      ref.invalidate(goalDetailProvider(goalId));
                      ref.invalidate(goalsProvider);
                    } catch (error) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Could not complete goal: $error')),
                        );
                      }
                    }
                  },
                  child: const Text('Mark as complete'),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class ChoosePlanScreen extends StatelessWidget {
  const ChoosePlanScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Choose Plan Screen')));
}

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Paywall Screen')));
}

class AIProgramQuestionnaireScreen extends StatelessWidget {
  const AIProgramQuestionnaireScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('AI Questionnaire Screen')));
}

class AICoachReportScreen extends StatelessWidget {
  const AICoachReportScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('AI Coach Report Screen')));
}

class AskCoachScreen extends StatelessWidget {
  const AskCoachScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Ask Coach Screen')));
}

class ActiveProgramScheduleScreen extends ConsumerWidget {
  const ActiveProgramScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programs = ref.watch(routineLibraryProvider);
    return programs.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        body: _RouteLoadError(
          message: 'Could not load your programs: $error',
          retry: () => ref.invalidate(routineLibraryProvider),
        ),
      ),
      data: (rows) {
        final program = rows.where((row) => row['is_active'] == true).firstOrNull ??
            (rows.isEmpty ? null : rows.first);
        if (program == null) {
          return const Scaffold(
            body: Center(child: Text('Create a program before scheduling workouts.')),
          );
        }
        return WeeklyScheduleScreen(plan: _planFromProgramRow(program));
      },
    );
  }
}

PlanDef _planFromProgramRow(Map<String, dynamic> row) {
  final routines = (row['routines'] as List? ?? const [])
      .cast<Map<String, dynamic>>()
    ..sort((a, b) => (a['day_index'] as int? ?? 0)
        .compareTo(b['day_index'] as int? ?? 0));
  return PlanDef(
    id: row['id'] as String,
    name: row['name'] as String? ?? 'Program',
    active: row['is_active'] as bool? ?? false,
    aiGenerated: row['is_ai_generated'] as bool? ?? false,
    days: routines.map((routine) {
      final exercises = (routine['routine_exercises'] as List? ?? const [])
          .cast<Map<String, dynamic>>()
        ..sort((a, b) => (a['order_index'] as int? ?? 0)
            .compareTo(b['order_index'] as int? ?? 0));
      return RoutineDay(
        id: routine['id'] as String,
        name: routine['name'] as String? ?? 'Workout',
        exerciseIds: exercises.map((item) => item['exercise_id'] as String).toList(),
        exerciseNames: exercises.map((item) {
          final exercise = item['exercises'] as Map<String, dynamic>?;
          return exercise?['name'] as String? ?? 'Exercise';
        }).toList(),
        tag: '',
      );
    }).toList(),
  );
}

class _RouteLoadError extends StatelessWidget {
  const _RouteLoadError({required this.message, required this.retry});

  final String message;
  final VoidCallback retry;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              TextButton(onPressed: retry, child: const Text('Try again')),
            ],
          ),
        ),
      );
}

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final exercises = ref.watch(exerciseCatalogProvider);
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Exercise Library')),
      body: exercises.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _RouteLoadError(
          message: 'Could not load exercises: $error',
          retry: () => ref.invalidate(exerciseCatalogProvider),
        ),
        data: (rows) => rows.isEmpty
            ? const Center(child: Text('No exercises are available yet.'))
            : ListView.separated(
                itemCount: rows.length,
                separatorBuilder: (_, __) => Divider(color: colors.border),
                itemBuilder: (context, index) {
                  final exercise = rows[index];
                  return ListTile(
                    title: Text(exercise['name'] as String? ?? 'Exercise'),
                    subtitle: Text(
                      '${exercise['muscle_group'] ?? 'Other'} · '
                      '${exercise['equipment_type'] ?? 'Any equipment'}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push(
                      '/progress/exercise/${exercise['id']}',
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class ShareWorkoutScreen extends StatelessWidget {
  final String sessionId;
  const ShareWorkoutScreen({super.key, required this.sessionId});
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('Share Workout: $sessionId')));
}

class _ErrorScreen extends StatelessWidget {
  final Exception? error;
  const _ErrorScreen({this.error});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Something went wrong',
                  style: Theme.of(context).textTheme.headlineSmall),
              if (error != null) ...[
                const SizedBox(height: 8),
                Text(error.toString(),
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ],
          ),
        ),
      );
}
