import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/features/Track/widgets/AuthorImageThumbnail.dart';
import 'package:march_tales_app/screens/AuthorScreen.dart';

final logger = Logger();

class _AuthorTitle extends StatelessWidget {
  const _AuthorTitle({
    // super.key,
    required this.author,
    this.fullView = false,
    this.compact = false,
    this.active = false,
  });
  final TrackAuthor author;
  final bool fullView;
  final bool compact;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textColor = colorScheme.onSurface;
    final baseStyle = compact ? theme.textTheme.bodySmall : theme.textTheme.bodyMedium;
    final style = baseStyle!.copyWith(
      // fontWeight: FontWeight.bold,
      color: textColor,
    );
    String text = author.name;
    if (AppConfig.LOCAL) {
      text += ' (${author.id})';
    }
    return Text(text, style: style);
  }
}

class AuthorListInlineItem extends StatelessWidget {
  const AuthorListInlineItem({
    super.key,
    required this.author,
    this.fullView = false,
    this.compact = false,
    this.active = false,
  });

  final TrackAuthor author;
  final bool fullView;
  final bool compact;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: active
          ? () {
              Navigator.restorablePushNamed(
                context,
                AuthorScreen.routeName,
                arguments: author.id,
              );
            }
          : null,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: compact ? 5 : 10,
        children: [
          AuthorImageThumbnail(author: author, size: compact ? 20 : 30),
          _AuthorTitle(author: author, fullView: fullView, compact: compact, active: active),
        ].nonNulls.toList(),
      ),
    );
  }
}
