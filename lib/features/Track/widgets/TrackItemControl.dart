import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/shared/states/AppState.dart';

final logger = Logger();

const double _trackItemControlIconSize = 24;
const double _trackItemControlCircleSize = _trackItemControlIconSize + 16;

class TrackItemControl extends StatelessWidget {
  const TrackItemControl({
    super.key,
    required this.track,
    required this.isActiveTrack,
    required this.isAlreadyPlayed,
    required this.isPlaying,
    required this.progress,
  });

  final Track track;
  final bool isActiveTrack;
  final bool isAlreadyPlayed;
  final bool isPlaying;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = Theme.of(context);
    // final colorScheme = theme.colorScheme;
    final AppColors appColors = theme.extension<AppColors>()!;

    final mainColor = !isAlreadyPlayed
        ? appColors.brandColor
        : appColors.brandColor.withValues(alpha: 0.3);

    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        SizedBox(
          width: _trackItemControlCircleSize,
          height: _trackItemControlCircleSize,
          child: isAlreadyPlayed
              ? SizedBox()
              : CircularProgressIndicator(
                  color: appColors.brandColor.withValues(alpha: 0.2),
                  strokeWidth: 2,
                  value: 1,
                ),
        ),
        SizedBox(
          width: _trackItemControlCircleSize,
          height: _trackItemControlCircleSize,
          child: progress == 0
              ? SizedBox()
              : CircularProgressIndicator(
                  color: mainColor,
                  strokeWidth: 3,
                  value: progress,
                ),
        ),
        IconButton(
          icon: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            size: _trackItemControlIconSize,
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
