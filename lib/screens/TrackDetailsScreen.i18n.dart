import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations.byLocale('en') +
      {
        'ru': {
          'Error loading track data.': 'Ошибка загрузки данных аудио записи.',
        },
      };
  String get i18n => localize(this, _t);
}
