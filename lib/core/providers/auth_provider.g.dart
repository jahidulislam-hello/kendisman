// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentSessionHash() => r'9b65100698f3d7b3d9f9dc01167c822c42a12049';

/// Providers for easy access
///
/// Copied from [currentSession].
@ProviderFor(currentSession)
final currentSessionProvider = AutoDisposeProvider<Session?>.internal(
  currentSession,
  name: r'currentSessionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentSessionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentSessionRef = AutoDisposeProviderRef<Session?>;
String _$currentProfileHash() => r'8fcf9e4170eacf6046316f7c7a191275cb7754cf';

/// See also [currentProfile].
@ProviderFor(currentProfile)
final currentProfileProvider = AutoDisposeProvider<UserProfile?>.internal(
  currentProfile,
  name: r'currentProfileProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentProfileRef = AutoDisposeProviderRef<UserProfile?>;
String _$authLoadingHash() => r'1d538bf5647bc73ceb58b500f97c72636660fae1';

/// See also [authLoading].
@ProviderFor(authLoading)
final authLoadingProvider = AutoDisposeProvider<bool>.internal(
  authLoading,
  name: r'authLoadingProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authLoadingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthLoadingRef = AutoDisposeProviderRef<bool>;
String _$hasProgramHash() => r'db1cfc32ca3c77ff5b9b4de0849057374b6b3bef';

/// See also [hasProgram].
@ProviderFor(hasProgram)
final hasProgramProvider = AutoDisposeProvider<bool?>.internal(
  hasProgram,
  name: r'hasProgramProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$hasProgramHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef HasProgramRef = AutoDisposeProviderRef<bool?>;
String _$pendingPasswordRecoveryHash() =>
    r'f77144aba75d4f5d9c7916d56f238d2466168ff8';

/// See also [pendingPasswordRecovery].
@ProviderFor(pendingPasswordRecovery)
final pendingPasswordRecoveryProvider = AutoDisposeProvider<bool>.internal(
  pendingPasswordRecovery,
  name: r'pendingPasswordRecoveryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pendingPasswordRecoveryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PendingPasswordRecoveryRef = AutoDisposeProviderRef<bool>;
String _$authNotifierHash() => r'd5a0f47d5f44ee2e0e0628b10dbb0ed16518dde9';

/// Auth notifier managing authentication state
///
/// Copied from [AuthNotifier].
@ProviderFor(AuthNotifier)
final authNotifierProvider =
    AutoDisposeNotifierProvider<AuthNotifier, AuthState>.internal(
  AuthNotifier.new,
  name: r'authNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthNotifier = AutoDisposeNotifier<AuthState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
