import 'package:i18n_extension/i18n_extension.dart';

final appTitle = Object();

const appTitleEn = 'The March Cat Tales';
const appTitleRu = 'Сказки Мартовского кота';

final translationsById = Translations.byId('en', {
    appTitle: { 'en': appTitleEn, 'ru': appTitleRu },
  });

final sharedTranslations = translationsById * Translations.byLocale('en') +
    {
      'ru': {appTitleEn: appTitleRu},
    };

extension SharedStringLocalization on String {
  static var _t = translationsById;
  // static var _t = sharedTranslations * Translations.byLocale('en') +
  //     {
  //       'ru': {
  //         'Tracks list': 'Список треков',
  //       },
  //     };
  String get i18n => localize(this, _t);
}

extension SharedObjectLocalization on Object {
  static var _t = sharedTranslations;
  String get i18n => localize(this, _t);
}

