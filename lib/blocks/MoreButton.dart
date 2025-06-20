import 'package:flutter/material.dart';

import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/components/LoadingSplash.dart';
import 'MoreButton.i18n.dart';

class MoreButton extends StatelessWidget {
  final bool isLoading;
  final bool onlyLoader;
  final void Function()? onLoadNext;

  const MoreButton({
    super.key,
    this.onlyLoader = false,
    required this.isLoading,
    this.onLoadNext,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;
    // final buttonColorTheme = theme.buttonTheme.colorScheme!;
    final baseColor = appColors.brandColor; // buttonColorTheme.primary;
    final color = isLoading ? baseColor.withValues(alpha: 0.5) : baseColor;
    const double iconSize = 20;
    final double opacity = onlyLoader && !isLoading ? 0 : 1;
    return Center(
      child: Opacity(
        opacity: opacity,
        child: TextButton.icon(
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll<Color>(color),
          ),
          onPressed: isLoading ? null : this.onLoadNext,
          icon: isLoading || onlyLoader
              ? LoadingSplash(size: iconSize)
              : Icon(Icons.arrow_circle_down, size: iconSize, color: color),
          label: Text(isLoading ? 'Loading...'.i18n : 'Show more...'.i18n),
        ),
      ),
    );
  }
}
