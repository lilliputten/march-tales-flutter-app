import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations.byLocale('en') +
      {
        'ru': {
          'Rubric': 'Рубрика',
          'Authors:': 'Авторы:',
          'Tags:': 'Теги:',
          'All rubrics list': 'Список всех рубрик',
          "All rubric's tracks": 'Все треки в рубрике',
        },
      };
  String get i18n => localize(this, _t);
}
