import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:march_tales_app/app/AppColors.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/shared/states/MyAppState.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';

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

const double _iconSize = 24;
const double _circleSize = _iconSize + 16;

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
    _tween = Tween(begin: 0, end: 0);
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
      if (progress != _lastProgress) {
        setNewProgress(progress);
      }
      logger.t(
          'TrackItemActiveControl: ${_animation.value} progress=${progress} position=${position} duration=${duration}');
    }

    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        SizedBox(
          width: _circleSize,
          height: _circleSize,
          child: CircularProgressIndicator(
            color: appColors.brandColor.withValues(alpha: 0.2),
            strokeWidth: 2,
            value: 1,
          ),
        ),
        SizedBox(
          width: _circleSize,
          height: _circleSize,
          child: isPlaying
              ? CircularProgressIndicator(
                  color: appColors.brandColor,
                  strokeWidth: 3,
                  // value: progress,
                  value: _animation.value,
                )
              : SizedBox(),
        ),
        IconButton(
          icon: Icon(
            isActive ? Icons.pause : Icons.play_arrow,
            size: _iconSize,
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
