import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/app/AppErrorScreen.dart';
import 'package:march_tales_app/app/ScreenWrapper.dart';
import 'package:march_tales_app/components/LoadingSplash.dart';
import 'package:march_tales_app/components/mixins/ScrollControllerProviderMixin.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/features/Track/loaders/loadAuthorDetails.dart';
import 'package:march_tales_app/features/Track/types/Author.dart';
import 'package:march_tales_app/screens/views/AuthorPayloadScreenView.dart';

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
  late Future<Author> dataFuture;

  @override
  void didChangeDependencies() {
    final int id = this._getAuthorId();
    super.didChangeDependencies();
    this.dataFuture = loadAuthorDetails(id);
  }

  int _getAuthorId() {
    try {
      final int? id = ModalRoute.of(context)?.settings.arguments as int?;
      if (id == null) {
        throw Exception('No author id has been passed for AuthorScreen');
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

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      title: 'Show author',
      child: FutureBuilder(
        future: this.dataFuture,
        builder: (context, snapshot) {
          if (snapshot.error != null) {
            return AppErrorScreen(error: snapshot.error);
          }
          if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
            final author = snapshot.data!;
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
