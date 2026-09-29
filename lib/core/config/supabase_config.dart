/// Supabase project config for Fitzella.
class SupabaseConfig {
  static const String url = 'https://wpknvsnroppszmkofmdk.supabase.co';

  /// Deep link used after email confirm / password reset.
  static const String authCallbackUrl = 'io.fitzella.app://login-callback/';

  static const String publishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: _publishableKeyFallback,
  );

  static const String _publishableKeyFallback =
      'sb_publishable_ch3WrpBjn7vHhw6HZjgKBw_k5Pyy9c0';

  static bool get isConfigured =>
      url.isNotEmpty &&
      publishableKey.isNotEmpty &&
      (publishableKey.startsWith('sb_publishable_') ||
          publishableKey.startsWith('eyJ'));
}
