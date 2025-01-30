import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
// import 'package:march_tales_app/app/AppColors.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/features/Track/widgets/TrackItem.dart';
import 'package:march_tales_app/shared/states/MyAppState.dart';
// import 'package:march_tales_app/sharedTranslationsData.i18n.dart';

import 'TracksList.i18n.dart';

final logger = Logger();

class MoreButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final AppColors appColors = theme.extension<AppColors>()!;
    final buttonColorTheme = theme.buttonTheme.colorScheme!;
    final appState = context.watch<MyAppState>();
    final tracksIsLoading = appState.tracksIsLoading;
    final isWaiting = tracksIsLoading;
    // final baseColor = appColors.brandColor;
    final baseColor = buttonColorTheme.primary;
    final color = isWaiting ? baseColor.withValues(alpha: 0.5) : baseColor;
    const double iconSize = 20;
    return Center(
      child: TextButton.icon(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll<Color>(color),
        ),
        onPressed: isWaiting
            ? null
            : () {
                appState.loadNextTracks();
              },
        icon: isWaiting
            ? SizedBox(
                height: iconSize,
                width: iconSize,
                child: CircularProgressIndicator(color: color, strokeWidth: 2),
              )
            : Icon(Icons.arrow_circle_down, size: iconSize, color: color),
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
    // logger.d(
    //     'Tracks: ${tracksCount} / ${availableTracksCount} ${hasMoreTracks} ${showItems}');
    return RefreshIndicator(
      onRefresh: () async {
        await appState.reloadTracks();
      },
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        key: PageStorageKey<String>('TracksList'),
        itemCount: showItems,
        itemBuilder: (context, i) {
          if (i == tracksCount) {
            return MoreButton();
          } else {
            return TrackItem(track: tracks[i]);
          }
        },
        separatorBuilder: (context, index) => SizedBox(height: 10),
      ),
    );
  }
}
