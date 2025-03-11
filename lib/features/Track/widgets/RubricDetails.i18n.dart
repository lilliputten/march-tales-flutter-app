import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations.byLocale('en') +
      {
        'ru': {
          'Authors:': 'Авторы:',
          'Tags:': 'Теги:',
          'All rubrics list': 'Список всех рубрик',
          "All rubric's tracks": 'Все треки автора',
        },
      };
  String get i18n => localize(this, _t);
}
