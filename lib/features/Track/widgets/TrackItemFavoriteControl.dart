import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/shared/states/AppState.dart';

final logger = Logger();

class TrackItemFavoriteControl extends StatelessWidget {
  const TrackItemFavoriteControl({
    super.key,
    required this.track,
    // required this.isActiveTrack,
    required this.isAlreadyPlayed,
    // required this.isPlaying,
    // required this.progress,
    this.isFavorite = false,
    this.fullView = false,
  });

  final Track track;
  // final bool isActiveTrack;
  final bool isAlreadyPlayed;
  // final bool isPlaying;
  // final double progress;
  final bool isFavorite;
  final bool fullView;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;
    final mainColor =
        appColors.brandColor; // !isAlreadyPlayed ? appColors.brandColor : appColors.brandColor.withValues(alpha: 0.3);

    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: mainColor,
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        final setFavorite = !isFavorite;
        appState.setFavorite(track.id, setFavorite);
      },
    );
  }
}
