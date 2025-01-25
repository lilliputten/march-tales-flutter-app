import 'package:i18n_extension/i18n_extension.dart';

import 'package:march_tales_app/sharedTranslations.i18n.dart';

extension Localization on String {
  static var _t = sharedTranslations * Translations.byLocale('en') +
      {
        'ru': {
          'Tracks list': 'Список треков',
        },
      };

  String get i18n => localize(this, _t);
}
