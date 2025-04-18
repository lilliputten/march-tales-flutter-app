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
    required this.playSeekBackward,
    required this.playSeekForward,
    required this.togglePause,
    required this.isPlaying,
    required this.isPaused,
  });
  final Track track;
  final VoidCallback playSeekBackward;
  final VoidCallback playSeekForward;
  final VoidCallback togglePause;
  final bool isPlaying;
  final bool isPaused;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 0,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PlayerBackwardControl(track: track, playSeekBackward: this.playSeekBackward),
        PlayerPlayControl(
            track: track, togglePause: this.togglePause, isPlaying: this.isPlaying, isPaused: this.isPaused),
        PlayerForwardControl(track: track, playSeekForward: this.playSeekForward),
        PlayerFavoriteControl(
          track: track,
        ),
        PlayerHideControl(),
      ],
    );
  }
}

class PlayerPlayControl extends StatelessWidget {
  const PlayerPlayControl({
    super.key,
    required this.track,
    required this.togglePause,
    required this.isPlaying,
    required this.isPaused,
  });
  final Track track;
  final VoidCallback togglePause;
  final bool isPlaying;
  final bool isPaused;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;

    final mainColor = appColors.brandColor;

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
        ),
      ],
    );
  }
}

class PlayerBackwardControl extends StatelessWidget {
  const PlayerBackwardControl({
    super.key,
    required this.track,
    required this.playSeekBackward,
  });
  final Track track;
  final VoidCallback playSeekBackward;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;

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
    required this.playSeekForward,
  });
  final Track track;
  final VoidCallback playSeekForward;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;

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
  });
  final Track track;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;

    final isFavorite = appState.isFavoriteTrackId(track.id);

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

class PlayerHideControl extends StatelessWidget {
  const PlayerHideControl({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;

    return IconButton(
      icon: Icon(
        Icons.close,
        color: appColors.brandColor,
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        appState.hidePlayer();
      },
    );
  }
}
