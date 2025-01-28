import 'package:flutter/material.dart';
import 'package:march_tales_app/Init.dart';
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
    // final colorScheme = Theme.of(context).colorScheme;
    // final appState = context.watch<MyAppState>();
    // var projectInfo = appState.projectInfo;

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

final themeItems = [
  {'value': ThemeMode.light.toString(), 'text': 'Light'.i18n},
  {'value': ThemeMode.dark.toString(), 'text': 'Dark'.i18n},
];

class ThemeSelector extends StatelessWidget {
  getThemesList(String currentThemeCode) {
    // final List<DropdownMenuItem<String>> list = [];
    return themeItems.map((item) {
      return DropdownMenuItem<String>(
        value: item['value'],
        // enabled: code != currentThemeCode,
        child: Text(item['text']!),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final colorScheme = Theme.of(context).colorScheme;
    final currentThemeCode = appState.themeMode.toString();
    final items = getThemesList(currentThemeCode);
    // logger.d('ThemeSelector items: ${items} currentThemeCode: ${currentThemeCode}');
    return DropdownButtonFormField<String>(
      iconDisabledColor: Colors.white,
      decoration: InputDecoration(
        filled: true,
        labelText: 'Color theme'.i18n,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      value: currentThemeCode,
      elevation: 16,
      style: TextStyle(color: colorScheme.primary),
      onChanged: (String? themeCode) {
        if (themeCode != null) {
          appState.toggleTheme(themeCode == ThemeMode.dark.toString()
              ? ThemeMode.dark
              : ThemeMode.light);
        }
      },
      // TODO; Make selected item distinctive using `selectedItemBuilder`
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
    // logger.d('LanguageSelector items: ${items} currentLanguageCode: ${currentLanguageCode}');
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
      // TODO; Make selected item distinctive using `selectedItemBuilder`
      items: items,
    );
  }
}

class AppInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodySmall!;

    final appVersion = Init.appVersion;
    final appTimestamp = Init.appTimestamp;
    final serverVersion = Init.serverVersion;
    final serverTimestamp = Init.serverTimestamp;

    logger.d('AppInfo appVersion: ${appVersion}');

    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 5,
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
        // TODO: Show other info (developer, project site etc)
      ],
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
          LanguageSelector(),
          ThemeSelector(),
          AppInfo(),
        ],
      ),
    );
  }
}
