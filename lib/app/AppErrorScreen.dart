import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/app/ErrorBlock.dart';
import 'package:march_tales_app/core/helpers/YamlFormatter.dart';

final formatter = YamlFormatter();
final logger = Logger();

class AppErrorScreen extends StatelessWidget {
  final dynamic error;
  final VoidCallback? onRetry;

  const AppErrorScreen({
    super.key,
    required this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: ErrorBlock(
                error: this.error,
                onRetry: this.onRetry,
                large: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
