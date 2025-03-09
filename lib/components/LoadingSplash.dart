import 'package:flutter/material.dart';

const double _loadingSplashSize = 48;
const double _loadingSplashStrokeWidth = 2;

class LoadingSplash extends StatelessWidget {
  const LoadingSplash({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColorTheme = theme.buttonTheme.colorScheme!;
    final baseColor = buttonColorTheme.primary;
    final color = baseColor.withValues(alpha: 0.5);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: _loadingSplashSize,
          width: _loadingSplashSize,
          child: CircularProgressIndicator(color: color, strokeWidth: _loadingSplashStrokeWidth),
        ),
      ],
    );
  }
}
