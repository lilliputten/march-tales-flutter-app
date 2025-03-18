import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations.byLocale('en') +
      {
        'ru': {
          'No tracks to display.': 'Нет треков для отображения.',
        },
      };
  String get i18n => localize(this, _t);
}
