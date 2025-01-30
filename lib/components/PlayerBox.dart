import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:march_tales_app/app/AppColors.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/shared/states/MyAppState.dart';

final logger = Logger();

// @see https://docs.flutter.dev/cookbook/networking/fetch-data
class PlayerBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;
    final style = theme.textTheme.bodyMedium!;
    // final colorScheme = theme.colorScheme;
    // final bgColor = colorScheme.primary;
    // final textColor = colorScheme.onPrimary;
    final bgColor = appColors.brandColor; // .withValues(alpha: 0.75);
    final textColor = appColors.onBrandColor;

    final track = appState.playingTrack;

    // No active track?
    if (track == null) {
      return Container();
    }

    String text = 'Current track: ${track.title}';
    if (appState.isPlaying) {
      text += ' (playing)';
    }

    return ColoredBox(
      color: bgColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: style.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}
