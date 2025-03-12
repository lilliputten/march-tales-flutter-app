import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/components/CustomBackButton.dart';
import 'package:march_tales_app/components/SectionTitle.dart';
import 'package:march_tales_app/features/Track/types/Tag.dart';
import 'package:march_tales_app/features/Track/widgets/TagsList.dart';
import 'translations.i18n.dart';

final logger = Logger();

class TagsListScreenView extends StatelessWidget {
  const TagsListScreenView({
    super.key,
    required this.tags,
    this.scrollController,
  });

  final List<Tag> tags;
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
                text: 'All tags'.i18n,
                extraText: '(${this.tags.length})',
              ),
            ),
            TagsList(
              tags: this.tags,
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
