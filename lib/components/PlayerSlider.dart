import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/app/AppColors.dart';
import 'PlayerBox/common.dart';

final logger = Logger();

class PlayerSlider extends StatelessWidget {
  const PlayerSlider({
    super.key,
    required this.position,
    required this.duration,
    required this.onSeek,
    required this.positionDataStream,
  });

  final Duration? position;
  final Duration duration;
  final ValueSetter<Duration> onSeek;
  final Stream<PositionData> positionDataStream;

  @override
  Widget build(BuildContext context) {
    /* // New player slider (in progress; it's glitchy at the moment)
    return StreamBuilder<PositionData>(
      stream: this.positionDataStream,
      builder: (context, snapshot) {
        final positionData = snapshot.data;
        // logger.t('XXX positionData=${positionData} this.positionDataStream=${this.positionDataStream}');
        return SeekBar(
          duration: positionData?.duration ?? this.duration,
          position: positionData?.position ?? this.position ?? Duration.zero,
          bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
          onChangeEnd: (newPosition) {
            onSeek(newPosition);
          },
        );
      },
    );
    */

    /* // Old naive seek bar implementation
    */
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;
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
          onSeek(position);
        },
      ),
    );
  }
}
