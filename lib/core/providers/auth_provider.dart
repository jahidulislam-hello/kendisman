import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:fitzella/core/config/supabase_config.dart';
import 'package:fitzella/core/models/profile/user_profile.dart';
import 'package:fitzella/core/services/profile_prefs_service.dart';
import 'package:fitzella/core/services/supabase_service.dart';
import 'package:fitzella/features/onboarding/onboarding_provider.dart';

part 'auth_provider.g.dart';
part 'auth_provider.freezed.dart';

void _authDebug(String message, [Object? error]) {
  final text = error == null ? '[AUTH] $message' : '[AUTH] $message | $error';
  debugPrint(text);
}

/// Auth state
@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    Session? session,
    UserProfile? profile,
    @Default(true) bool loading,
    bool? hasProgram,
    @Default(false) bool pendingPasswordRecovery,
  }) = _AuthState;
}

/// Auth notifier managing authentication state
@riverpod
class AuthNotifier extends _$AuthNotifier {
  int _profileLoadVersion = 0;

  @override
  AuthState build() {
    final client = ref.read(supabaseClientProvider);
    final session = client.auth.currentSession;

    final sub = client.auth.onAuthStateChange.listen((data) {
      final next = data.session;
      if (next != null) {
        state = state.copyWith(session: next, loading: true);
        _loadProfile(next.user.id);
      } else {
        _profileLoadVersion++;
        _clearLocalProfile();
        state = state.copyWith(
          session: null,
          profile: null,
          hasProgram: null,
          loading: false,
        );
      }
    });
    ref.onDispose(sub.cancel);

    if (session != null) {
      Future.microtask(() => _loadProfile(session.user.id));
      return AuthState(session: session, loading: true);
    }
    return const AuthState(loading: false);
  }

