import 'package:i18n_extension/i18n_extension.dart';
import 'package:march_tales_app/sharedTranslations.i18n.dart';

extension Localization on String {
  static var _t = Translations.byLocale('en') +
      sharedTranslationsByLocaleData +
      {
        'ru': {
          'Application language': 'Язык приложения',
          'Version:': 'Версия:',
        },
      };

  String get i18n => localize(this, _t);
}
