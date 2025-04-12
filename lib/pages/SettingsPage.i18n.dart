import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations.byLocale('en') +
      {
        'ru': {
          "You've been succcessfully logged out": 'Вы успешно вышли из системы',
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
          'Log in to be able to view your favorites and listen to audio on different devices.':
              'Авторизуйтесь, чтобы просматривать избранное и прослушивать аудио на разных устройствах.',
          'Log out': 'Выйти',
          'Open your profile on the web site': 'Откройте свой профиль на веб-сайте',
          'Server version:': 'Версия сервера:',
          'Telegram:': 'Телеграм:',
          'User:': 'Пользователь:',
          'VK:': 'ВК:',
          'Web site:': 'Веб сайт:',
          'YouTube:': 'Ютуб:',
        },
      };
  String get i18n => localize(this, _t);
}
