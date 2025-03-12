import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/features/Track/types/Author.dart';
import 'package:march_tales_app/features/Track/widgets/AuthorListItem.dart';

final logger = Logger();

class AuthorsList extends StatelessWidget {
  const AuthorsList({
    super.key,
    required this.authors,
    this.fullView = false,
    this.compact = false,
    this.active = false,
  });

  final List<Author> authors;
  final bool fullView;
  final bool compact;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: this.authors.map((author) {
        return AuthorListItem(author: author, fullView: fullView, compact: compact, active: active);
      }).toList(),
    );
  }
}
