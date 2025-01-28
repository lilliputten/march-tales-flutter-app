import 'package:i18n_extension/i18n_extension.dart';
import 'package:march_tales_app/sharedTranslations.i18n.dart';

extension Localization on String {
  static var _t = Translations.byLocale('en') + sharedTranslationsByLocaleData
      // + {
      //   'ru': {
      //     'The March Cat Tales': 'Сказки Мартовского кота',
      //   },
      // }
      ;

  String get i18n => localize(this, _t);
}

final appTitle = Object();

final sharedTranslationsByIdData = {
  appTitle: {'en': appTitleEn, 'ru': appTitleRu},
};

extension SharedObjectLocalization on Object {
  static var _t = Translations.byId('en', sharedTranslationsByIdData);
  String get i18n => localize(this, _t);
}
