import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/blocks/SectionTitle.dart';
import 'package:march_tales_app/components/CustomBackButton.dart';
import 'package:march_tales_app/features/Track/types/Rubric.dart';
import 'package:march_tales_app/features/Track/widgets/RubricsList.dart';
import 'translations.i18n.dart';

final logger = Logger();

class RubricsListScreenView extends StatelessWidget {
  const RubricsListScreenView({
    super.key,
    required this.rubrics,
    this.scrollController,
  });

  final List<Rubric> rubrics;
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
                text: 'All rubrics'.i18n,
                extraText: '(${this.rubrics.length})',
              ),
            ),
            RubricsList(
              rubrics: this.rubrics,
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
