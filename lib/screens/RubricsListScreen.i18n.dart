import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations.byLocale('en') +
      {
        'ru': {
          'Rubrics': 'Разделы',
          'Error loading rubrics list.': 'Ошибка загрузки списка разделов.',
        },
      };
  String get i18n => localize(this, _t);
}
