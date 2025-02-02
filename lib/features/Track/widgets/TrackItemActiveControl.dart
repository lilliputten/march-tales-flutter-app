import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/core/constants/player.dart';
import 'package:march_tales_app/shared/states/AppState.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/features/Track/widgets/TrackItemDefaultControl.dart';

final logger = Logger();

class TrackItemActiveControl extends StatefulWidget {
  const TrackItemActiveControl({
    super.key,
    required this.track,
  });

  final Track track;

  @override
  State<TrackItemActiveControl> createState() => _TrackItemActiveControlState();
}

class _TrackItemActiveControlState extends State<TrackItemActiveControl>
    with TickerProviderStateMixin {
  late double _lastProgress;
  late Animation<double> _animation;
  late Tween<double> _tween;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    this._lastProgress = 0; // this._getCurrentProgress();
    this._animationController = AnimationController(
        duration: Duration(milliseconds: playerTickDelayMs), vsync: this);
    this._tween = Tween(begin: this._lastProgress, end: this._lastProgress);
    this._animation = this._tween.animate(this._animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    this._animationController.dispose();
    super.dispose();
  }

  void _updateProgress(double progress) {
    this._tween = Tween(begin: this._lastProgress, end: progress);
    this._animationController.reset();
    this._animation = this._tween.animate(this._animationController);
    this._animationController.forward();
    this._lastProgress = progress;
  }

  double _getCurrentProgress(BuildContext context) {
    double progress = 0;

    final appState = context.watch<AppState>();

    final track = appState.playingTrack;
    final playing = track != null && track.id == this.widget.track.id;

    if (playing) {
      // final duration = appState.playingDuration?.inMilliseconds;
      final player = appState.activePlayer;
      final duration = player.duration?.inMilliseconds;
      final position = appState.playingPosition?.inMilliseconds;
      if (duration != null && duration != 0 && position != null) {
        progress = position / duration;
      }
    }
    return progress;
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = Theme.of(context);
    // final colorScheme = Theme.of(context).colorScheme;
    final AppColors appColors = theme.extension<AppColors>()!;

    final track = appState.playingTrack;

    final playing = track != null && track.id == this.widget.track.id;
    final iconPlaying = playing && appState.isPlaying && !appState.isPaused;

    double progress = this._getCurrentProgress(context);

    // logger.t(
    //     'TrackItemActiveControl: tprogress: ${progress} animated: ${this._animation.value}');

    if (progress != this._lastProgress) {
      this._updateProgress(progress);
    }

    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        SizedBox(
          width: trackItemControlCircleSize,
          height: trackItemControlCircleSize,
          child: playing
              ? CircularProgressIndicator(
                  color: appColors.brandColor,
                  strokeWidth: 3,
                  // value: progress,
                  value: this
                      ._animation
                      .value, // > _lastProgress ? this._animation.value : progress,
                )
              : SizedBox(),
        ),
        TrackItemDefaultControl(
            track: this.widget.track, isPlaying: iconPlaying),
      ],
    );
  }
}
