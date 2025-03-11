import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/features/Track/types/Track.dart';

final logger = Logger();

class RubricsLinileList extends StatelessWidget {
  const RubricsLinileList({
    super.key,
    required this.rubrics,
    this.small = false,
    this.active = false,
    this.color,
  });
  final List<TrackRubric> rubrics;
  final bool small;
  final bool active;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final basicColor = color ?? colorScheme.onSurface;
    final style = small ? theme.textTheme.bodySmall! : theme.textTheme.bodyMedium!;
    final borderColor = basicColor.withValues(alpha: 0.1);
    final textStyle = style.copyWith(color: basicColor);
    return Wrap(
        spacing: small ? 5 : 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: this.rubrics.map((rubric) {
          return InkWell(
            onTap: active
                ? () {
                    logger.d('[RubricsLinileList] rubricId=${rubric.id}');
                    debugger();
                    /*
                    Navigator.restorablePushNamed(
                      context,
                      RubricScreen.routeName,
                      arguments: rubric.id,
                    );
                    */
                  }
                : null,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: small ? 0 : 1, horizontal: small ? 3 : 6),
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
