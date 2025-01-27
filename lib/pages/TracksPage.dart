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
          // child: SingleChildScrollView(
          //   child: TracksListWidget(),
          // ),
          child: TracksList(),
        ),
      ],
    );
  }
}

class MoreButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<MyAppState>();
    final tracksIsLoading = appState.tracksIsLoading;
    final isWaiting = tracksIsLoading;
    final color = isWaiting
        ? theme.primaryColor.withValues(alpha: 0.5)
        : theme.primaryColor;
    const double iconSize = 20;
    return Center(
      child: TextButton.icon(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll<Color>(color),
        ),
        onPressed: isWaiting
            ? null
            : () {
                logger.t('Load more pressed');
                appState.loadNextTracks();
              },
        icon: isWaiting
            ? SizedBox(
                height: iconSize,
                width: iconSize,
                child: CircularProgressIndicator(color: color, strokeWidth: 2),
              )
            : Icon(Icons.arrow_circle_down, size: iconSize),
        label: Text(isWaiting ? 'Loading...'.i18n : 'Load more...'.i18n),
      ),
    );
  }
}

class TracksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final availableTracksCount = appState.availableTracksCount;
    final tracks = appState.tracks;
    final tracksCount = tracks.length;
    final hasMoreTracks = availableTracksCount > tracksCount;
    final showItems = hasMoreTracks ? tracksCount + 1 : tracksCount;
    logger.d(
        'Tracks: ${tracksCount} / ${availableTracksCount} ${hasMoreTracks} ${showItems}');
    return ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        key: PageStorageKey<String>('TracksList'),
        // controller: statelessControllerA,
        itemCount: showItems,
        itemBuilder: (context, i) {
          if (i == tracksCount) {
            return MoreButton();
          } else {
            return TrackItem(track: tracks[i]);
          }
        },
        separatorBuilder: (context, index) => SizedBox(height: 10));
  }
}
