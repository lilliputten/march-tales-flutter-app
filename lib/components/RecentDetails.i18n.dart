import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations.byLocale('en') +
      {
        'ru': {
          'In numbers': 'В цифрах',
          'The most recent': 'Свежее',
          'Random': 'Случайное',
          'Most popular': 'Популярное',
          'Total tracks:': 'Всего записей:',
          'Total authors:': 'Всего авторов:',
          'Total rubrics:': 'Всего разделов:',
          'Total tags:': 'Всего меток:',
        },
      };
  String get i18n => localize(this, _t);
}
