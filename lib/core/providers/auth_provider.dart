import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:fitzella/core/config/supabase_config.dart';
import 'package:fitzella/core/models/profile/user_profile.dart';
import 'package:fitzella/core/services/supabase_service.dart';

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
    try {
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
        state = state.copyWith(profile: null, hasProgram: false, loading: false);
        return;
      }

      final profile = UserProfile.fromJson(response);
      final hasProgram = await _checkHasProgram(userId);

      state = state.copyWith(
        profile: profile,
        hasProgram: hasProgram,
        loading: false,
      );
    } catch (e) {
      _authDebug('_loadProfile failed', e);
      // Keep session; profile can be completed later (e.g. onboarding).
      state = state.copyWith(loading: false);
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

  Future<AuthResult> signUp(String email, String password, {String? referralCode}) async {
    // Dev path: create + confirm via Admin API so signup never hits email rate limits
    // or the dashboard Site URL (localhost) redirect problem.
    if (kDebugMode && SupabaseConfig.hasSecretKey) {
      _authDebug('signUp (debug/admin) → $email');
      return _signUpBypassEmailRateLimit(email, password);
    }

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
        return AuthResult.error('This email is already registered. Please sign in.');
      }

      _authDebug('signUp needs email verification user=${response.user?.id}');
      return AuthResult.success(needsVerification: true);
    } on AuthException catch (e) {
      _authDebug('signUp AuthException', e.message);
      final msg = e.message.toLowerCase();
      if (msg.contains('rate limit') || msg.contains('over_email_send_rate_limit')) {
        _authDebug('signUp rate-limited → admin bypass (no email send)');
        return _signUpBypassEmailRateLimit(email, password);
      }
      if (msg.contains('already registered') || msg.contains('already been registered')) {
        return AuthResult.error('This email is already registered. Please sign in.');
      }
      return AuthResult.error(e.message);
    } catch (e) {
      _authDebug('signUp failed', e);
      return AuthResult.error('Failed to create account');
    }
  }

  /// Creates/confirms the user with Admin API so signup can continue without sending email.
  Future<AuthResult> _signUpBypassEmailRateLimit(String email, String password) async {
    if (!SupabaseConfig.hasSecretKey) {
      return AuthResult.error(
        'Email rate limit reached and no admin bypass configured. Use Sign In if you already registered.',
      );
    }

    try {
      final admin = SupabaseClient(SupabaseConfig.url, SupabaseConfig.secretKey);
      try {
        await admin.auth.admin.createUser(
          AdminUserAttributes(
            email: email,
            password: password,
            emailConfirm: true,
          ),
        );
        _authDebug('admin createUser ok for $email');
      } catch (createErr) {
        _authDebug('admin createUser failed (may already exist)', createErr);
        // Confirm existing user + set password so sign-in works.
        final listed = await admin.auth.admin.listUsers(perPage: 1000);
        User? existing;
        for (final u in listed) {
          if (u.email?.toLowerCase() == email.toLowerCase()) {
            existing = u;
            break;
          }
        }
        if (existing == null) {
          return AuthResult.error(
            'Email rate limit reached and could not create account. Try Sign In or another email.',
          );
        }
        await admin.auth.admin.updateUserById(
          existing.id,
          attributes: AdminUserAttributes(
            emailConfirm: true,
            password: password,
          ),
        );
        _authDebug('admin confirmed existing user ${existing.id}');
      }

      final signedIn = await ref.read(supabaseClientProvider).auth.signInWithPassword(
            email: email,
            password: password,
          );
      if (signedIn.session != null) {
        await _loadProfile(signedIn.session!.user.id);
        _authDebug('bypass success → session ready');
        return AuthResult.success(needsVerification: false);
      }
      return AuthResult.error('Account ready but sign-in failed. Try Sign In.');
    } catch (e) {
      _authDebug('signUp bypass failed', e);
      return AuthResult.error(
        'Email rate limit reached. Try Sign In with this email, or wait and retry.',
      );
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
      if (msg.contains('rate limit') || msg.contains('over_email_send_rate_limit')) {
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
      return AuthResult.error('Invalid credentials');
    } on AuthException catch (e) {
      _authDebug('signIn AuthException', e.message);
      return AuthResult.error(e.message);
    } catch (e) {
      _authDebug('signIn failed', e);
      return AuthResult.error('Failed to sign in');
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
      if (msg.contains('rate limit') || msg.contains('over_email_send_rate_limit')) {
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
          .update({'mode': mode.value})
          .eq('id', state.session!.user.id);
      
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
      await ref
          .read(supabaseClientProvider)
          .from('users')
          .update({'unit_preference': unit.value})
          .eq('id', state.session!.user.id);
      
      if (state.profile != null) {
        state = state.copyWith(profile: state.profile!.copyWith(unitPreference: unit));
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
          .update({'theme_preference': preference.value})
          .eq('id', state.session!.user.id);
      
      if (state.profile != null) {
        state = state.copyWith(profile: state.profile!.copyWith(themePreference: preference));
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
          .update({'sex': sex?.value})
          .eq('id', state.session!.user.id);
      
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
          .update({'username': trimmed.isEmpty ? null : trimmed})
          .eq('id', state.session!.user.id);
      
      if (state.profile != null) {
        state = state.copyWith(profile: state.profile!.copyWith(username: trimmed.isEmpty ? null : trimmed));
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
          .update({'date_of_birth': dob})
          .eq('id', state.session!.user.id);
      
      if (state.profile != null) {
        state = state.copyWith(profile: state.profile!.copyWith(dateOfBirth: dob));
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
          .update({'photo_url': photoUrl})
          .eq('id', state.session!.user.id);
      
      if (state.profile != null) {
        state = state.copyWith(profile: state.profile!.copyWith(photoUrl: photoUrl));
      }
      return AuthResult.success();
    } catch (e) {
      return AuthResult.error('Failed to update photo');
    }
  }

  Future<AuthResult> updateHeightCm(int? heightCm) async {
    if (state.session == null) return AuthResult.error('Not signed in');
    
    try {
      await ref
          .read(supabaseClientProvider)
          .from('users')
          .update({'height_cm': heightCm})
          .eq('id', state.session!.user.id);
      
      if (state.profile != null) {
        state = state.copyWith(profile: state.profile!.copyWith(heightCm: heightCm));
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
      if (experienceLevel != null) updates['experience_level'] = experienceLevel.value;
      if (trainingDaysPerWeek != null) updates['training_days_per_week'] = trainingDaysPerWeek;
      if (emailOptIn != null) updates['email_opt_in'] = emailOptIn;
      if (referralSource != null) updates['referral_source'] = referralSource;
      
      await ref
          .read(supabaseClientProvider)
          .from('users')
          .update(updates)
          .eq('id', state.session!.user.id);
      
      if (state.profile != null) {
        state = state.copyWith(profile: state.profile!.copyWith(
          goal: goal ?? state.profile!.goal,
          experienceLevel: experienceLevel ?? state.profile!.experienceLevel,
          trainingDaysPerWeek: trainingDaysPerWeek ?? state.profile!.trainingDaysPerWeek,
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
          .update({'onboarded': true})
          .eq('id', state.session!.user.id);
      
      if (state.profile != null) {
        state = state.copyWith(profile: state.profile!.copyWith(onboarded: true));
      }
      return AuthResult.success();
    } catch (e) {
      return AuthResult.error('Failed to complete onboarding');
    }
  }

  Future<AuthResult> updateNotificationsEnabled(bool enabled) async {
    if (state.session == null) return AuthResult.error('Not signed in');
    
    try {
      await ref
          .read(supabaseClientProvider)
          .from('users')
          .update({'notifications_enabled': enabled})
          .eq('id', state.session!.user.id);
      
      if (state.profile != null) {
        state = state.copyWith(profile: state.profile!.copyWith(notificationsEnabled: enabled));
      }
      return AuthResult.success();
    } catch (e) {
      return AuthResult.error('Failed to update notifications');
    }
  }

  Future<AuthResult> updateRestTimerEnabled(bool enabled) async {
    if (state.session == null) return AuthResult.error('Not signed in');
    
    try {
      await ref
          .read(supabaseClientProvider)
          .from('users')
          .update({'rest_timer_enabled': enabled})
          .eq('id', state.session!.user.id);
      
      if (state.profile != null) {
        state = state.copyWith(profile: state.profile!.copyWith(restTimerEnabled: enabled));
      }
      return AuthResult.success();
    } catch (e) {
      return AuthResult.error('Failed to update rest timer');
    }
  }

  Future<AuthResult> updateRpeTrackingEnabled(bool enabled) async {
    if (state.session == null) return AuthResult.error('Not signed in');
    
    try {
      await ref
          .read(supabaseClientProvider)
          .from('users')
          .update({'rpe_tracking_enabled': enabled})
          .eq('id', state.session!.user.id);
      
      if (state.profile != null) {
        state = state.copyWith(profile: state.profile!.copyWith(rpeTrackingEnabled: enabled));
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
  const factory AuthResult.success({@Default(false) bool needsVerification}) = _AuthSuccess;
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
bool pendingPasswordRecovery(Ref ref) => ref.watch(authNotifierProvider).pendingPasswordRecovery;