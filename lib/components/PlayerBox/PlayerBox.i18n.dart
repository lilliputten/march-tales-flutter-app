import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations.byLocale('en') +
      {
        'ru': {
          'March Cat Tales': 'Сказки Мартовского Кота',
          'Error loading currently playing track data.': 'Ошибка загрузки данных текущего трека.',
        },
      };
  String get i18n => localize(this, _t);
}
