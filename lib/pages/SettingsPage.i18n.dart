import 'package:i18n_extension/i18n_extension.dart';

// import 'package:march_tales_app/sharedTranslationsData.dart';

extension Localization on String {
  static var _t = Translations.byLocale('en') +
      // sharedTranslationsData +
      {
        'ru': {
          'Basic settings': 'Основные настройки',
          'Application info': 'Информация о приложении',
          'Application language': 'Язык приложения',
          'Color scheme': 'Цветовая схема',
          'Light': 'Светлая',
          'Dark': 'Тёмная',
          'Server version:': 'Версия сервера:',
          'Application version:': 'Версия приложения:',
          'Web site:': 'Веб сайт:',
          'Contact e-mail:': 'Контактный e-mail:',
          'Developer:': 'Разработано:',
        },
      };

  String get i18n => localize(this, _t);
}
