import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/features/Track/widgets/AuthorListInlineItem.dart';

final logger = Logger();

class AuthorsInlineList extends StatelessWidget {
  const AuthorsInlineList({
    super.key,
    required this.authors,
    this.fullView = false,
    this.compact = false,
    this.active = false,
  });

  final List<TrackAuthor> authors;
  final bool fullView;
  final bool compact;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: authors.map((author) {
        return AuthorListInlineItem(author: author, fullView: fullView, compact: compact, active: active);
      }).toList(),
    );
  }
}
