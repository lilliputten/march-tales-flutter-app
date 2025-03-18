import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations.byLocale('en') +
      {
        'ru': {
          'Error loading rubric data.': 'Ошибка загрузки данных раздела.',
          'Rubric': 'Раздел',
        },
      };
  String get i18n => localize(this, _t);
}
