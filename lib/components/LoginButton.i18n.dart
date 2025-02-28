import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations.byLocale('en') +
      {
        'ru': {
          'Log in': 'Войти',
          "You've been succcessfully logged in": 'Вы успешно вошли в систему',
        },
      };
  String get i18n => localize(this, _t);
}
