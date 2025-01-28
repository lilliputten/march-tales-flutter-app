import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/shared/states/MyAppState.dart';
import 'package:march_tales_app/features/Track/widgets/TracksList.dart';
import 'package:march_tales_app/components/TopMenuBox.dart';

import 'TracksPage.i18n.dart';

// final formatter = YamlFormatter();
final logger = Logger();

// @see https://docs.flutter.dev/cookbook/networking/fetch-data
class TracksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final tracksLoadError = appState.tracksLoadError;
    final tracksHasBeenLoaded = appState.tracksHasBeenLoaded;
    final tracksIsLoading = appState.tracksIsLoading;
    final tracks = appState.tracks;

    // logger.t(
    //     'TracksPage: tracksIsLoading=${tracksIsLoading} tracksHasBeenLoaded=${tracksHasBeenLoaded} tracksLoadError=${tracksLoadError} tracks=${tracks}');

    if (tracksLoadError != null) {
      // TODO: Show an error in case of the server inaccessibility?
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Text(tracksLoadError),
              ),
            ),
          ),
        ],
      );
    } else if (!tracksHasBeenLoaded && tracksIsLoading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      );
    } else if (tracks.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Text('No tracks loaded'.i18n),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TopMenuBox(),
        Expanded(
          child: TracksList(),
        ),
      ],
    );
  }
}
