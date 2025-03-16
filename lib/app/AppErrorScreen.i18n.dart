import 'package:i18n_extension/i18n_extension.dart';

import 'package:march_tales_app/sharedTranslationsData.dart';

extension Localization on String {
  static var _t = Translations.byLocale('en') +
      sharedTranslationsData +
      {
        'ru': {
          'Please update the app from the website or from Google Play.':
              'Пожалуйста, обновите приложение с сайта или из Google Play.',
          'Check the network connection and try again later.':
              'Проверьте сетевое подключение и повторите попытку позже.',
        },
      };

  String get i18n => localize(this, _t);
}
