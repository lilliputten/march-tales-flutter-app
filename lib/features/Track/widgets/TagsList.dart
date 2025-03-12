import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/features/Track/types/Tag.dart';
import 'package:march_tales_app/screens/TagScreen.dart';

final logger = Logger();

class TagsList extends StatelessWidget {
  const TagsList({
    super.key,
    required this.tags,
    this.compact = false,
    this.active = true,
    this.color,
  });
  final List<Tag> tags;
  final bool compact;
  final bool active;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final basicColor = color ?? colorScheme.onSurface;
    final style = compact ? theme.textTheme.bodySmall! : theme.textTheme.bodyMedium!;
    final textStyle = style.copyWith(color: basicColor);
    final dimmedColor = basicColor.withValues(alpha: 0.25);
    final dimmedStyle = style.copyWith(color: dimmedColor);
    return Wrap(
        spacing: compact ? 5 : 10,
        runSpacing: compact ? 5 : 10,
        children: this.tags.map((tag) {
          return InkWell(
            onTap: active
                ? () {
                    Navigator.restorablePushNamed(
                      context,
                      TagScreen.routeName,
                      arguments: tag.id,
                    );
                  }
                : null,
            child: Wrap(
              spacing: compact ? 2 : 5,
              children: [
                Text('#', style: dimmedStyle),
                Text(tag.text, style: textStyle),
              ],
            ),
            /*
            child: Container(
              padding: EdgeInsets.symmetric(vertical: compact ? 0 : 1, horizontal: compact ? 3 : 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                border: Border.all(color: borderColor, width: 1),
              ),
              child: Text(tag.text, style: textStyle),
            ),
            */
          );
        }).toList());
  }
}
