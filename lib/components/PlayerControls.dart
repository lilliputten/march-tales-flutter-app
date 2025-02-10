import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/features/Track/db/TrackInfo.dart';
import 'package:march_tales_app/features/Track/db/TracksInfoDb.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/shared/states/AppState.dart';

final logger = Logger();

const double _bigControlIconSize = 24;
const double _bigControlCircleSize = _bigControlIconSize + 16;

// const double _smallControlIconSize = 20;
// const double _smallControlCircleSize = _bigControlIconSize + 16;

class PlayerControls extends StatelessWidget {
  const PlayerControls({
    super.key,
    required this.track,
    required this.trackInfo,
  });
  final Track track;
  final TrackInfo? trackInfo;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 0,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PlayerFavoriteControl(track: track, trackInfo: trackInfo),
        PlayerBackwardControl(track: track, trackInfo: trackInfo),
        PlayerPlayControl(track: track, trackInfo: trackInfo),
        PlayerForwardControl(track: track, trackInfo: trackInfo),
      ],
    );
  }
}

class PlayerPlayControl extends StatelessWidget {
  const PlayerPlayControl({
    super.key,
    required this.track,
    required this.trackInfo,
  });
  final Track track;
  final TrackInfo? trackInfo;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;
    // final colorScheme = theme.colorScheme;

    final mainColor = appColors.brandColor;

    final isPlaying = appState.isPlaying && !appState.isPaused;

    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        SizedBox(
          width: _bigControlCircleSize,
          height: _bigControlCircleSize,
          child: CircularProgressIndicator(
            color: appColors.brandColor.withValues(alpha: 1),
            strokeWidth: 2,
            value: 1,
          ),
        ),
        IconButton(
          icon: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            size: _bigControlIconSize,
            color: mainColor,
          ),
          style: IconButton.styleFrom(
            shape: CircleBorder(),
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.all(0.0),
          onPressed: () {
            appState.setPlayingTrack(track, play: true);
          },
        ),
      ],
    );
  }
}

class PlayerBackwardControl extends StatelessWidget {
  const PlayerBackwardControl({
    super.key,
    required this.track,
    required this.trackInfo,
  });
  final Track track;
  final TrackInfo? trackInfo;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;
    // final colorScheme = theme.colorScheme;

    return IconButton(
      icon: Icon(
        Icons.navigate_before,
        color: appColors.brandColor,
      ),
      // style: IconButton.styleFrom(),
      alignment: Alignment.center,
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        logger.d(
            '[TrackItem:PlayerBackwardControl:onPressed] track.id=${track.id}');
        appState.playSeekBackward();
      },
    );
  }
}

class PlayerForwardControl extends StatelessWidget {
  const PlayerForwardControl({
    super.key,
    required this.track,
    required this.trackInfo,
  });
  final Track track;
  final TrackInfo? trackInfo;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;
    // final colorScheme = theme.colorScheme;

    return IconButton(
      icon: Icon(
        Icons.navigate_next,
        color: appColors.brandColor,
      ),
      // style: IconButton.styleFrom(),
      alignment: Alignment.center,
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        logger.d(
            '[TrackItem:PlayerForwardControl:onPressed] track.id=${track.id}');
        appState.playSeekForward();
      },
    );
  }
}

class PlayerFavoriteControl extends StatelessWidget {
  const PlayerFavoriteControl({
    super.key,
    required this.track,
    required this.trackInfo,
  });
  final Track track;
  final TrackInfo? trackInfo;

  @override
  Widget build(BuildContext context) {
    // final appState = context.watch<AppState>();
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;
    // final colorScheme = theme.colorScheme;

    final isFavorite = trackInfo?.favorite ?? false;

    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: appColors.brandColor,
      ),
      // style: IconButton.styleFrom(),
      alignment: Alignment.center,
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        final setFavorite = !isFavorite;
        logger.d(
            '[TrackItem:PlayerFavoriteControl:onPressed] track.id=${track.id} setFavorite=${setFavorite}');
        tracksInfoDb.setFavorite(track.id, favorite: setFavorite);
      },
    );
  }
}
