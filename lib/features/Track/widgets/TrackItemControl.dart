import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/features/Track/db/TrackInfo.dart';
import 'package:march_tales_app/features/Track/db/TracksInfoDb.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/shared/states/AppState.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';

final logger = Logger();

const double trackItemControlIconSize = 24;
const double trackItemControlCircleSize = trackItemControlIconSize + 16;

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
  TrackInfo? _trackInfo;
  // int? _lastPosition;
  // double? _lastProgress;

  void updateTrackInfo(TracksInfoDbUpdate update) {
    final trackInfo = update.trackInfo;
    final Track track = this.widget.track;
    if (trackInfo.id == track.id) {
      setState(() {
        this._trackInfo = trackInfo;
        // logger.t('[TrackItemControl:updateTrackInfo] trackInfo=${trackInfo}');
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
          // logger.t('[TrackItemControl:initState] trackInfo=${trackInfo}');
          if (trackInfo.position.inMilliseconds == 0) {
            debugger();
          }
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
    final Track track = this.widget.track;

    final appState = context.watch<AppState>();
    final theme = Theme.of(context);
    // final colorScheme = theme.colorScheme;
    final AppColors appColors = theme.extension<AppColors>()!;

    final playingTrack = appState.playingTrack;
    final isActiveTrack = playingTrack != null && playingTrack.id == track.id;
    final isPlaying = isActiveTrack && appState.isPlaying && !appState.isPaused;

    final TrackInfo? trackInfo = this._trackInfo;
    int? position = trackInfo?.position.inMilliseconds;
    int? duration = trackInfo?.duration.inMilliseconds;
    if (isActiveTrack) {
      if (appState.playingPosition != null) {
        position = appState.playingPosition!.inMilliseconds;
      }
      if (appState.playingDuration != null) {
        duration = appState.playingDuration!.inMilliseconds;
      }
    }

    double progress = 0;
    if (duration != null && duration != 0 && position != null) {
      progress = position / duration;
    }

    /* // DEBUG
     * if (track.id == 5 && position != this._lastPosition) {
     *   logger.d(
     *       '[TrackItemControl:build] progress=${progress} position=${position} duration=${duration} trackInfo=${trackInfo} track=${track}');
     *   if (position == 0) {
     *     debugger();
     *   }
     * }
     * if (progress != this._lastProgress) {
     *   this._lastProgress = progress;
     * }
     * if (position != this._lastPosition) {
     *   this._lastPosition = position;
     * }
     */

    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        SizedBox(
          width: trackItemControlCircleSize,
          height: trackItemControlCircleSize,
          child: CircularProgressIndicator(
            color: appColors.brandColor.withValues(alpha: 0.2),
            strokeWidth: 2,
            value: 1,
          ),
        ),
        SizedBox(
          width: trackItemControlCircleSize,
          height: trackItemControlCircleSize,
          child: progress != 0
              ? CircularProgressIndicator(
                  color: appColors.brandColor,
                  strokeWidth: 3,
                  value: progress,
                )
              : SizedBox(),
        ),
        IconButton(
          icon: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            size: trackItemControlIconSize,
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
            appState.playTrack(track);
          },
        ),
      ],
    );
  }
}
