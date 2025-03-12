import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/app/AppErrorScreen.dart';
import 'package:march_tales_app/app/ScreenWrapper.dart';
import 'package:march_tales_app/components/LoadingSplash.dart';
import 'package:march_tales_app/components/mixins/ScrollControllerProviderMixin.dart';
import 'package:march_tales_app/features/Track/loaders/LoadAuthorsListResults.dart';
import 'package:march_tales_app/features/Track/loaders/loadAuthorsList.dart';
import 'package:march_tales_app/screens/views/AuthorsListScreenView.dart';

final logger = Logger();

const _routeName = '/AuthorsListScreen';

@pragma('vm:entry-point')
class AuthorsListScreen extends StatefulWidget {
  const AuthorsListScreen({
    super.key,
  });

  static const routeName = _routeName;

  @override
  State<AuthorsListScreen> createState() => AuthorsListScreenState();
}

class AuthorsListScreenState extends State<AuthorsListScreen> with ScrollControllerProviderMixin {
  late Future<LoadAuthorsListResults> dataFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.dataFuture = loadAuthorsList();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      title: 'Show authors list',
      child: FutureBuilder(
        future: this.dataFuture,
        builder: (context, snapshot) {
          if (snapshot.error != null) {
            return AppErrorScreen(error: snapshot.error);
          }
          if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
            final data = snapshot.data!;
            return AuthorsListScreenView(
              authors: data.results,
              scrollController: this.getScrollController(),
            );
          } else {
            return LoadingSplash();
          }
        },
      ),
    );
  }
}
