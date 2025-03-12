import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/features/Track/types/Rubric.dart';
import 'package:march_tales_app/screens/RubricScreen.dart';

final logger = Logger();

class RubricsList extends StatelessWidget {
  const RubricsList({
    super.key,
    required this.rubrics,
    this.compact = false,
    this.active = true,
    this.color,
  });
  final List<Rubric> rubrics;
  final bool compact;
  final bool active;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final basicColor = color ?? colorScheme.onSurface;
    final style = compact ? theme.textTheme.bodySmall! : theme.textTheme.bodyMedium!;
    final borderColor = basicColor.withValues(alpha: 0.1);
    final textStyle = style.copyWith(color: basicColor);
    return Wrap(
        spacing: compact ? 5 : 10,
        runSpacing: compact ? 5 : 10,
        // crossAxisAlignment: CrossAxisAlignment.start,
        // crossAxisAlignment: WrapCrossAlignment.center,
        children: this.rubrics.map((rubric) {
          return InkWell(
            onTap: active
                ? () {
                    // logger.d('[RubricsList] rubricId=${rubric.id}');
                    Navigator.restorablePushNamed(
                      context,
                      RubricScreen.routeName,
                      arguments: rubric.id,
                    );
                  }
                : null,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: compact ? 0 : 1, horizontal: compact ? 3 : 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                border: Border.all(color: borderColor, width: 1),
              ),
              child: Text(rubric.text, style: textStyle),
            ),
          );
        }).toList());
  }
}
