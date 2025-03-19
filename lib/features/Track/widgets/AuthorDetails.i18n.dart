import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations.byLocale('en') +
      {
        'ru': {
          'Rubrics:': 'Разделы:',
          'Tags:': 'Теги:',
          'All authors list': 'Список всех авторов',
          "All author's tracks": 'Все треки автора',
        },
      };
  String get i18n => localize(this, _t);
}
