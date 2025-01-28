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
    final colorScheme = Theme.of(context).colorScheme;
    final track = appState.playingTrack;

    // No active track?
    if (track == null) {
      return Container();
    }

    return ColoredBox(
      color: colorScheme.primary,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Text('Playing track: ${track.title}'),
        ),
      ),
    );
  }
}
