import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/app/ErrorBlock.dart';
import 'package:march_tales_app/app/ScreenWrapper.dart';
import 'package:march_tales_app/components/LoadingSplash.dart';
import 'package:march_tales_app/components/mixins/ScrollControllerProviderMixin.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/exceptions/ConnectionException.dart';
import 'package:march_tales_app/core/helpers/showErrorToast.dart';
import 'package:march_tales_app/features/Track/loaders/loadTagDetails.dart';
import 'package:march_tales_app/features/Track/types/Tag.dart';
import 'package:march_tales_app/screens/views/TagScreenView.dart';
import 'TagScreen.i18n.dart';

final logger = Logger();

const _routeName = '/TagScreen';

const _debugTagId = 1;

@pragma('vm:entry-point')
class TagScreen extends StatefulWidget {
  const TagScreen({
    super.key,
  });

  static const routeName = _routeName;

  @override
  State<TagScreen> createState() => TagScreenState();
}

class TagScreenState extends State<TagScreen> with ScrollControllerProviderMixin {
  late Future<Tag> dataFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.dataFuture = this._loadDataFuture();
  }

  int _getTagId() {
    try {
      final int? id = ModalRoute.of(context)?.settings.arguments as int?;
      if (id == null) {
        throw Exception('No tag id has been passed for TagScreen');
      }
      return id;
    } catch (err) {
      if (AppConfig.LOCAL) {
        // Return demo id for debug purposes
        return _debugTagId;
      }
      rethrow;
    }
  }

  Future<Tag> _loadDataFuture() async {
    final int id = this._getTagId();
    try {
      /* // DEBUG
       * await Future.delayed(Duration(seconds: 2));
       * throw new Exception('Test error');
       */
      return loadTagDetails(id);
    } catch (err, stacktrace) {
      final String msg = 'Error loading tag data.';
      logger.e('${msg}: $err', error: err, stackTrace: stacktrace);
      final translatedMsg = msg.i18n;
      showErrorToast(translatedMsg);
      throw ConnectionException(translatedMsg);
    }
  }

  _reloadData() {
    setState(() {
      this.dataFuture = this._loadDataFuture();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      title: 'Show tag',
      child: FutureBuilder(
        future: this.dataFuture,
        builder: (context, snapshot) {
          final isReady = snapshot.connectionState == ConnectionState.done;
          final isError = isReady && snapshot.error != null;
          final hasData = !isError && snapshot.data != null;
          if (isError) {
            return ErrorBlock(
              error: snapshot.error,
              onRetry: this._reloadData,
              large: true,
            );
          } else if (hasData) {
            final tag = snapshot.data!;
            return TagScreenView(
              tag: tag,
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
