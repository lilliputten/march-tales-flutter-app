import 'package:flutter/material.dart';

import 'package:march_tales_app/core/helpers/convertErrorLikeToString.dart';

class AppErrorScreen extends StatelessWidget {
  const AppErrorScreen({
    super.key,
    required this.error,
  });
  final dynamic error;

  @override
  Widget build(BuildContext context) {
    String text = convertErrorLikeToString(error);
    // TODO: Check for `VersionException` type and show an extra update block for it
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 20,
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.red, // .withValues(alpha: 0.5),
                    size: 80,
                  ),
                  SelectableText(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
