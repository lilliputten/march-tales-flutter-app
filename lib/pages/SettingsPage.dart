import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:i18n_extension/i18n_extension.dart';

import 'package:march_tales_app/shared/states/MyAppState.dart';

final logger = Logger();

// @see https://docs.flutter.dev/cookbook/networking/fetch-data
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appState = context.watch<MyAppState>();
    // var tracks = appState.tracks;
    // var projectInfo = appState.projectInfo;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      // children: [
      //   SizedBox(height: 10),
      //   Expanded(
      //     flex: 4,
      //     child: Text('Settings'),
      //   ),
      //   SizedBox(height: 10),
      // ],
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

Widget settingsWidget(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          child: const Text(
            'context.locale = Locale(en)',
            // style: TextStyle(color: Colors.white, fontSize: 17),
          ),
          onPressed: () => context.locale = const Locale('en'),
        ),
        //
        ElevatedButton(
          child: const Text(
            'context.locale = Locale(ru)',
            // style: TextStyle(color: Colors.white, fontSize: 17),
          ),
          onPressed: () => context.locale = const Locale('ru'),
        ),
      ],
    ),
  );
}
