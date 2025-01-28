import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger();

// @see https://docs.flutter.dev/cookbook/networking/fetch-data
class TopMenuBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme.copyWith(
          brightness: Brightness.dark,
        );

    return ColoredBox(
      color: colorScheme.primary.withValues(alpha: 0.5),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Text('--TopMenu--'),
        ),
      ),
    );
  }
}
