import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/blocks/NoTracksInfo.dart';
import 'package:march_tales_app/features/Track/widgets/TracksList.dart';
import 'package:march_tales_app/shared/states/AppState.dart';

final logger = Logger();

class FavoriteTracksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final favoritesHasBeenLoaded = appState.favoritesHasBeenLoaded;
    final isFavoritesLoading = appState.isFavoritesLoading;
    final tracks = appState.getSortedFavorites();

    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;

    if (!favoritesHasBeenLoaded && isFavoritesLoading) {
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
            // key: ValueKey('FavoritesList'),
            tracks: tracks,
            count: tracks.length,
            isLoading: isFavoritesLoading,
            asFavorite: true,
            useScrollController: true,
            onRefresh: () async {
              await appState.loadFavorites();
            },
            // onLoadNext: () {
            //   appState.loadNextTracks();
            // },
          ),
        ),
      ],
    );
  }
}
