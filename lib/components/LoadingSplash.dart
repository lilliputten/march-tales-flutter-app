import 'package:flutter/material.dart';

import 'package:march_tales_app/app/AppColors.dart';

const double _loadingSplashSize = 48;
const double _loadingSplashStrokeWidth = 2;

class LoadingSplash extends StatelessWidget {
  final double size;

  const LoadingSplash({
    super.key,
    this.size = _loadingSplashSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;
    final baseColor = appColors.brandColor;
    final color = baseColor.withValues(alpha: 0.5);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: this.size,
          width: this.size,
          child: CircularProgressIndicator(color: color, strokeWidth: _loadingSplashStrokeWidth),
        ),
      ],
    );
  }
}
