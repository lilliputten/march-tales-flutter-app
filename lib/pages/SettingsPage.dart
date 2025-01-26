import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:march_tales_app/supportedLocales.dart';
import 'package:provider/provider.dart';
import 'package:i18n_extension/i18n_extension.dart';

import 'package:march_tales_app/shared/states/MyAppState.dart';

import 'TracksPage.i18n.dart';

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
              child: settingsWidget(context),
            ),
          ),
        ),
      ],
    );
  }
}

// TODO: Move to language helpers
getLanguagesList() {
  final List<DropdownMenuItem<String>> list = [];
  localeNames.forEach((k, v) {
    final item = DropdownMenuItem<String>(
      value: k,
      child: Text(v),
    );
    list.add(item);
  });
  return list;
}

Widget languageSelector(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  final currentLang = context.locale;
  final items = getLanguagesList();
  return DropdownButtonFormField<String>(
    decoration: InputDecoration(
      filled: true,
      labelText: 'Application language'.i18n,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    ),
    value: currentLang.toString(),
    elevation: 16,
    style: TextStyle(color: colorScheme.primary),
    onChanged: (String? value) {
      if (value != null) {
        context.locale = Locale(value);
      }
    },
    items: items,
  );
}

Widget settingsWidget(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        languageSelector(context),
      ],
    ),
  );
}
