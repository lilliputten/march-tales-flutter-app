import 'package:flutter/material.dart';

import 'package:march_tales_app/components/RecentDetails.dart';
import 'package:march_tales_app/features/Track/loaders/RecentResults.dart';

class RecentsScreenView extends StatelessWidget {
  final RecentResults recentResults;
  final ScrollController? scrollController;

  const RecentsScreenView({
    super.key,
    required this.recentResults,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: this.scrollController,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: RecentDetails(
          recentResults: this.recentResults,
        ),
      ),
    );
  }
}
