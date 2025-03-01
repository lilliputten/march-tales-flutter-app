import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/shared/states/AppState.dart';

// import 'package:march_tales_app/features/Track/db/TrackInfo.dart';

final logger = Logger();

const double _bigControlIconSize = 24;
const double _bigControlCircleSize = _bigControlIconSize + 16;

class PlayerControls extends StatelessWidget {
  const PlayerControls({
    super.key,
    required this.track,
    // required this.trackInfo,
    required this.playSeekBackward,
    required this.playSeekForward,
    // required this.setTrack,
    required this.togglePause,
    required this.isPlaying,
    required this.isPaused,
  });
  final Track track;
  // final TrackInfo? trackInfo;
  final VoidCallback playSeekBackward;
  final VoidCallback playSeekForward;
  // final void Function(Track? track, {bool play, bool notify}) setTrack;
  final VoidCallback togglePause;
  final bool isPlaying;
  final bool isPaused;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 0,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PlayerBackwardControl(
            track: track,
            // trackInfo: trackInfo,
            playSeekBackward: this.playSeekBackward),
        PlayerPlayControl(
            track: track,
            // trackInfo: trackInfo,
            togglePause: this.togglePause,
            isPlaying: this.isPlaying,
            isPaused: this.isPaused),
        PlayerForwardControl(
            track: track,
            // trackInfo: trackInfo,
            playSeekForward: this.playSeekForward),
        PlayerFavoriteControl(
          track: track,
          // trackInfo: trackInfo,
        ),
      ],
    );
  }
}

class PlayerPlayControl extends StatelessWidget {
  const PlayerPlayControl({
    super.key,
    required this.track,
    // required this.trackInfo,
    required this.togglePause,
    required this.isPlaying,
    required this.isPaused,
  });
  final Track track;
  // final TrackInfo? trackInfo;
  final VoidCallback togglePause;
  final bool isPlaying;
  final bool isPaused;

  @override
  Widget build(BuildContext context) {
    // final appState = context.watch<AppState>();
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;
    // final colorScheme = theme.colorScheme;

    final mainColor = appColors.brandColor;

    // final isPlaying = appState.isPlaying && !appState.isPaused;
    final showPlaying = this.isPlaying && !this.isPaused;

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
            showPlaying ? Icons.pause : Icons.play_arrow,
            size: _bigControlIconSize,
            color: mainColor,
          ),
          style: IconButton.styleFrom(
            shape: CircleBorder(),
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.all(0.0),
          onPressed: this.togglePause,
          // onPressed: () {
          //   this.togglePause();
          //   // appState.setPlayingTrack(track, play: true);
          // },
        ),
      ],
    );
  }
}

class PlayerBackwardControl extends StatelessWidget {
  const PlayerBackwardControl({
    super.key,
    required this.track,
    // required this.trackInfo,
    required this.playSeekBackward,
  });
  final Track track;
  // final TrackInfo? trackInfo;
  final VoidCallback playSeekBackward;

  @override
  Widget build(BuildContext context) {
    // final appState = context.watch<AppState>();
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;
    // final colorScheme = theme.colorScheme;

    return IconButton(
      icon: Icon(
        Icons.navigate_before,
        color: appColors.brandColor,
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.all(0.0),
      onPressed: this.playSeekBackward,
    );
  }
}

class PlayerForwardControl extends StatelessWidget {
  const PlayerForwardControl({
    super.key,
    required this.track,
    // required this.trackInfo,
    required this.playSeekForward,
  });
  final Track track;
  // final TrackInfo? trackInfo;
  final VoidCallback playSeekForward;

  @override
  Widget build(BuildContext context) {
    // final appState = context.watch<AppState>();
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;
    // final colorScheme = theme.colorScheme;

    return IconButton(
      icon: Icon(
        Icons.navigate_next,
        color: appColors.brandColor,
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.all(0.0),
      onPressed: this.playSeekForward,
    );
  }
}

class PlayerFavoriteControl extends StatelessWidget {
  const PlayerFavoriteControl({
    super.key,
    required this.track,
    // required this.trackInfo,
  });
  final Track track;
  // final TrackInfo? trackInfo;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;
    // final colorScheme = theme.colorScheme;

    final isFavorite = appState.isFavoriteTrackId(track.id); // trackInfo?.favorite ?? false;

    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: appColors.brandColor,
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
