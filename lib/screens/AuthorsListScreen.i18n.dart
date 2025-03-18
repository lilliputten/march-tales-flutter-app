import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations.byLocale('en') +
      {
        'ru': {
          'Authors list': 'Список авторов',
          'Error loading authors list.': 'Ошибка загрузки списка авторов.',
        },
      };
  String get i18n => localize(this, _t);
}