  Future<void> _loadProfile(String userId) async {
    final loadVersion = ++_profileLoadVersion;
    try {
      final cached = ref.read(profilePrefsServiceProvider).load();
      if (cached != null && cached.userId != userId) {
        await ref.read(profilePrefsServiceProvider).clear();
        ref.read(cachedProfileProvider.notifier).state = null;
      }
      if (loadVersion != _profileLoadVersion) return;

      var response = await ref
          .read(supabaseClientProvider)
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) {
        // Trigger may lag behind signup — create a minimal profile row.
        final email = state.session?.user.email ??
            ref.read(supabaseClientProvider).auth.currentUser?.email ??
            '';
        await ref.read(supabaseClientProvider).from('users').upsert({
          'id': userId,
          'email': email,
        });
        response = await ref
            .read(supabaseClientProvider)
            .from('users')
            .select()
            .eq('id', userId)
            .maybeSingle();
      }

      if (response == null) {
        if (loadVersion != _profileLoadVersion) return;
        state =
            state.copyWith(profile: null, hasProgram: false, loading: false);
        return;
      }

      final profile = UserProfile.fromJson(response);
      final hasProgram = await _checkHasProgram(userId);
      final weightKg = await _latestWeightKg(userId);

      if (loadVersion != _profileLoadVersion) return;
      state = state.copyWith(
        profile: profile,
        hasProgram: hasProgram,
        loading: false,
      );
      await _syncLocalProfile(profile, weightKg: weightKg);
    } catch (e) {
      if (loadVersion != _profileLoadVersion) return;
      _authDebug('_loadProfile failed', e);
      // Keep session; fall back to SharedPreferences cache if present.
      final cached = ref.read(profilePrefsServiceProvider).load();
      if (cached?.userId == userId) {
        ref.read(cachedProfileProvider.notifier).state = cached;
      }
      state = state.copyWith(loading: false);
    }
  }

  Future<double?> _latestWeightKg(String userId) async {
    try {
      final row = await ref
          .read(supabaseClientProvider)
          .from('body_measurements')
          .select('weight_lb')
          .eq('user_id', userId)
          .not('weight_lb', 'is', null)
          .order('measured_on', ascending: false)
          .limit(1)
          .maybeSingle();
      final lb = (row?['weight_lb'] as num?)?.toDouble();
      if (lb == null) return null;
      return lb / 2.2046226218;
    } catch (_) {
      return null;
    }
  }

  Future<void> _syncLocalProfile(UserProfile profile,
      {double? weightKg}) async {
    final prefs = ref.read(profilePrefsServiceProvider);
    final stored = prefs.load();
    final existing = stored?.userId == profile.id ? stored : null;
    final cached = CachedProfile(
      userId: profile.id,
      email: profile.email,
      username: profile.username,
      sex: profile.sex?.name,
      dateOfBirth: profile.dateOfBirth,
      heightCm: profile.heightCm?.toDouble(),
      weightKg: weightKg ?? existing?.weightKg,
      useMetric: profile.unitPreference == UnitPreference.kg,
      goal: existing?.goal ?? profile.goal?.value,
      experience: existing?.experience ?? profile.experienceLevel?.name,
      frequency: profile.trainingDaysPerWeek ?? existing?.frequency,
      equipment: profile.equipmentPreference ?? existing?.equipment,
      onboarded: profile.onboarded,
      photoUrl: profile.photoUrl ?? existing?.photoUrl,
    );
    await prefs.save(cached);
    ref.read(cachedProfileProvider.notifier).state = cached;
  }

  Future<void> _clearLocalProfile() async {
    await ref.read(profilePrefsServiceProvider).clear();
    ref.read(cachedProfileProvider.notifier).state = null;
  }

  /// Persist full profile-setup answers to Supabase + SharedPreferences.
  Future<AuthResult> completeOnboarding(OnboardingState draft) async {
    if (state.session == null) return AuthResult.error('Not signed in');

    final userId = state.session!.user.id;
    final profile = state.profile?.id == userId ? state.profile : null;
    final email = state.session!.user.email ?? profile?.email ?? '';
    final sex = _mapSex(draft.gender);
    final goal = _mapGoal(draft.goal);
    final experience = _mapExperience(draft.experience);
    final dob = '${draft.birthday.year.toString().padLeft(4, '0')}-'
        '${draft.birthday.month.toString().padLeft(2, '0')}-'
        '${draft.birthday.day.toString().padLeft(2, '0')}';
    final heightCm = draft.heightCm.round();
    final username = profile?.username ??
        (email.contains('@') ? email.split('@').first : 'athlete');
    final unit = draft.useMetric ? UnitPreference.kg : UnitPreference.lb;
    final weightLb = draft.weightKg * 2.2046226218;

    try {
      final completed = await ref.read(supabaseClientProvider).rpc(
        'complete_onboarding',
        params: {
          'p_username': username,
          'p_sex': sex?.value,
          'p_date_of_birth': dob,
          'p_height_cm': heightCm,
          'p_unit_preference': unit.value,
          'p_goal': goal?.value,
          'p_experience_level': experience?.name,
          'p_training_days_per_week': draft.frequency,
          'p_equipment_preference': draft.equipment,
          'p_weight_lb': double.parse(weightLb.toStringAsFixed(2)),
        },
      );
      if (completed != true) {
        throw StateError('Supabase did not confirm onboarding completion');
      }

      final cached = CachedProfile(
        userId: userId,
        email: email,
        username: username,
        sex: sex?.name,
        dateOfBirth: dob,
        heightCm: draft.heightCm,
        weightKg: draft.weightKg,
        useMetric: draft.useMetric,
        goal: draft.goal,
        equipment: draft.equipment,
        experience: draft.experience,
        frequency: draft.frequency,
        onboarded: true,
      );
      await ref.read(profilePrefsServiceProvider).save(cached);
      ref.read(cachedProfileProvider.notifier).state = cached;
      if (state.profile?.id == userId) {
        state =
            state.copyWith(profile: state.profile!.copyWith(onboarded: true));
      }

      await _loadProfile(userId);
      return AuthResult.success();
    } catch (e) {
      _authDebug('completeOnboarding failed', e);
      // Keep the draft for retry, but never treat an unsynced profile as complete.
      final cached = CachedProfile(
        userId: userId,
        email: email,
        username: username,
        sex: sex?.name,
        dateOfBirth: dob,
        heightCm: draft.heightCm,
        weightKg: draft.weightKg,
        useMetric: draft.useMetric,
        goal: draft.goal,
        equipment: draft.equipment,
        experience: draft.experience,
        frequency: draft.frequency,
        onboarded: false,
      );
      await ref.read(profilePrefsServiceProvider).save(cached);
      ref.read(cachedProfileProvider.notifier).state = cached;
      return AuthResult.error(
        'Could not save your setup to the server. Check your connection and try again.',
      );
    }
  }

  static UserSex? _mapSex(String? gender) {
    switch ((gender ?? '').toLowerCase()) {
      case 'male':
        return UserSex.male;
      case 'female':
        return UserSex.female;
      default:
        return null;
    }
  }

  static TrainingGoal? _mapGoal(String? goal) {
    switch (goal) {
      case 'Build Muscle':
        return TrainingGoal.buildMuscle;
      case 'Gain Strength':
        return TrainingGoal.strength;
      case 'Lose Weight':
        return TrainingGoal.fatLoss;
      case 'Tone Up':
        return TrainingGoal.muscle;
      case 'General Fitness':
        return TrainingGoal.generalFitness;
      default:
        return goal == null ? null : TrainingGoal.generalFitness;
    }
  }

  static ExperienceLevel? _mapExperience(String? experience) {
    switch ((experience ?? '').toLowerCase()) {
      case 'beginner':
        return ExperienceLevel.beginner;
      case 'intermediate':
        return ExperienceLevel.intermediate;
      case 'advanced':
        return ExperienceLevel.advanced;
      default:
        return null;
    }
  }

  Future<bool> _checkHasProgram(String userId) async {
    try {
      final response = await ref
          .read(supabaseClientProvider)
          .from('programs')
          .select('id')
          .eq('user_id', userId)
          .limit(1);
      return response.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<AuthResult> signUp(String email, String password,
      {String? referralCode}) async {
    try {
      _authDebug('signUp → $email redirect=${SupabaseConfig.authCallbackUrl}');
      final response = await ref.read(supabaseClientProvider).auth.signUp(
            email: email,
            password: password,
            emailRedirectTo: SupabaseConfig.authCallbackUrl,
          );

      if (response.session != null) {
        _authDebug('signUp session ready user=${response.session!.user.id}');
        await _loadProfile(response.session!.user.id);
        return AuthResult.success(needsVerification: false);
      }

      // Check if user already exists (enumeration protection)
      if (response.user?.identities?.isEmpty ?? false) {
        _authDebug('signUp email already registered');
        return AuthResult.error(
            'This email is already registered. Please sign in.');
      }

      _authDebug('signUp needs email verification user=${response.user?.id}');
      return AuthResult.success(needsVerification: true);
    } on AuthException catch (e) {
      _authDebug('signUp AuthException', e.message);
      final msg = e.message.toLowerCase();
      if (msg.contains('rate limit') ||
          msg.contains('over_email_send_rate_limit')) {
        return AuthResult.error(
          'Email rate limit reached. Wait a few minutes, then try signing up again.',
        );
      }
      if (msg.contains('already registered') ||
          msg.contains('already been registered')) {
        return AuthResult.error(
            'This email is already registered. Please sign in.');
      }
      return AuthResult.error(e.message);
    } catch (e) {
      _authDebug('signUp failed', e);
      return AuthResult.error('Failed to create account');
    }
  }

  Future<AuthResult> verifySignupOtp(String email, String token) async {
    try {
      final response = await ref
          .read(supabaseClientProvider)
          .auth
          .verifyOTP(email: email, token: token, type: OtpType.signup);

      if (response.session != null) {
        await _loadProfile(response.session!.user.id);
        return AuthResult.success();
      }
      return AuthResult.error('Failed to verify code');
    } catch (e) {
      return AuthResult.error('Failed to verify the code');
    }
  }

  Future<AuthResult> resendSignupOtp(String email) async {
    try {
      _authDebug('resendSignupOtp → $email');
      await ref.read(supabaseClientProvider).auth.resend(
            type: OtpType.signup,
            email: email,
            emailRedirectTo: SupabaseConfig.authCallbackUrl,
          );
      _authDebug('resendSignupOtp success');
      return AuthResult.success();
    } on AuthException catch (e) {
      _authDebug('resendSignupOtp AuthException', e.message);
      final msg = e.message.toLowerCase();
      if (msg.contains('rate limit') ||
          msg.contains('over_email_send_rate_limit')) {
        return AuthResult.error(
          'Email rate limit reached. Wait 30–60 seconds, then try again.',
        );
      }
      return AuthResult.error(e.message);
    } catch (e) {
      _authDebug('resendSignupOtp failed', e);
      return AuthResult.error('Failed to resend the code');
    }
  }

  Future<AuthResult> signIn(String email, String password) async {
    try {
      _authDebug('signIn → $email');
      final response = await ref
          .read(supabaseClientProvider)
          .auth
          .signInWithPassword(email: email, password: password);

      if (response.session != null) {
        _authDebug('signIn success user=${response.session!.user.id}');
        await _loadProfile(response.session!.user.id);
        return AuthResult.success();
      }
      return AuthResult.error('Invalid email or password');
    } on AuthException catch (e) {
      _authDebug('signIn AuthException', e.message);
      final msg = e.message.toLowerCase();
      if (msg.contains('email not confirmed') ||
          msg.contains('not confirmed')) {
        return AuthResult.error(
          'Confirm your email first. Check your inbox for the Fitzella code.',
        );
      }
      if (msg.contains('invalid login') ||
          msg.contains('invalid credentials') ||
          msg.contains('invalid_credentials')) {
        return AuthResult.error('Invalid email or password');
      }
      return AuthResult.error(e.message);
    } catch (e) {
      _authDebug('signIn failed', e);
      return AuthResult.error('Failed to sign in. Please try again.');
    }
  }

  Future<AuthResult> sendPasswordResetOtp(String email) async {
    try {
      _authDebug('resetPasswordForEmail → $email');
      await ref.read(supabaseClientProvider).auth.resetPasswordForEmail(
            email,
            redirectTo: SupabaseConfig.authCallbackUrl,
          );
      _authDebug('resetPasswordForEmail success');
      return AuthResult.success();
    } on AuthException catch (e) {
      _authDebug('resetPasswordForEmail AuthException', e.message);
      final msg = e.message.toLowerCase();
      if (msg.contains('rate limit') ||
          msg.contains('over_email_send_rate_limit')) {
        return AuthResult.error(
          'Email rate limit reached. Wait 30–60 seconds, then try again.',
        );
      }
      return AuthResult.error(e.message);
    } catch (e) {
      _authDebug('resetPasswordForEmail failed', e);
      return AuthResult.error('Failed to send the reset code');
    }
  }

  Future<AuthResult> verifyPasswordResetOtp(String email, String token) async {
    try {
      state = state.copyWith(pendingPasswordRecovery: true);
      final response = await ref
          .read(supabaseClientProvider)
          .auth
          .verifyOTP(email: email, token: token, type: OtpType.recovery);

      if (response.session != null) {
        return AuthResult.success();
      }
      state = state.copyWith(pendingPasswordRecovery: false);
      return AuthResult.error('Failed to verify the code');
    } catch (e) {
      state = state.copyWith(pendingPasswordRecovery: false);
      return AuthResult.error('Failed to verify the code');
    }
  }

  Future<AuthResult> completePasswordReset(String newPassword) async {
    try {
      final response = await ref
          .read(supabaseClientProvider)
          .auth
          .updateUser(UserAttributes(password: newPassword));

      if (response.user != null) {
        state = state.copyWith(pendingPasswordRecovery: false);
        // Force a fresh sign-in with the new password.
        await signOut();
        return AuthResult.success();
      }
      return AuthResult.error('Failed to set the new password');
    } catch (e) {
      return AuthResult.error('Failed to set the new password');
    }
  }

  Future<void> cancelPasswordReset() async {
    state = state.copyWith(pendingPasswordRecovery: false);
    if (state.session != null) {
      await ref.read(supabaseClientProvider).auth.signOut();
    }
  }

  Future<void> signOut() async {
    await _clearLocalProfile();
    await ref.read(supabaseClientProvider).auth.signOut();
  }

  Future<AuthResult> deleteAccount() async {
    if (state.session == null) return AuthResult.error('Not signed in');

    try {
      await ref.read(supabaseClientProvider).functions.invoke('delete-account');
      await signOut();
      return AuthResult.success();
    } catch (e) {
      return AuthResult.error('Failed to delete account');
    }
  }

  Future<AuthResult> updateMode(UserMode mode) async {
    if (state.session == null) return AuthResult.error('Not signed in');

    try {
      await ref
          .read(supabaseClientProvider)
          .from('users')
          .update({'mode': mode.value}).eq('id', state.session!.user.id);

      if (state.profile != null) {
        state = state.copyWith(profile: state.profile!.copyWith(mode: mode));
      }
      return AuthResult.success();
    } catch (e) {
      return AuthResult.error('Failed to update mode');
    }
  }

  Future<AuthResult> updateUnitPreference(UnitPreference unit) async {
    if (state.session == null) return AuthResult.error('Not signed in');

    try {
      await ref.read(supabaseClientProvider).from('users').update(
          {'unit_preference': unit.value}).eq('id', state.session!.user.id);

      if (state.profile != null) {
        state = state.copyWith(
            profile: state.profile!.copyWith(unitPreference: unit));
      }
      return AuthResult.success();
    } catch (e) {
      return AuthResult.error('Failed to update unit preference');
    }
  }

  Future<AuthResult> updateThemePreference(ThemePreference preference) async {
    if (state.session == null) return AuthResult.error('Not signed in');

    try {
      await ref
          .read(supabaseClientProvider)
          .from('users')
          .update({'theme_preference': preference.value}).eq(
              'id', state.session!.user.id);

      if (state.profile != null) {
        state = state.copyWith(
            profile: state.profile!.copyWith(themePreference: preference));
      }
      return AuthResult.success();
    } catch (e) {
      return AuthResult.error('Failed to update theme preference');
    }
  }

  Future<AuthResult> updateSex(UserSex? sex) async {
    if (state.session == null) return AuthResult.error('Not signed in');

    try {
      await ref
          .read(supabaseClientProvider)
          .from('users')
          .update({'sex': sex?.value}).eq('id', state.session!.user.id);

      if (state.profile != null) {
        state = state.copyWith(profile: state.profile!.copyWith(sex: sex));
      }
      return AuthResult.success();
    } catch (e) {
      return AuthResult.error('Failed to update sex');
    }
  }

  Future<AuthResult> updateUsername(String username) async {
    if (state.session == null) return AuthResult.error('Not signed in');

    try {
      final trimmed = username.trim();
      await ref
          .read(supabaseClientProvider)
          .from('users')
          .update({'username': trimmed.isEmpty ? null : trimmed}).eq(
              'id', state.session!.user.id);

      if (state.profile != null) {
        state = state.copyWith(
            profile: state.profile!
                .copyWith(username: trimmed.isEmpty ? null : trimmed));
      }
      return AuthResult.success();
    } catch (e) {
      return AuthResult.error('Failed to update username');
    }
  }

  Future<AuthResult> updateDateOfBirth(String? dob) async {
    if (state.session == null) return AuthResult.error('Not signed in');

    try {
      await ref
          .read(supabaseClientProvider)
          .from('users')
          .update({'date_of_birth': dob}).eq('id', state.session!.user.id);

      if (state.profile != null) {
        state =
            state.copyWith(profile: state.profile!.copyWith(dateOfBirth: dob));
      }
      return AuthResult.success();
    } catch (e) {
      return AuthResult.error('Failed to update date of birth');
    }
  }

  Future<AuthResult> updatePhotoUrl(String? photoUrl) async {
    if (state.session == null) return AuthResult.error('Not signed in');

    try {
      await ref
          .read(supabaseClientProvider)
          .from('users')
          .update({'photo_url': photoUrl}).eq('id', state.session!.user.id);

      if (state.profile != null) {
        state = state.copyWith(
            profile: state.profile!.copyWith(photoUrl: photoUrl));
      }

      final prefs = ref.read(profilePrefsServiceProvider);
      final existing = prefs.load() ?? const CachedProfile();
      final updated = existing.copyWith(
        photoUrl: photoUrl,
        clearPhotoUrl: photoUrl == null,
      );
      await prefs.save(updated);
      ref.read(cachedProfileProvider.notifier).state = updated;

      return AuthResult.success();
    } catch (e) {
      return AuthResult.error('Failed to update photo');
    }
  }

  /// Uploads [bytes] to the public `avatars` bucket and stores the public URL
  /// on the user row. Path is always `{userId}/avatar.<ext>` so re-uploads
  /// overwrite the previous object (upsert).
  Future<AuthResult> uploadProfilePhoto(
    Uint8List bytes, {
    String fileName = 'avatar.jpg',
  }) async {
    if (state.session == null) return AuthResult.error('Not signed in');

    try {
      final userId = state.session!.user.id;
      final ext = _avatarExtension(fileName);
      final path = '$userId/avatar.$ext';
      final client = ref.read(supabaseClientProvider);

      await client.storage.from('avatars').uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(
              contentType: _avatarContentType(ext),
              upsert: true,
            ),
          );

      final publicUrl = client.storage.from('avatars').getPublicUrl(path);
      // Bust CDN/browser cache so the new image shows immediately.
      final photoUrl = '$publicUrl?t=${DateTime.now().millisecondsSinceEpoch}';
      return updatePhotoUrl(photoUrl);
    } catch (e) {
      _authDebug('uploadProfilePhoto failed', e);
      return AuthResult.error('Failed to upload photo');
    }
  }

  Future<AuthResult> removeProfilePhoto() async {
    if (state.session == null) return AuthResult.error('Not signed in');

    try {
      final userId = state.session!.user.id;
      final client = ref.read(supabaseClientProvider);
      // Best-effort delete of known extensions; ignore missing objects.
      try {
        await client.storage.from('avatars').remove([
          '$userId/avatar.jpg',
          '$userId/avatar.jpeg',
          '$userId/avatar.png',
          '$userId/avatar.webp',
        ]);
      } catch (_) {}
      return updatePhotoUrl(null);
    } catch (e) {
      _authDebug('removeProfilePhoto failed', e);
      return AuthResult.error('Failed to remove photo');
    }
  }

  String _avatarExtension(String fileName) {
    final dot = fileName.lastIndexOf('.');
    if (dot < 0 || dot == fileName.length - 1) return 'jpg';
    final ext = fileName.substring(dot + 1).toLowerCase();
    return switch (ext) {
      'png' || 'jpg' || 'jpeg' || 'webp' => ext == 'jpeg' ? 'jpg' : ext,
      _ => 'jpg',
    };
  }

  String _avatarContentType(String ext) => switch (ext) {
        'png' => 'image/png',
        'webp' => 'image/webp',
        _ => 'image/jpeg',
      };

  Future<AuthResult> updateHeightCm(int? heightCm) async {
    if (state.session == null) return AuthResult.error('Not signed in');

    try {
      await ref
          .read(supabaseClientProvider)
          .from('users')
          .update({'height_cm': heightCm}).eq('id', state.session!.user.id);

      if (state.profile != null) {
        state = state.copyWith(
            profile: state.profile!.copyWith(heightCm: heightCm));
      }
      return AuthResult.success();
    } catch (e) {
      return AuthResult.error('Failed to update height');
    }
  }

  Future<AuthResult> updateOnboardingFields({
    TrainingGoal? goal,
    ExperienceLevel? experienceLevel,
    int? trainingDaysPerWeek,
    bool? emailOptIn,
    String? referralSource,
  }) async {
    if (state.session == null) return AuthResult.error('Not signed in');

    try {
      final updates = <String, dynamic>{};
      if (goal != null) updates['goal'] = goal.value;
      if (experienceLevel != null)
        updates['experience_level'] = experienceLevel.value;
      if (trainingDaysPerWeek != null)
        updates['training_days_per_week'] = trainingDaysPerWeek;
      if (emailOptIn != null) updates['email_opt_in'] = emailOptIn;
      if (referralSource != null) updates['referral_source'] = referralSource;

      await ref
          .read(supabaseClientProvider)
          .from('users')
          .update(updates)
          .eq('id', state.session!.user.id);

      if (state.profile != null) {
        state = state.copyWith(
            profile: state.profile!.copyWith(
          goal: goal ?? state.profile!.goal,
          experienceLevel: experienceLevel ?? state.profile!.experienceLevel,
          trainingDaysPerWeek:
              trainingDaysPerWeek ?? state.profile!.trainingDaysPerWeek,
          emailOptIn: emailOptIn ?? state.profile!.emailOptIn,
          referralSource: referralSource ?? state.profile!.referralSource,
        ));
      }
      return AuthResult.success();
    } catch (e) {
      return AuthResult.error('Failed to update onboarding fields');
    }
  }

  Future<AuthResult> markOnboarded() async {
    if (state.session == null) return AuthResult.error('Not signed in');

    try {
      await ref
          .read(supabaseClientProvider)
          .from('users')
          .update({'onboarded': true}).eq('id', state.session!.user.id);

      if (state.profile != null) {
        state =
            state.copyWith(profile: state.profile!.copyWith(onboarded: true));
      }
      return AuthResult.success();
    } catch (e) {
      return AuthResult.error('Failed to complete onboarding');
    }
  }

  Future<AuthResult> updateNotificationsEnabled(bool enabled) async {
    if (state.session == null) return AuthResult.error('Not signed in');

    try {
      await ref.read(supabaseClientProvider).from('users').update(
          {'notifications_enabled': enabled}).eq('id', state.session!.user.id);

      if (state.profile != null) {
        state = state.copyWith(
            profile: state.profile!.copyWith(notificationsEnabled: enabled));
      }
      return AuthResult.success();
    } catch (e) {
      return AuthResult.error('Failed to update notifications');
    }
  }

  Future<AuthResult> updateRestTimerEnabled(bool enabled) async {
    if (state.session == null) return AuthResult.error('Not signed in');

    try {
      await ref.read(supabaseClientProvider).from('users').update(
          {'rest_timer_enabled': enabled}).eq('id', state.session!.user.id);

      if (state.profile != null) {
        state = state.copyWith(
            profile: state.profile!.copyWith(restTimerEnabled: enabled));
      }

      return AuthResult.success();
    } catch (e) {
      return AuthResult.error('Failed to update rest timer');
    }
  }

  Future<AuthResult> updateRestTimerDefaultOverride(int? seconds) async {
    if (state.session == null) return AuthResult.error('Not signed in');
    if (seconds != null && (seconds < 0 || seconds > 600)) {
      return AuthResult.error('Rest timer must be between 0 and 600 seconds');
    }
    try {
      await ref.read(supabaseClientProvider).from('users').update({
        'rest_timer_default_override_seconds': seconds,
      }).eq('id', state.session!.user.id);
      if (state.profile != null) {
        state = state.copyWith(
          profile: state.profile!
              .copyWith(restTimerDefaultOverrideSeconds: seconds),
        );
      }
      return AuthResult.success();
    } catch (error) {
      _authDebug('updateRestTimerDefaultOverride failed', error);
      return AuthResult.error('Failed to update rest timer duration');
    }
  }

  Future<AuthResult> updateRpeTrackingEnabled(bool enabled) async {
    if (state.session == null) return AuthResult.error('Not signed in');

    try {
      await ref.read(supabaseClientProvider).from('users').update(
          {'rpe_tracking_enabled': enabled}).eq('id', state.session!.user.id);

      if (state.profile != null) {
        state = state.copyWith(
            profile: state.profile!.copyWith(rpeTrackingEnabled: enabled));
      }
      return AuthResult.success();
    } catch (e) {
      return AuthResult.error('Failed to update RPE tracking');
    }
  }
}

/// Auth result wrapper
@freezed
abstract class AuthResult with _$AuthResult {
  const factory AuthResult.success({@Default(false) bool needsVerification}) =
      _AuthSuccess;
  const factory AuthResult.error(String message) = _AuthError;
}

/// Providers for easy access
@riverpod
Session? currentSession(Ref ref) => ref.watch(authNotifierProvider).session;

@riverpod
UserProfile? currentProfile(Ref ref) => ref.watch(authNotifierProvider).profile;

@riverpod
bool authLoading(Ref ref) => ref.watch(authNotifierProvider).loading;

@riverpod
bool? hasProgram(Ref ref) => ref.watch(authNotifierProvider).hasProgram;

@riverpod
bool pendingPasswordRecovery(Ref ref) =>
    ref.watch(authNotifierProvider).pendingPasswordRecovery;
