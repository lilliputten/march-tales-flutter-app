import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/screens/TagScreen.dart';

final logger = Logger();

class TagsInlineList extends StatelessWidget {
  const TagsInlineList({
    super.key,
    required this.tags,
    this.compact = false,
    this.active = false,
    this.color,
  });
  final List<TrackTag> tags;
  final bool compact;
  final bool active;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final basicColor = color ?? colorScheme.onSurface;
    final style = compact ? theme.textTheme.bodySmall! : theme.textTheme.bodyMedium!;
    final dimmedColor = basicColor.withValues(alpha: 0.25);
    final textStyle = style.copyWith(color: basicColor);
    final dimmedStyle = style.copyWith(color: dimmedColor);
    return Wrap(
        spacing: compact ? 5 : 10,
        crossAxisAlignment: WrapCrossAlignment.center,
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
              spacing: 2, // compact ? 2 : 5,
              children: [
                Text('#', style: dimmedStyle),
                Text(tag.text, style: textStyle),
              ],
            ),
          );
        }).toList());
  }
}
