import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/features/Track/types/Track.dart';

final logger = Logger();

class TagsLinileList extends StatelessWidget {
  const TagsLinileList({
    super.key,
    required this.tags,
    this.small = false,
    this.active = false,
    this.color,
  });
  final List<TrackTag> tags;
  final bool small;
  final bool active;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final basicColor = color ?? colorScheme.onSurface;
    final style = small ? theme.textTheme.bodySmall! : theme.textTheme.bodyMedium!;
    final dimmedColor = basicColor.withValues(alpha: 0.25);
    final textStyle = style.copyWith(color: basicColor);
    final dimmedStyle = style.copyWith(color: dimmedColor);
    return Wrap(
        spacing: small ? 5 : 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: this.tags.map((tag) {
          return InkWell(
            onTap: active
                ? () {
                    logger.d('[TagsLinileList] tagId=${tag.id}');
                    debugger();
                    /*
                    Navigator.restorablePushNamed(
                      context,
                      TagScreen.routeName,
                      arguments: tag.id,
                    );
                    */
                  }
                : null,
            child: Wrap(
              spacing: small ? 2 : 5,
              children: [
                Text('#', style: dimmedStyle),
                Text(tag.text, style: textStyle),
              ],
            ),
          );
        }).toList());
  }
}
