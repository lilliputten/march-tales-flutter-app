import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/app/AppErrorScreen.dart';
import 'package:march_tales_app/app/ScreenWrapper.dart';
import 'package:march_tales_app/components/LoadingSplash.dart';
import 'package:march_tales_app/components/mixins/ScrollControllerProviderMixin.dart';
import 'package:march_tales_app/core/exceptions/ConnectionException.dart';
import 'package:march_tales_app/core/helpers/showErrorToast.dart';
import 'package:march_tales_app/features/Track/loaders/LoadAuthorsListResults.dart';
import 'package:march_tales_app/features/Track/loaders/loadAuthorsList.dart';
import 'package:march_tales_app/screens/views/AuthorsListScreenView.dart';
import 'AuthorsListScreen.i18n.dart';

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
  late Future dataFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.dataFuture = this._loadDataFuture();
  }

  _loadDataFuture() async {
    try {
      return await loadAuthorsList();
    } catch (err, stacktrace) {
      final String msg = 'Error loading authors list.';
      logger.e('${msg}: $err', error: err, stackTrace: stacktrace);
      // debugger();
      final translatedMsg = msg.i18n;
      showErrorToast(translatedMsg);
      throw ConnectionException(translatedMsg);
    }
  }

  _retryDataLoad() {
    this.dataFuture = this._loadDataFuture();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      title: 'Authors list'.i18n,
      child: FutureBuilder(
        future: this.dataFuture,
        builder: (context, snapshot) {
          if (snapshot.error != null) {
            return AppErrorScreen(
              error: snapshot.error,
              onRetry: this._retryDataLoad,
            );
          }
          if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
            final LoadAuthorsListResults data = snapshot.data!;
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
