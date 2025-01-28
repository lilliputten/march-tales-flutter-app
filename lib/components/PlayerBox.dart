import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/shared/states/MyAppState.dart';

final logger = Logger();

// @see https://docs.flutter.dev/cookbook/networking/fetch-data
class PlayerBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final track = appState.playingTrack;

    final theme = Theme.of(context);
    final style = theme.textTheme.bodyMedium!;
    final colorScheme = theme.colorScheme;
    final bgColor = colorScheme.primary;
    final textColor = colorScheme.onPrimary;

    // No active track?
    if (track == null) {
      return Container();
    }

    return ColoredBox(
      color: bgColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Text('Playing track: ${track.title}',
              style: style.copyWith(color: textColor)),
        ),
      ),
    );
  }
}
