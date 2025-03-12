import 'package:flutter/material.dart';

import 'package:march_tales_app/app/AppColors.dart';

class SectionTitle extends StatelessWidget {
  final String text;
  final String extraText;
  final bool upperCase;

  const SectionTitle({
    super.key,
    required this.text,
    this.extraText = '',
    this.upperCase = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;
    final colorScheme = theme.colorScheme;
    final textColor = colorScheme.onSurface;
    final headerStyle = theme.textTheme.bodyLarge!.copyWith(
      fontWeight: FontWeight.bold,
      color: textColor,
    );
    final extraStyle = theme.textTheme.bodyLarge!.copyWith(
      color: textColor.withValues(alpha: 0.5),
    );

    final headerText = this.upperCase ? this.text.toUpperCase() : this.text;

    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 5,
          children: [
            Text(headerText, style: headerStyle),
            this.extraText.isNotEmpty ? Text(this.extraText, style: extraStyle) : null,
          ].nonNulls.toList(),
        ),
        ColoredBox(
          color: appColors.brandColor,
          child: SizedBox(height: 3, width: 100),
        ),
      ],
    );
  }
}
