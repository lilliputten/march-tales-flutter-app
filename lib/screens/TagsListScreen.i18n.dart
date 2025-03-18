import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations.byLocale('en') +
      {
        'ru': {
          'Tags list': 'Список тегов',
          'Error loading tags list.': 'Ошибка загрузки списка тегов.',
        },
      };
  String get i18n => localize(this, _t);
}
