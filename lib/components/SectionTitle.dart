import 'package:flutter/material.dart';

import 'package:march_tales_app/app/AppColors.dart';

class SectionTitle extends StatelessWidget {
  final String text;

  const SectionTitle({
    super.key,
    required this.text,
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

    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(this.text.toUpperCase(), style: headerStyle),
        ColoredBox(
          color: appColors.brandColor,
          child: SizedBox(height: 3, width: 100),
        ),
      ],
    );
  }
}
