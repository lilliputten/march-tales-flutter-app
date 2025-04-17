import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/app/ErrorBlock.dart';
import 'package:march_tales_app/components/LoadingSplash.dart';
import 'package:march_tales_app/screens/views/RecentsScreenView.dart';
import 'package:march_tales_app/shared/states/AppState.dart';

final logger = Logger();

class RecentsScreen extends StatelessWidget {
  final ScrollController? scrollController;

  const RecentsScreen({
    super.key,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return FutureBuilder(
      future: appState.recentsFuture,
      builder: (context, snapshot) {
        final isReady = snapshot.connectionState == ConnectionState.done;
        final isError = isReady && snapshot.error != null;
        final hasData = !isError && snapshot.data != null;
        logger.t('[RecentsScreen] data=${snapshot.data} isReady=${isReady} error=${snapshot.error}');
        if (isError) {
          return ErrorBlock(
            error: snapshot.error,
            onRetry: () {
              appState.reloadRecentsData();
            },
          );
        } else if (isReady && hasData) {
          return RecentsScreenView(
            recentResults: snapshot.data!,
            scrollController: this.scrollController,
          );
        } else {
          return LoadingSplash();
        }
      },
    );
  }
}
