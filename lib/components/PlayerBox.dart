import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/core/helpers/getDurationString.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/features/Track/widgets/TrackImageThumbnail.dart';
import 'package:march_tales_app/shared/states/AppState.dart';

final logger = Logger();

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
          return PlayerWrapper();
        });
  }
}

class PlayerWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final appState = context.watch<AppState>();
    // final theme = Theme.of(context);
    // final colorScheme = theme.colorScheme;

    return Column(
      spacing: 0,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PlayerSlider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: PlayerDetails(),
        ),
      ],
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    // Offset offset = Offset.zero,
    Offset offset = const Offset(10, 20),
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final Offset usedOffset = Offset(10, 0);
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = usedOffset.dx;
    final double trackTop =
        usedOffset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class PlayerSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    final track = appState.playingTrack;
    final duration = track?.duration;
    final position = appState.playingPosition;

    // TODO: Use real position/duration values

    // final appState = context.watch<AppState>();
    // final theme = Theme.of(context);
    // final colorScheme = theme.colorScheme;

    return SliderTheme(
      data: SliderThemeData(
        trackShape: CustomTrackShape(),
      ),
      child: Slider(
        value: 0.5,
        // max: 100,
        // divisions: 5,
        // label: 'XXX',
        onChanged: (double value) {
          debugger();
          // setState(() {
          //   _currentSliderValue = value;
          // });
        },
      ),
    );
  }
}

class PlayerDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final track = appState.playingTrack!;
    // final appState = context.watch<AppState>();
    // final theme = Theme.of(context);
    // final colorScheme = theme.colorScheme;

    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TrackImageThumbnail(track: track, size: 50),
        Expanded(
          flex: 1,
          child: TrackDetails(),
        ),
      ],
    );
  }
}

class TrackDetails extends StatelessWidget {
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
