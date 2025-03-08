import 'package:flutter/material.dart';

class AppErrorScreen extends StatelessWidget {
  const AppErrorScreen({
    super.key,
    required this.error,
  });
  final dynamic error;

  @override
  Widget build(BuildContext context) {
    final text = error?.cause ?? error.toString();
    // TODO: Check for `VersionException` and show an extra update block for it
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Expanded(
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
      ),
    );
  }
}
