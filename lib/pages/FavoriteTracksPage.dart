import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/features/Track/widgets/TracksList.dart';
import 'package:march_tales_app/shared/states/AppState.dart';
import 'TracksPage.i18n.dart';

final logger = Logger();

// @see https://docs.flutter.dev/cookbook/networking/fetch-data
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
        Expanded(
          child: TracksList(
            tracks: tracks,
            count: tracks.length,
            isLoading: isFavoritesLoading,
            asFavorite: true,
            onRefresh: () async {
              await appState.reloadFavoritesData();
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
