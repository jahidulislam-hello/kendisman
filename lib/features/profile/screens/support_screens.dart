import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitzella/core/theme/theme_provider.dart';
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
                onTap: () => context.push('/profile/feedback-compose'),
              ),
              ProfileSettingsTile(
                icon: Icons.bug_report_outlined,
                title: 'Bug Report',
                onTap: () => context.push('/profile/feedback-compose'),
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
  const FeedbackComposeScreen({super.key});

  @override
  ConsumerState<FeedbackComposeScreen> createState() => _FeedbackComposeScreenState();
}

class _FeedbackComposeScreenState extends ConsumerState<FeedbackComposeScreen> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    return ProfileScaffold(
      title: 'Contact Us',
      trailing: TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text('Send', style: TextStyle(color: colors.accent, fontWeight: FontWeight.w700)),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: TextField(
          controller: _ctrl,
          maxLines: 10,
          style: TextStyle(color: colors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Tell us what’s on your mind…',
            hintStyle: TextStyle(color: colors.textMuted),
            filled: true,
            fillColor: colors.surface,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: colors.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: colors.border)),
          ),
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
                Text('Pro Plan', style: TextStyle(color: colors.textPrimary, fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text('Active - \$9.99/mo', style: TextStyle(color: colors.accent, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Text('Next billing date: Oct 16, 2026', style: TextStyle(color: colors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ProfileGroupCard(
            children: [
              ProfileSettingsTile(icon: Icons.receipt_long_outlined, title: 'Billing history', onTap: () {}),
              ProfileSettingsTile(icon: Icons.cancel_outlined, title: 'Cancel subscription', titleColor: colors.danger, iconColor: colors.danger, onTap: () {}),
            ],
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

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
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
                    Switch.adaptive(value: enabled, activeColor: colors.accent, onChanged: (v) => setState(() => enabled = v)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const ProfileSectionLabel('Days'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: days.keys.map((d) {
              final selected = days[d]!;
              return GestureDetector(
                onTap: () => setState(() => days[d] = !selected),
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
    return ProfileScaffold(
      title: 'Export & Import',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          ProfileGroupCard(
            children: [
              ProfileSettingsTile(icon: Icons.upload_outlined, title: 'Export workout data', onTap: () {}),
              ProfileSettingsTile(icon: Icons.download_outlined, title: 'Import workout data', onTap: () {}),
              ProfileSettingsTile(icon: Icons.cloud_upload_outlined, title: 'Backup to cloud', onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }
}
