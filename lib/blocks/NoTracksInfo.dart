import 'package:flutter/material.dart';

import 'NoTracksInfo.i18n.dart';

class NoTracksInfo extends StatelessWidget {
  final double padding;

  const NoTracksInfo({
    super.key,
    // Adjust to occopy the same height as the default loader spinner
    this.padding = 14,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyMedium!;
    final color = theme.colorScheme.onSurface.withValues(alpha: 0.5);
    return Padding(
      padding: EdgeInsets.all(this.padding),
      child: Text(
        'No tracks to display.'.i18n,
        style: style.copyWith(color: color),
      ),
    );
  }
}
