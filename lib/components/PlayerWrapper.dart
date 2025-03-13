import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/components/PlayerControls.dart';
import 'package:march_tales_app/components/PlayerSlider.dart';
import 'package:march_tales_app/components/PlayerTrackDetails.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/features/Track/widgets/TrackImageThumbnail.dart';
import 'PlayerBox/common.dart';

final logger = Logger();

class PlayerWrapper extends StatefulWidget {
  const PlayerWrapper({
    super.key,
    required this.track,
    required this.playSeek,
    required this.playSeekBackward,
    required this.playSeekForward,
    required this.togglePause,
    this.position,
    required this.isPlaying,
    required this.isPaused,
    required this.positionDataStream,
    this.onClick,
  });

  final Track track;
  final ValueSetter<Duration> playSeek;
  // final void Function(Duration value) playSeek;
  final VoidCallback playSeekBackward;
  final VoidCallback playSeekForward;
  final VoidCallback togglePause;
  final Duration? position;
  final bool isPlaying;
  final bool isPaused;
  final Stream<PositionData> positionDataStream;
  final VoidCallback? onClick;

  @override
  State<PlayerWrapper> createState() => _PlayerWrapperState();
}

class _PlayerWrapperState extends State<PlayerWrapper> {
  @override
  Widget build(BuildContext context) {
    final Track track = widget.track;
    final Duration duration = track.duration;
    final Duration? position = widget.position; // appState.playingPosition;

    const double minTreshold = 320;
    final double screenWidth = MediaQuery.sizeOf(context).width;

    final items = [
      screenWidth < minTreshold + 100
          ? null
          : InkWell(
              onTap: this.widget.onClick,
              child: TrackImageThumbnail(track: track, height: 50, borderRadius: 5),
            ),
      screenWidth < minTreshold
          ? null
          : Expanded(
              flex: 1,
              child: PlayerTrackDetails(
                title: track.title,
                position: position,
                duration: duration,
                onClick: this.widget.onClick,
              ),
            ),
      PlayerControls(
        track: track,
        playSeekBackward: widget.playSeekBackward,
        playSeekForward: widget.playSeekForward,
        togglePause: widget.togglePause,
        isPlaying: widget.isPlaying,
        isPaused: widget.isPaused,
      ),
    ].nonNulls;

    const double padding = 15;

    return Column(
      spacing: 0,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PlayerSlider(
          positionDataStream: this.widget.positionDataStream,
          // positionStream: this.widget.positionStream,
          position: position,
          duration: duration,
          onSeek: widget.playSeek,
        ),
        Padding(
          // Show top padding only if there no track slider above
          padding: EdgeInsets.fromLTRB(padding, 0, padding, 5),
          // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            children: items.toList(),
          ),
        ),
      ],
    );
  }
}
