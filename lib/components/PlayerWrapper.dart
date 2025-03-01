import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/components/PlayerControls.dart';
import 'package:march_tales_app/components/PlayerSlider.dart';
import 'package:march_tales_app/components/PlayerTrackDetails.dart';
import 'package:march_tales_app/features/Track/db/TrackInfo.dart';
import 'package:march_tales_app/features/Track/db/TracksInfoDb.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/features/Track/widgets/TrackImageThumbnail.dart';
import 'package:march_tales_app/shared/states/AppState.dart';

final logger = Logger();

class PlayerWrapper extends StatefulWidget {
  const PlayerWrapper({
    super.key,
    required this.track,
    required this.playSeek,
    required this.playSeekBackward,
    required this.playSeekForward,
  });

  final Track track;
  final ValueSetter<Duration> playSeek;
  final VoidCallback playSeekBackward;
  final VoidCallback playSeekForward;

  @override
  State<PlayerWrapper> createState() => _PlayerWrapperState();
}

class _PlayerWrapperState extends State<PlayerWrapper> {
  TrackInfo? _trackInfo;

  void updateTrackInfo(TracksInfoDbUpdate update) {
    final trackInfo = update.trackInfo;
    final Track track = this.widget.track;
    if (trackInfo.id == track.id) {
      setState(() {
        this._trackInfo = trackInfo;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final Track track = this.widget.track;
    // Load inital value
    tracksInfoDb.getById(track.id).then((trackInfo) {
      if (trackInfo != null) {
        setState(() {
          this._trackInfo = trackInfo;
        });
      }
    });
    // Subscribe to the future updates
    tracksInfoDb.updateEvents.subscribe(this.updateTrackInfo);
  }

  @override
  void dispose() {
    tracksInfoDb.updateEvents.unsubscribe(this.updateTrackInfo);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    // final theme = Theme.of(context);
    // final colorScheme = theme.colorScheme;

    final Track track = widget.track;

    final Duration duration = track.duration;
    final Duration? position = appState.playingPosition;

    const double minTreshold = 320;
    final double screenWidth = MediaQuery.sizeOf(context).width;

    final items = [
      screenWidth < minTreshold + 100 ? null : TrackImageThumbnail(track: track, height: 50, borderRadius: 5),
      screenWidth < minTreshold
          ? null
          : Expanded(
              flex: 1,
              child: PlayerTrackDetails(
                title: track.title,
                // trackInfo: this._trackInfo,
                position: position,
                duration: duration,
              ),
            ),
      PlayerControls(
        track: track,
        trackInfo: this._trackInfo,
        playSeekBackward: widget.playSeekBackward,
        playSeekForward: widget.playSeekForward,
      ),
    ].nonNulls;

    const double padding = 15;

    return Column(
      spacing: 0,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PlayerSlider(
          position: position,
          duration: duration,
          onSeek: widget.playSeek,
          // onSeek: (Duration position) {
          //   widget.playSeek(position);
          // },
        ),
        Padding(
          // Show top padding only if there no track slider above
          padding: EdgeInsets.fromLTRB(padding, 0, padding, padding),
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
