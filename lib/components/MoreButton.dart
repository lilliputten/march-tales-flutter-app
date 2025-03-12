import 'package:flutter/material.dart';

import 'MoreButton.i18n.dart';

class MoreButton extends StatelessWidget {
  // TODO: To use auto-update and lazy-scroll
  const MoreButton({
    super.key,
    required this.isLoading,
    this.onLoadNext,
  });

  final bool isLoading;
  final void Function()? onLoadNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColorTheme = theme.buttonTheme.colorScheme!;
    final baseColor = buttonColorTheme.primary;
    final color = isLoading ? baseColor.withValues(alpha: 0.5) : baseColor;
    const double iconSize = 20;
    return Center(
      child: TextButton.icon(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll<Color>(color),
        ),
        onPressed: isLoading ? null : this.onLoadNext,
        icon: isLoading
            ? SizedBox(
                height: iconSize,
                width: iconSize,
                child: CircularProgressIndicator(color: color, strokeWidth: 2),
              )
            : Icon(Icons.arrow_circle_down, size: iconSize, color: color),
        label: Text(isLoading ? 'Loading...'.i18n : 'Show more...'.i18n),
      ),
    );
  }
}
