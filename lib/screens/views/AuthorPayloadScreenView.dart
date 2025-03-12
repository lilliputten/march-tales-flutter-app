import 'package:flutter/material.dart';

import 'package:march_tales_app/features/Track/types/Author.dart';
import 'package:march_tales_app/features/Track/widgets/AuthorDetails.dart';

class AuthorPayloadScreenView extends StatelessWidget {
  const AuthorPayloadScreenView({
    super.key,
    required this.author,
    this.scrollController,
  });

  final Author author;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            restorationId: 'AuthorPayloadScreenView-${this.author.id}',
            controller: this.scrollController,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: AuthorDetails(author: this.author, fullView: true),
            ),
          ),
        ),
      ],
    );
  }
}
