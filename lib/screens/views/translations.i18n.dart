import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations.byLocale('en') +
      {
        'ru': {
          'All tags': 'Все теги',
          'All rubrics': 'Все рубрики',
          'All authors': 'Все авторы',
          "Other author's tracks": 'Другие треки автора',
        },
      };
  String get i18n => localize(this, _t);
}
