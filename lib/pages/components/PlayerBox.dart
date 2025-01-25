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
    var colorScheme = Theme.of(context).colorScheme;

    if (!appState.hasActivePlayer) {
      return Container();
    }

    return ColoredBox(
      color: colorScheme.primary,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Text('PlayerBox'),
            // BigCard(pair: pair),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
