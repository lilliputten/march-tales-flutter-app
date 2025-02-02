import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:march_tales_app/features/Track/widgets/TrackImageThumbnail.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/shared/states/AppState.dart';

final logger = Logger();

String getDurationString(Duration? d) {
  if (d == null) {
    return '';
  }
  String s = d.toString();
  s = s.replaceFirst(RegExp(r'\.\d+$'), '');
  return s;
}

// @see https://docs.flutter.dev/cookbook/networking/fetch-data
class PlayerBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    final track = appState.playingTrack;
    final player = appState.activePlayer;

    // No active track?
    if (track == null) {
      // Display nothing if no active track
      return Container();
    }

    return StreamBuilder(
        stream: player.playerStateStream,
        builder: (context, AsyncSnapshot snapshot) {
          // final PlayerState? playerState = snapshot.data;
          // final bool? playing = playerState?.playing;
          // final ProcessingState? processingState = playerState?.processingState;
          // final position = player.position;
          // final duration = player.duration;
          // logger.t('PlayerBox: playing: ${playing} processingState: ${processingState} position: ${position} duration: ${duration} ${playerState}');
          // appState.updatePlayerStatus(playerState);
          // int currentIndex = snapshot.data ?? 0;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TrackImageThumbnail(track: track, size: 50),
                Expanded(
                  flex: 1,
                  child: TrackDetails(),
                ),
              ],
            ),
          );
        });
  }
}

class TrackDetails extends StatelessWidget {
  const TrackDetails({
    super.key,
    // required this.track,
    // this.isActive = false,
  });

  // final Track track;
  // final bool isActive;

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

    final isPlaying = appState.isPlaying;
    final isPaused = appState.isPaused;
    final position = appState.playingPosition;
    final hasPosition = position != null && position.inMilliseconds != 0;

    String text = track.title;
    if (isPlaying || hasPosition) {
      final state = !isPlaying || isPaused ? 'paused' : 'playing';
      if (hasPosition) {
        final positionString = getDurationString(position);
        text += ' (${state} ${positionString})';
      }
    }

    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: style.copyWith(color: textColor),
        ),
        // TrackTitle(track: track, textColor: textColor),
        // TrackDetailsInfo(track: track, isActive: isActive, textColor: textColor),
      ],
    );
  }
}
