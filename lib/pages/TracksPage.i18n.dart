import 'package:i18n_extension/i18n_extension.dart';
import 'package:march_tales_app/sharedTranslationsData.dart';

extension Localization on String {
  static var _t = Translations.byLocale('en') +
      sharedTranslationsData +
      {
        'ru': {
          'No tracks loaded': 'Не загружено треков',
          'Load more...': 'Загрузить ещё...',
          'Loading...': 'Загрузка...',
        },
      };

  String get i18n => localize(this, _t);
}
