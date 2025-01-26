import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/shared/states/MyAppState.dart';

import 'TracksPage.i18n.dart';

final logger = Logger();

// @see https://docs.flutter.dev/cookbook/networking/fetch-data
class TracksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var tracks = appState.tracks;
    // var projectInfo = appState.projectInfo;
    // logger.t('projectInfo: $projectInfo');

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Expanded(
            flex: 4,
            // child: Text(AppLocalizations.of(context)!.helloWorld),
            child: Text('Tracks list'.i18n),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
