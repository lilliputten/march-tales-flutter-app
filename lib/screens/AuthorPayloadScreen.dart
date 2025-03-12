import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/app/AppErrorScreen.dart';
import 'package:march_tales_app/app/ScreenWrapper.dart';
import 'package:march_tales_app/components/LoadingSplash.dart';
import 'package:march_tales_app/features/Track/types/Author.dart';
import 'package:march_tales_app/features/Track/widgets/AuthorView.dart';

final logger = Logger();

const _routeName = '/AuthorScreen';

@pragma('vm:entry-point')
class AuthorPayloadScreen extends StatefulWidget {
  const AuthorPayloadScreen({
    super.key,
  });

  static const routeName = _routeName;

  @override
  State<AuthorPayloadScreen> createState() => AuthorPayloadScreenState();
}

class AuthorPayloadScreenState extends State<AuthorPayloadScreen> {
  late Future<Author> dataFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Author data = this._getAuthorData();
    final future = Future.value(data);
    this.dataFuture = future;
  }

  Author _getAuthorData() {
    try {
      final Author? data = ModalRoute.of(context)?.settings.arguments as Author?;
      if (data == null) {
        throw Exception('No author data has been passed for AuthorPayloadScreen');
      }
      return data;
    } catch (err, stacktrace) {
      final String msg = 'Can not get author data: ${err}';
      logger.e('[AuthorPayloadScreen:_getAuthorData] error ${msg}', error: err, stackTrace: stacktrace);
      debugger();
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
            return AuthorView(author: author);
          } else {
            return LoadingSplash();
          }
        },
      ),
    );
  }
}
