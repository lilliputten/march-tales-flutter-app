import 'package:i18n_extension/i18n_extension.dart';
// import 'package:march_tales_app/sharedTranslationsData.dart';

extension Localization on String {
  static var _t = Translations.byLocale('en') +
      // sharedTranslationsData +
      {
        'ru': {
          'Application language': 'Язык приложения',
          'Server version:': 'Версия сервера:',
          'Application version:': 'Версия приложения:',
          'Color scheme': 'Цветовая схема',
          'Light': 'Светлая',
          'Dark': 'Тёмная',
        },
      };

  String get i18n => localize(this, _t);
}
