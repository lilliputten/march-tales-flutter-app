import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/blocks/SectionTitle.dart';
import 'package:march_tales_app/components/CustomBackButton.dart';
import 'package:march_tales_app/features/Track/types/Author.dart';
import 'package:march_tales_app/features/Track/widgets/AuthorsList.dart';
import 'translations.i18n.dart';

final logger = Logger();

class AuthorsListScreenView extends StatelessWidget {
  const AuthorsListScreenView({
    super.key,
    required this.authors,
    this.scrollController,
  });

  final List<Author> authors;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: this.scrollController,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 15,
          children: [
            Padding(
              padding: const EdgeInsets.all(0),
              child: SectionTitle(
                text: 'All authors'.i18n,
                extraText: '(${this.authors.length})',
              ),
            ),
            AuthorsList(
              authors: this.authors,
              active: true,
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: CustomBackButton(),
            ),
          ],
        ),
      ),
    );
  }
}
