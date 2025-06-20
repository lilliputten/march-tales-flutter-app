import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/blocks/NoTracksInfo.dart';
import 'package:march_tales_app/components/LoadingSplash.dart';
import 'package:march_tales_app/features/Track/widgets/TracksList.dart';
import 'package:march_tales_app/shared/states/AppState.dart';

final logger = Logger();

// @see https://docs.flutter.dev/cookbook/networking/fetch-data
class TracksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final tracksLoadError = appState.tracksLoadError;
    final tracksHasBeenLoaded = appState.tracksHasBeenLoaded;
    final tracksIsLoading = appState.tracksIsLoading;
    final tracks = appState.tracks;

    if (tracksLoadError != null) {
      // XXX FUTURE: Display the error inside the RefreshIndicator to allow refresh data?
      return RefreshIndicator(
        onRefresh: () async {
          await appState.reloadTracks();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Text(tracksLoadError),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (!tracksHasBeenLoaded && tracksIsLoading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: LoadingSplash(),
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
              child: NoTracksInfo(padding: 20),
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // TopFilterBox(),
        Expanded(
          child: TracksList(
            // key: ValueKey('TracksList'),
            tracks: tracks,
            count: appState.availableTracksCount,
            isLoading: tracksIsLoading,
            useScrollController: true,
            onRefresh: () async {
              await appState.reloadTracks();
            },
            onLoadNext: () async {
              await appState.loadNextTracks();
            },
          ),
        ),
      ],
    );
  }
}
