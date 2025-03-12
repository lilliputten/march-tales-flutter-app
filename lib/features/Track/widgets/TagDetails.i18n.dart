import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations.byLocale('en') +
      {
        'ru': {
          'Tag': 'Тег',
          'Authors:': 'Авторы:',
          'Tags:': 'Теги:',
          'Rubrics:': 'Рубрики:',
          'All tags': 'Список всех тегов',
          "All tag's tracks": 'Все треки с этим тегом',
        },
      };
  String get i18n => localize(this, _t);
}
