import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations.byLocale('en') +
      {
        'ru': {
          'The most recent': 'Свежее',
          'Random': 'Случайное',
        },
      };
  String get i18n => localize(this, _t);
}
