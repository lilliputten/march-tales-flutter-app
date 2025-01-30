import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:march_tales_app/app/AppColors.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/shared/states/MyAppState.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';

const double previewSize = 80;
const previewHalfSize = previewSize / 2;
const previewProgressPadding = previewHalfSize - 16;

final logger = Logger();

class TrackItemControl extends StatefulWidget {
  const TrackItemControl({
    super.key,
    required this.track,
  });

  final Track track;

  @override
  State<TrackItemControl> createState() => _TrackItemControlState();
}

class _TrackItemControlState extends State<TrackItemControl> {
  late AnimationController animationController;

  // Widget TrackItemControl(BuildContext context, Track track)
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final theme = Theme.of(context);
    // final colorScheme = Theme.of(context).colorScheme;
    final AppColors appColors = theme.extension<AppColors>()!;

    final playingTrack = appState.playingTrack;

    final isPlaying = playingTrack != null &&
        playingTrack.id == widget.track.id &&
        appState.isPlaying;
    final isActive = isPlaying && !appState.isPaused;

    double progress = 0;

    if (isPlaying) {
      final player = appState.activePlayer;
      final duration = player?.duration?.inMilliseconds;
      final position = player?.position.inMilliseconds;
      if (duration != null && duration != 0 && position != null) {
        progress = position / duration;
      }
      logger.t(
          'TrackItemControl: progress=${progress} position=${position} duration=${duration}');
    }

    // logger.d(
    //     'TrackItemControl: isActive: ${isActive}, isPlaying: ${appState.isPlaying}');

    // TODO: Show circular playing progress indicator for active track around the icon

    const double iconSize = 24;
    const double circleSize = iconSize + 16;

    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        SizedBox(
          width: circleSize,
          height: circleSize,
          child: CircularProgressIndicator(
            color: appColors.brandColor.withValues(alpha: 0.2),
            strokeWidth: 2,
            value: 1,
          ),
        ),
        SizedBox(
          width: circleSize,
          height: circleSize,
          child: CircularProgressIndicator(
            color: appColors.brandColor,
            strokeWidth: isPlaying ? 3 : 0,
            value: progress,
          ),
        ),
        IconButton(
          icon: Icon(
            isActive ? Icons.pause : Icons.play_arrow,
            size: iconSize,
            color: appColors.brandColor,
          ),
          style: IconButton.styleFrom(
            // minimumSize: Size.zero, // Set this
            // padding: EdgeInsets.zero, // and this
            shape: CircleBorder(),
            // backgroundColor: appColors.brandColor, // colorScheme.primary,
            // foregroundColor: appColors.brandColor, // colorScheme.onPrimary,
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.all(0.0),
          onPressed: () {
            // logger.d('Play track ${track.id} (${track.title})');
            appState.playTrack(widget.track);
          },
        ),
      ],
    );
  }
}
