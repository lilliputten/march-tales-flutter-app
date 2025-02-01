import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

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
    _lastProgress = 0;
    _animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    _tween = Tween(begin: _lastProgress, end: _lastProgress);
    _animation = _tween.animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  void setNewProgress(double newProgress) {
    _tween = Tween(begin: _lastProgress, end: newProgress);
    _animationController.reset();
    _animation = _tween.animate(_animationController);
    _animationController.forward();
    _lastProgress = newProgress;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
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
      if (progress != _lastProgress) {
        setNewProgress(progress);
      }
      // logger.t(
      //     'TrackItemActiveControl: ${_animation.value} progress=${progress} position=${position} duration=${duration}');
    }

    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        SizedBox(
          width: trackItemControlCircleSize,
          height: trackItemControlCircleSize,
          child: isPlaying
              ? CircularProgressIndicator(
                  color: appColors.brandColor,
                  strokeWidth: 3,
                  // value: progress,
                  value: _animation.value,
                )
              : SizedBox(),
        ),
        TrackItemDefaultControl(track: widget.track, isActive: isActive),
      ],
    );
  }
}
