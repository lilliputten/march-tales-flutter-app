import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger();

// @see https://docs.flutter.dev/cookbook/networking/fetch-data
class TopMenuBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final appState = context.watch<MyAppState>();
    var colorScheme = Theme.of(context).colorScheme;
    // var theme = Theme.of(context);

    return ColoredBox(
      color: colorScheme.primary,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Text('TopMenu'),
            // BigCard(pair: pair),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
