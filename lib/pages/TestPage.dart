import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

final logger = Logger();

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  static const routeName = '/Test';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyMedium!;

    return Text('Test', style: style);
  }
}
