import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitzella/core/theme/theme_provider.dart';
import 'package:fitzella/core/providers/auth_provider.dart';
import 'package:fitzella/core/services/fitness_data_service.dart';
import 'package:fitzella/features/profile/widgets/profile_widgets.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    return ProfileScaffold(
      title: 'About',
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Fitzella', style: TextStyle(color: colors.accent, fontSize: 36, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text('Version 1.0.0', style: TextStyle(color: colors.textSecondary, fontSize: 14)),
              const SizedBox(height: 24),
              Text(
                'Built with care for lifters everywhere. Fitzella is designed to be the ultimate companion for your strength journey.',
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.textSecondary, fontSize: 14, height: 1.45),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactUsScreen extends ConsumerWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProfileScaffold(
      title: 'Contact Us',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          ProfileGroupCard(
            children: [
              ProfileSettingsTile(
                icon: Icons.lightbulb_outline,
                title: 'Feature Request',
                onTap: () => context.push(
                  '/profile/feedback-compose?category=feature_request',
                ),
              ),
              ProfileSettingsTile(
                icon: Icons.bug_report_outlined,
                title: 'Bug Report',
                onTap: () => context.push(
                  '/profile/feedback-compose?category=bug_report',
                ),
              ),
              ProfileSettingsTile(
                icon: Icons.help_outline,
                title: 'Get Help',
                onTap: () => context.push('/profile/help'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GetHelpScreen extends ConsumerWidget {
  const GetHelpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    return ProfileScaffold(
      title: 'Getting Started',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          ProfileGroupCard(
            children: [
              ProfileSettingsTile(icon: Icons.flag_outlined, title: 'Set your goals', onTap: () {}),
              ProfileSettingsTile(icon: Icons.fitness_center, title: 'Create your first routine', onTap: () => context.push('/profile/program-builder')),
              ProfileSettingsTile(icon: Icons.play_circle_outline, title: 'Start a workout', onTap: () => context.go('/workout')),
              ProfileSettingsTile(icon: Icons.insights_outlined, title: 'Track progress', onTap: () => context.go('/progress')),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Tips and walkthroughs to help you get the most out of fitzella.',
            style: TextStyle(color: colors.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class FeedbackComposeScreen extends ConsumerStatefulWidget {
  final String category;

  const FeedbackComposeScreen({
    super.key,
    this.category = 'general_feedback',
  });

  @override
  ConsumerState<FeedbackComposeScreen> createState() => _FeedbackComposeScreenState();
}

class _FeedbackComposeScreenState extends ConsumerState<FeedbackComposeScreen> {
  final _ctrl = TextEditingController();
  bool _sending = false;
  String? _error;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_sending) return;
    if (_ctrl.text.trim().isEmpty) {
      setState(() => _error = 'Enter feedback before sending.');
      return;
    }
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      await ref.read(fitnessDataServiceProvider).submitFeedback(
            category: widget.category,
            message: _ctrl.text,
          );
      if (mounted) Navigator.pop(context);
    } catch (error) {
      if (mounted) {
        setState(() {
          _sending = false;
          _error = 'Could not send feedback: $error';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    return ProfileScaffold(
      title: 'Contact Us',
      trailing: TextButton(
        onPressed: _sending ? null : _submit,
        child: _sending
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text('Send',
                style: TextStyle(
                    color: colors.accent, fontWeight: FontWeight.w700)),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          children: [
            if (_error != null) ...[
              Text(_error!, style: TextStyle(color: colors.danger)),
              const SizedBox(height: 8),
            ],
            Expanded(
              child: TextField(
                controller: _ctrl,
                maxLines: 10,
                style: TextStyle(color: colors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Tell us what’s on your mind…',
                  hintStyle: TextStyle(color: colors.textMuted),
                  filled: true,
                  fillColor: colors.surface,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: colors.border)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: colors.border)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ManageSubscriptionScreen extends ConsumerWidget {
  const ManageSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final profile = ref.watch(currentProfileProvider);
    final tier = profile?.subscriptionTier.name ?? 'free';
    return ProfileScaffold(
      title: 'Subscription',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tier == 'free' ? 'Free plan' : '${tier.toUpperCase()} plan', style: TextStyle(color: colors.textPrimary, fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text('Plan status from your account profile', style: TextStyle(color: colors.accent, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Billing history and subscription changes are not available in this app build.',
            style: TextStyle(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class WorkoutRemindersScreen extends ConsumerStatefulWidget {
  const WorkoutRemindersScreen({super.key});

  @override
  ConsumerState<WorkoutRemindersScreen> createState() => _WorkoutRemindersScreenState();
}

class _WorkoutRemindersScreenState extends ConsumerState<WorkoutRemindersScreen> {
  bool enabled = true;
  final days = {'Mon': true, 'Tue': false, 'Wed': true, 'Thu': false, 'Fri': true, 'Sat': false, 'Sun': false};
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final preferences =
          await ref.read(fitnessDataServiceProvider).fetchAccountPreferences();
      if (!mounted) return;
      final selected =
          (preferences['notification_days'] as List? ?? const [])
              .map((value) => (value as num).toInt())
              .toSet();
      setState(() {
        enabled = preferences['notifications_enabled'] as bool? ?? true;
        var index = 0;
        for (final day in days.keys.toList()) {
          days[day] = selected.contains(index++);
        }
      });
    } catch (error) {
      if (mounted) setState(() => _error = 'Could not load reminders: $error');
    }
  }

  Future<void> _setEnabled(bool value) async {
    final result = await ref
        .read(authNotifierProvider.notifier)
        .updateNotificationsEnabled(value);
    result.when(
      success: (_) => setState(() {
        enabled = value;
        _error = null;
      }),
      error: (message) => setState(() => _error = 'Could not save reminders: $message'),
    );
  }

  Future<void> _toggleDay(String day, bool selected) async {
    final next = Map<String, bool>.from(days)..[day] = !selected;
    final indexes = <int>[];
    for (var index = 0; index < next.values.length; index++) {
      if (next.values.elementAt(index)) indexes.add(index);
    }
    try {
      await ref.read(fitnessDataServiceProvider).updateAccountPreference(
            'notification_days',
            indexes,
          );
      if (mounted) {
        setState(() {
          days.addAll(next);
          _error = null;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() => _error = 'Could not save reminder days: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    final profile = ref.watch(currentProfileProvider);
    return ProfileScaffold(
      title: 'Workout Reminders',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          ProfileGroupCard(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                child: Row(
                  children: [
                    Expanded(child: Text('Reminders', style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600))),
                    Switch.adaptive(value: profile?.notificationsEnabled ?? enabled, activeThumbColor: colors.accent, onChanged: _setEnabled),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(_error!, style: TextStyle(color: colors.danger)),
            ),
          const ProfileSectionLabel('Days'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: days.keys.map((d) {
              final selected = days[d]!;
              return GestureDetector(
                onTap: () => _toggleDay(d, selected),
                child: Container(
                  width: 46,
                  height: 46,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? colors.accent : colors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: selected ? colors.accent : colors.border),
                  ),
                  child: Text(
                    d,
                    style: TextStyle(
                      color: selected ? colors.onAccent : colors.textSecondary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class ExportImportScreen extends ConsumerWidget {
  const ExportImportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    return ProfileScaffold(
      title: 'Export & Import',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          ProfileGroupCard(
            children: [
              ProfileSettingsTile(
                icon: Icons.upload_outlined,
                title: 'Copy workout data export',
                subtitle: 'Copies your Supabase workout history as JSON',
                onTap: () async {
                  try {
                    final sessions = await ref
                        .read(fitnessDataServiceProvider)
                        .fetchWorkoutHistory();
                    await Clipboard.setData(
                      ClipboardData(text: jsonEncode(sessions)),
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Exported ${sessions.length} workouts to the clipboard.')),
                      );
                    }
                  } catch (error) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Could not export workout data: $error')),
                      );
                    }
                  }
                },
              ),
              const ProfileSettingsTile(
                icon: Icons.download_outlined,
                title: 'Import workout data',
                subtitle: 'Import is not supported yet',
              ),
              ProfileSettingsTile(
                icon: Icons.cloud_done_outlined,
                title: 'Cloud backup',
                subtitle: 'Workout data is stored in your Supabase account',
                trailing: Icon(Icons.check_circle, color: colors.success),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
