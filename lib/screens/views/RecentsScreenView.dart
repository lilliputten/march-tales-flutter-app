import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:march_tales_app/components/RecentDetails.dart';
import 'package:march_tales_app/features/Track/loaders/RecentResults.dart';
import 'package:march_tales_app/shared/states/AppState.dart';

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
    final appState = context.watch<AppState>();
    return RefreshIndicator(
      onRefresh: () async {
        await appState.reloadRecentsData();
      },
      child: SingleChildScrollView(
        controller: this.scrollController,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: RecentDetails(
            recentResults: this.recentResults,
          ),
        ),
      ),
    );
  }
}
