import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations.byLocale('en') +
      {
        'ru': {
          'Server connection error.': 'Ошибка подключения к серверу.',
        },
      };

  String get i18n => localize(this, _t);
}
