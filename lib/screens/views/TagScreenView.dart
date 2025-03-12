import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/features/Track/types/Tag.dart';
import 'package:march_tales_app/features/Track/widgets/TagDetails.dart';

final logger = Logger();

class TagScreenView extends StatelessWidget {
  const TagScreenView({
    super.key,
    required this.tag,
    this.scrollController,
  });

  final Tag tag;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            restorationId: 'TagScreenView-${this.tag.id}',
            controller: this.scrollController,
            child: Padding(
              padding: const EdgeInsets.all(10),
              // child: Text(this.tag.text),
              child: TagDetails(tag: this.tag, fullView: true),
            ),
          ),
        ),
      ],
    );
  }
}
