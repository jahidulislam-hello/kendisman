import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:fitzella/core/config/supabase_config.dart';
import 'package:fitzella/core/services/api_logger.dart';

part 'supabase_service.g.dart';

/// Supabase client provider
@riverpod
SupabaseClient supabaseClient(Ref ref) {
  return Supabase.instance.client;
}

/// Initialize Supabase - call this in main.dart before runApp
Future<void> initializeSupabase() async {
  if (!SupabaseConfig.isConfigured) {
    throw StateError(
      'Supabase publishable key missing. Set _publishableKeyFallback in '
      'lib/core/config/supabase_config.dart or pass '
      '--dart-define=SUPABASE_PUBLISHABLE_KEY=...',
    );
  }

  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
    httpClient: ApiLoggingClient(),
    authOptions: FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
      detectSessionInUriPredicate: (uri) =>
          uri.host == 'login-callback' || uri.path.contains('login-callback'),
    ),
  );
}

/// Auth state changes stream
@riverpod
Stream<AuthState> authStateChanges(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return client.auth.onAuthStateChange;
}

/// Current session provider
@riverpod
Session? currentSession(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return client.auth.currentSession;
}

/// Current user provider
@riverpod
User? currentUser(Ref ref) {
  final session = ref.watch(currentSessionProvider);
  return session?.user;
}