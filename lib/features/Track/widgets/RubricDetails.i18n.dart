import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations.byLocale('en') +
      {
        'ru': {
          'Rubric': 'Раздел',
          'Authors:': 'Авторы:',
          'Tags:': 'Теги:',
          'All rubrics list': 'Список всех разделов',
          "All rubric's tracks": 'Все треки в этом разделе',
        },
      };
  String get i18n => localize(this, _t);
}
