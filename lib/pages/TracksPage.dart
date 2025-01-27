import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:march_tales_app/features/Track/widgets/TrackItem.dart';
import 'package:march_tales_app/pages/components/TopMenuBox.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/shared/states/MyAppState.dart';

import 'TracksPage.i18n.dart';

// final formatter = YamlFormatter();
final logger = Logger();

// @see https://docs.flutter.dev/cookbook/networking/fetch-data
class TracksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final tracksIsLoading = appState.tracksIsLoading;
    final tracksLoadError = appState.tracksLoadError;
    final tracksHasBeenLoaded = appState.tracksHasBeenLoaded;
    final tracks = appState.tracks;

    // logger.t(
    //     'TracksPage: tracksIsLoading=${tracksIsLoading} tracksHasBeenLoaded=${tracksHasBeenLoaded} tracksLoadError=${tracksLoadError} tracks=${tracks}');

    if (tracksLoadError != null) {
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
    } else if (tracksIsLoading || !tracksHasBeenLoaded) {
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
                child: Text('No tracks found'.i18n),
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
          child: SingleChildScrollView(
            child: TracksListWidget(),
          ),
        ),
      ],
    );
  }
}

class TracksListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final tracks = appState.tracks;
    final tracksList = tracks.map((track) {
      return TrackItem(track: track);
    }).toList();
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: tracksList,
        ),
      ),
    );
  }
}
