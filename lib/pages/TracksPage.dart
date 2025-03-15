import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/features/Track/widgets/TracksList.dart';
import 'package:march_tales_app/shared/states/AppState.dart';
import 'TracksPage.i18n.dart';

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

    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;

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
              child: CircularProgressIndicator(strokeWidth: 2, color: appColors.brandColor),
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
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Text('No tracks'.i18n),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // TopMenuBox(), // TODO
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
            onLoadNext: () {
              appState.loadNextTracks();
            },
          ),
        ),
      ],
    );
  }
}
