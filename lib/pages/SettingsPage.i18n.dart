import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations.byLocale('en') +
      {
        'ru': {
          'Application info': 'Информация о приложении',
          'Application language': 'Язык приложения',
          'Application version:': 'Версия приложения:',
          'Authorization': 'Авторизация',
          'Basic settings': 'Основные настройки',
          'Color scheme': 'Цветовая схема',
          'Contact e-mail:': 'Контактный e-mail:',
          'Dark': 'Тёмная',
          'Developer:': 'Разработано:',
          'Light': 'Светлая',
          'Log out': 'Выйти',
          'Server version:': 'Версия сервера:',
          'User:': 'Пользователь:',
          'Web site:': 'Веб сайт:',
        },
      };
  String get i18n => localize(this, _t);
}
