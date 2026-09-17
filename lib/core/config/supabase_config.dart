/// Supabase project config for Fitzella.
class SupabaseConfig {
  static const String url = 'https://wpknvsnroppszmkofmdk.supabase.co';

  /// Deep link used after email confirm / password reset.
  static const String authCallbackUrl = 'io.fitzella.app://login-callback/';

  static const String publishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: _publishableKeyFallback,
  );

  /// DEV ONLY — used to bypass email rate limits (admin create/confirm).
  /// Do not ship a production build with this baked in.
  static const String secretKey = String.fromEnvironment(
    'SUPABASE_SECRET_KEY',
    defaultValue: _secretKeyFallback,
  );

  static const String _publishableKeyFallback =
      'sb_publishable_ch3WrpBjn7vHhw6HZjgKBw_k5Pyy9c0';

  static const String _secretKeyFallback =
      'sb_secret_JRAKCTfo1UCIK9bzfntGDQ_DazbikWz';

  static bool get isConfigured =>
      url.isNotEmpty &&
      publishableKey.isNotEmpty &&
      (publishableKey.startsWith('sb_publishable_') ||
          publishableKey.startsWith('eyJ'));

  static bool get hasSecretKey =>
      secretKey.isNotEmpty &&
      (secretKey.startsWith('sb_secret_') || secretKey.startsWith('eyJ'));
}
