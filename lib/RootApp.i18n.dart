import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations.byLocale('en') +
      {
        'ru': {
          'Your version of the app is outdated.': 'Ваша версия приложения устарела.',
        },
      };

  String get i18n => localize(this, _t);
}
