import 'package:flutter/material.dart';

class AppErrorScreen extends StatelessWidget {
  const AppErrorScreen({
    super.key,
    required this.error,
  });
  final dynamic error;

  @override
  Widget build(BuildContext context) {
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
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
                error.toString(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
