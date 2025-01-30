import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter/services.dart';
import 'package:march_tales_app/Init.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import 'package:i18n_extension/i18n_extension.dart';

import 'package:march_tales_app/core/server/ServerSession.dart';
import 'package:march_tales_app/shared/states/MyAppState.dart';
import 'package:march_tales_app/supportedLocales.dart';

import 'SettingsPage.i18n.dart';

final logger = Logger();

// @see https://docs.flutter.dev/cookbook/networking/fetch-data
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: SettingsWidget(),
            ),
          ),
        ),
      ],
    );
  }
}

class ThemeSelector extends StatelessWidget {
  final themeItems = [
    {'value': false, 'text': 'Light'.i18n},
    {'value': true, 'text': 'Dark'.i18n},
  ];

  getThemesList(bool currentIsDarkTheme) {
    // final List<DropdownMenuItem<String>> list = [];
    return themeItems.map((item) {
      return DropdownMenuItem<String>(
        value: item['value'].toString(),
        // enabled: code != currentIsDarkTheme,
        child: Text(item['text'].toString()),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final colorScheme = Theme.of(context).colorScheme;
    final currentIsDarkTheme = appState.isDarkTheme;
    final items = getThemesList(currentIsDarkTheme);
    return DropdownButtonFormField<String>(
      iconDisabledColor: Colors.white,
      decoration: InputDecoration(
        filled: true,
        labelText: 'Color scheme'.i18n,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      value: currentIsDarkTheme.toString(),
      elevation: 16,
      style: TextStyle(color: colorScheme.primary),
      onChanged: (String? value) {
        if (value != null) {
          final bool isDarkTheme = value.toLowerCase() == 'true';
          appState.toggleDarkTheme(isDarkTheme);
        }
      },
      // TODO; Make selected item distinctive using `selectedItemBuilder`?
      items: items,
    );
  }
}

class LanguageSelector extends StatelessWidget {
  getLanguagesList(String currentLanguageCode) {
    final List<DropdownMenuItem<String>> list = [];
    localeNames.forEach((code, text) {
      final item = DropdownMenuItem<String>(
        value: code,
        // enabled: code != currentLanguageCode,
        child: Text(text),
      );
      list.add(item);
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final colorScheme = Theme.of(context).colorScheme;
    final currentLanguageCode = context.locale.languageCode;
    final items = getLanguagesList(currentLanguageCode);
    return DropdownButtonFormField<String>(
      iconDisabledColor: Colors.white,
      decoration: InputDecoration(
        filled: true,
        labelText: 'Application language'.i18n,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      value: currentLanguageCode,
      elevation: 16,
      style: TextStyle(color: colorScheme.primary),
      onChanged: (String? locale) {
        if (locale != null) {
          serverSession.updateLocale(locale);
          // Update locale in the context store
          appState.updateLocale(locale);
          // Set system locale
          context.locale = Locale(locale);
        }
      },
      // TODO; Make selected item distinctive using `selectedItemBuilder`?
      items: items,
    );
  }
}

class AppInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodySmall!;
    final linkStyle = style.copyWith(
      decoration: TextDecoration.underline,
      color: Colors.blue,
      decorationColor: Colors.blue,
    );

    final appVersion = Init.appVersion;
    final appTimestamp = Init.appTimestamp;
    final serverVersion = Init.serverVersion;
    final serverTimestamp = Init.serverTimestamp;

    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SelectableText(
              'Application version:'.i18n,
              style: style,
            ),
            SelectableText(
              appVersion!,
              style: style.copyWith(fontWeight: FontWeight.bold),
            ),
            SelectableText('/',
                style: style.copyWith(fontWeight: FontWeight.w200)),
            SelectableText(appTimestamp!,
                style: style.copyWith(fontWeight: FontWeight.w300)),
          ],
        ),
        Wrap(
          spacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SelectableText(
              'Server version:'.i18n,
              style: style,
            ),
            SelectableText(
              serverVersion!,
              style: style.copyWith(fontWeight: FontWeight.bold),
            ),
            SelectableText('/',
                style: style.copyWith(fontWeight: FontWeight.w200)),
            SelectableText(serverTimestamp!,
                style: style.copyWith(fontWeight: FontWeight.w300)),
          ],
        ),
        Wrap(
          spacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SelectableText(
              'Web site:'.i18n,
              style: style,
            ),
            InkWell(
              onTap: () =>
                  launchUrl(Uri.parse('https://${AppConfig.WEB_SITE_URL}')),
              child: Text(
                AppConfig.WEB_SITE_URL,
                style: linkStyle,
              ),
            ),
          ],
        ),
        Wrap(
          spacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SelectableText(
              'Contact e-mail:'.i18n,
              style: style,
            ),
            InkWell(
              onTap: () =>
                  launchUrl(Uri.parse('mailto:${AppConfig.CONTACT_EMAIL}')),
              child: Text(
                AppConfig.CONTACT_EMAIL,
                style: linkStyle,
              ),
            ),
          ],
        ),
        Wrap(
          spacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SelectableText(
              'Developer:'.i18n,
              style: style,
            ),
            InkWell(
              onTap: () =>
                  launchUrl(Uri.parse('https://${AppConfig.DEVELOPER_URL}')),
              child: Text(
                AppConfig.DEVELOPER_URL,
                style: linkStyle,
              ),
            ),
          ],
        ),
        // TODO: Show other info (developer, project site etc)
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textStyle = theme.textTheme.bodyLarge!.copyWith(
      color: colorScheme.primary,
      // fontWeight: FontWeight.bold,
    );
    final delimiterColor = colorScheme.onSurface.withValues(alpha: 0.2);
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.5, color: delimiterColor),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        child: Center(child: Text(title, style: textStyle)),
      ),
    );
  }
}

class SettingsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 20,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionTitle(title: 'Basic settings'.i18n),
          LanguageSelector(),
          ThemeSelector(),
          SectionTitle(title: 'Application info'.i18n),
          AppInfo(),
        ],
      ),
    );
  }
}
