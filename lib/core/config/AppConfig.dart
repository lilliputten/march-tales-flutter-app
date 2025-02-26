// ignore_for_file: constant_identifier_names

/// Environment variables and shared app constants.
abstract class AppConfig {
  // Application run profile
  static const LOCAL = bool.fromEnvironment('LOCAL', defaultValue: false);
  static const DEBUG = bool.fromEnvironment('DEBUG', defaultValue: false);

  static const int PRIMARY_COLOR = int.fromEnvironment('PRIMARY_COLOR', defaultValue: 0xffbb2266);

  // Public resources
  static const String WEB_SITE_PROTOCOL = String.fromEnvironment('WEB_SITE_PROTOCOL', defaultValue: 'https://');
  static const String WEB_SITE_DOMAIN = String.fromEnvironment('WEB_SITE_DOMAIN', defaultValue: 'tales.march.team');
  static const String WEB_SITE_HOST =
      String.fromEnvironment('WEB_SITE_HOST', defaultValue: WEB_SITE_PROTOCOL + WEB_SITE_DOMAIN);
  static const String CONTACT_EMAIL = String.fromEnvironment('CONTACT_EMAIL', defaultValue: 'tales@march.team');
  static const String DEVELOPER_URL = String.fromEnvironment('DEVELOPER_URL', defaultValue: 'lilliputten.com');

  // March Tales API
  static const String TALES_SERVER_HOST = String.fromEnvironment('TALES_SERVER_HOST',
      defaultValue: LOCAL
          ? 'http://10.0.2.2:8000' // Flutter dev.mode VM internal address
          : WEB_SITE_HOST);
  static const String TALES_API_PREFIX = String.fromEnvironment('TALES_API_PREFIX', defaultValue: '/api/v1');
  static const String TALES_AUTH_PREFIX = String.fromEnvironment('TALES_AUTH_PREFIX', defaultValue: '/_allauth/app/v1');

  // Google auth (Is it used?)
  static const String GOOGLE_CLIENT_ID = String.fromEnvironment('GOOGLE_CLIENT_ID', defaultValue: '');
  static const String GOOGLE_CLIENT_SECRET = String.fromEnvironment('GOOGLE_CLIENT_SECRET', defaultValue: '');

  // Google image search (UNUSED)
  static const String GOOGLE_API_KEY = String.fromEnvironment('GOOGLE_API_KEY', defaultValue: '');
  static const String GOOGLE_CSE_ID = String.fromEnvironment('GOOGLE_CSE_ID', defaultValue: '');
}
