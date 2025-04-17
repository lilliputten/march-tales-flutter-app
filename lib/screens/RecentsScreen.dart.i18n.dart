import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations.byLocale('en') +
      {
        'ru': {
          'Error loading tracks list.': 'Ошибка загрузки списка треков.',
          'Error loading tracks list': 'Ошибка загрузки треков',
        },
      };
  String get i18n => localize(this, _t);
}
