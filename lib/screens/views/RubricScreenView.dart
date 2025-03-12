import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/features/Track/types/Rubric.dart';
import 'package:march_tales_app/features/Track/widgets/RubricDetails.dart';

final logger = Logger();

class RubricScreenView extends StatelessWidget {
  const RubricScreenView({
    super.key,
    required this.rubric,
    this.scrollController,
  });

  final Rubric rubric;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            restorationId: 'RubricScreenView-${this.rubric.id}',
            controller: this.scrollController,
            child: Padding(
              padding: const EdgeInsets.all(10),
              // child: Text(this.rubric.text),
              child: RubricDetails(rubric: this.rubric, fullView: true),
            ),
          ),
        ),
      ],
    );
  }
}
