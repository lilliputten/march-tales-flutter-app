import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/app/ErrorBlock.dart';
import 'package:march_tales_app/app/ScreenWrapper.dart';
import 'package:march_tales_app/components/LoadingSplash.dart';
import 'package:march_tales_app/components/mixins/ScrollControllerProviderMixin.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/exceptions/ConnectionException.dart';
import 'package:march_tales_app/core/helpers/showErrorToast.dart';
import 'package:march_tales_app/features/Track/loaders/loadAuthorDetails.dart';
import 'package:march_tales_app/features/Track/types/Author.dart';
import 'package:march_tales_app/screens/views/AuthorPayloadScreenView.dart';
import 'AuthorScreen.i18n.dart';

final logger = Logger();

const _routeName = '/AuthorScreen';

const _debugAuthorId = 1;

@pragma('vm:entry-point')
class AuthorScreen extends StatefulWidget {
  const AuthorScreen({
    super.key,
  });

  static const routeName = _routeName;

  @override
  State<AuthorScreen> createState() => AuthorScreenState();
}

class AuthorScreenState extends State<AuthorScreen> with ScrollControllerProviderMixin {
  late Future dataFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this._loadData();
  }

  int _getAuthorId() {
    try {
      final int? id = ModalRoute.of(context)?.settings.arguments as int?;
      if (id == null) {
        throw Exception('No author id has been passed for the AuthorScreen.');
      }
      return id;
    } catch (err) {
      if (AppConfig.LOCAL) {
        // Return demo id for debug purposes
        return _debugAuthorId;
      }
      rethrow;
    }
  }

  _loadDataFuture() async {
    final int id = this._getAuthorId();
    try {
      /* // DEBUG
       * if (AppConfig.LOCAL) {
       *   await Future.delayed(Duration(seconds: 2));
       * }
       * throw new Exception('Test error');
       */
      return await loadAuthorDetails(id);
    } catch (err, stacktrace) {
      final String msg = 'Error loading author data.';
      logger.e('${msg}: id=${id} $err', error: err, stackTrace: stacktrace);
      final translatedMsg = msg.i18n;
      showErrorToast(translatedMsg);
      throw ConnectionException(translatedMsg);
    }
  }

  _loadData() {
    setState(() {
      this.dataFuture = this._loadDataFuture();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      title: 'Show author'.i18n,
      child: FutureBuilder(
        future: this.dataFuture,
        builder: (context, snapshot) {
          final isReady = snapshot.connectionState == ConnectionState.done;
          final isError = isReady && snapshot.error != null;
          final hasData = !isError && snapshot.data != null;
          if (isError) {
            return ErrorBlock(
              error: snapshot.error,
              onRetry: this._loadData,
              large: true,
            );
          } else if (hasData) {
            final Author author = snapshot.data!;
            return AuthorPayloadScreenView(
              author: author,
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
