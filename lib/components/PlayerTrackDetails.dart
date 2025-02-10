import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/core/helpers/getDurationString.dart';
import 'package:march_tales_app/features/Track/db/TrackInfo.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/shared/states/AppState.dart';

final logger = Logger();

class PlayerTrackDetails extends StatelessWidget {
  const PlayerTrackDetails({
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
    final colorScheme = theme.colorScheme;
    final textColor = colorScheme.onSurface;
    final style = theme.textTheme.bodyMedium!;

    final track = appState.playingTrack;

    // No active track?
    if (track == null) {
      return Container();
    }

    // final isPlaying = appState.isPlaying;
    // final isPaused = appState.isPaused;
    // final position = appState.playingPosition;
    // final hasPosition = position != null && position.inMilliseconds != 0;

    // String text = track.title;
    // if (isPlaying || hasPosition) {
    //   final state = !isPlaying || isPaused ? 'paused' : 'playing';
    //   if (hasPosition) {
    //     final positionString = getDurationString(position);
    //     text += ' (${state} ${positionString})';
    //   }
    // }

    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          track.title,
          overflow: TextOverflow.ellipsis,
          style: style.copyWith(color: textColor),
        ),
        // TrackTitle(track: track, textColor: textColor),
        // TrackDetailsInfo(track: track, isActive: isActive, textColor: textColor),
      ],
    );
  }
}
