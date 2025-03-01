// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/app/AppColors.dart';

final logger = Logger();

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final Offset _offset = Offset(15, 0);
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = _offset.dx;
    final double trackTop = _offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - _offset.dx * 2;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class PlayerSlider extends StatelessWidget {
  const PlayerSlider({
    super.key,
    required this.position,
    required this.duration,
    required this.onSeek,
  });

  final Duration? position;
  final Duration duration;
  final ValueSetter<Duration> onSeek;

  @override
  Widget build(BuildContext context) {
    // final appState = context.watch<AppState>();
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;
    // final colorScheme = theme.colorScheme;

    double progress = 0;
    final durationMs = duration.inMilliseconds;
    final positionMs = position?.inMilliseconds ?? 0;
    if (durationMs != 0 && positionMs != 0) {
      progress = positionMs / durationMs;
      if (progress > 1) {
        progress = 1;
      }
    }

    return SliderTheme(
      data: SliderThemeData(
        trackShape: CustomTrackShape(),
        trackHeight: 1,
        activeTrackColor: appColors.brandColor,
        thumbColor: appColors.brandColor,
      ),
      child: Slider(
        value: progress,
        onChanged: (double value) {
          final positionMs = (value * durationMs).round();
          final position = Duration(milliseconds: positionMs);
          // logger.t(
          //     '[PlayerSlider:Slider:onChanged] positionMs=${positionMs} durationMs=${durationMs} position=${position}');
          onSeek(position);
          // appState.playSeek(position);
        },
      ),
    );
  }
}
