import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations.byLocale('en') +
      {
        'ru': {
          'Track': 'Трек',
          'Error loading track data.': 'Ошибка загрузки данных трека.',
        },
      };
  String get i18n => localize(this, _t);
}
