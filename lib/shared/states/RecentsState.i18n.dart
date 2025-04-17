import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations.byLocale('en') +
      {
        'ru': {
          'Error loading recent data.': 'Ошибка загрузки актуальных данных.',
        },
      };
  String get i18n => localize(this, _t);
}
