import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations.byLocale('en') +
      {
        'ru': {
          'Error loading tracks list.': '',
          'Error loading track details.': 'Ошибка загрузки списка треков.',
          'Track': 'Трек',
        },
      };
  String get i18n => localize(this, _t);
}
