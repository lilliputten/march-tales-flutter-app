import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/features/Track/types/Author.dart';
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
  final Author author;
  final bool fullView;
  final bool compact;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textColor = colorScheme.onSurface;
    final baseStyle = compact ? theme.textTheme.bodyMedium : theme.textTheme.bodyLarge;
    final style = baseStyle!.copyWith(
      fontWeight: FontWeight.bold,
      color: textColor,
    );
    String text = author.name;
    if (AppConfig.LOCAL) {
      text += ' (${author.id})';
    }
    return Text(text, style: style);
  }
}

class _AuthorDescription extends StatelessWidget {
  const _AuthorDescription({
    // super.key,
    required this.author,
    this.fullView = false,
    this.compact = false,
    this.active = false,
  });
  final Author author;
  final bool fullView;
  final bool compact;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final baseStyle = compact ? theme.textTheme.bodySmall : theme.textTheme.bodyMedium;
    final style = baseStyle!.copyWith(
      color: textColor,
    );

    return Text(
      author.short_description,
      style: style,
      softWrap: true,
    );
  }
}

class AuthorListItemInfo extends StatelessWidget {
  const AuthorListItemInfo({
    super.key,
    required this.author,
    this.fullView = false,
    this.compact = false,
    this.active = false,
  });

  final Author author;
  final bool fullView;
  final bool compact;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AuthorTitle(author: author, fullView: fullView, compact: compact, active: active),
        compact ? null : _AuthorDescription(author: author, fullView: fullView, compact: compact, active: active),
      ].nonNulls.toList(),
    );
  }
}

class AuthorListItem extends StatelessWidget {
  const AuthorListItem({
    super.key,
    required this.author,
    this.fullView = false,
    this.compact = false,
    this.active = false,
  });

  final Author author;
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
      child: Row(
        spacing: compact ? 10 : 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          AuthorImageThumbnail(author: author, size: compact ? 50 : 100),
          Expanded(
            child: AuthorListItemInfo(author: author, fullView: fullView, compact: compact, active: active),
          ),
        ].nonNulls.toList(),
      ),
    );
  }
}
