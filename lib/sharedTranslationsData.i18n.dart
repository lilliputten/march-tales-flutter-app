import 'package:i18n_extension/i18n_extension.dart';

import 'package:march_tales_app/sharedTranslationsData.dart';

extension Localization on String {
  static var _t = Translations.byLocale('en') + sharedTranslationsData;

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
