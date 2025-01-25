// Developed by Marcelo Glasberg (2019) https://glasberg.dev and https://github.com/marcglasberg
// For more info, see: https://pub.dartlang.org/packages/i18n_extension
import 'package:i18n_extension/i18n_extension.dart';

import 'package:march_tales_app/sharedTranslations.i18n.dart';

extension Localization on String {
  //
  static final _t = sharedTranslations * Translations.byText('en') +
      const {
        'en': 'i18n Demo',
        'ru': 'Демо i18n',
        // 'es-ES': 'Demostración i18n',
      };

  String get i18n => localize(this, _t);

  String plural(value) => localizePlural(value, this, _t);

  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
