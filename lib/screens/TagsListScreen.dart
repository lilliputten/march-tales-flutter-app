import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/app/ErrorBlock.dart';
import 'package:march_tales_app/app/ScreenWrapper.dart';
import 'package:march_tales_app/components/LoadingSplash.dart';
import 'package:march_tales_app/components/mixins/ScrollControllerProviderMixin.dart';
import 'package:march_tales_app/core/exceptions/ConnectionException.dart';
import 'package:march_tales_app/core/helpers/showErrorToast.dart';
import 'package:march_tales_app/features/Track/loaders/LoadTagsListResults.dart';
import 'package:march_tales_app/features/Track/loaders/loadTagsList.dart';
import 'package:march_tales_app/screens/views/TagsListScreenView.dart';
import 'TagsListScreen.i18n.dart';

final logger = Logger();

const _routeName = '/TagsListScreen';

@pragma('vm:entry-point')
class TagsListScreen extends StatefulWidget {
  const TagsListScreen({
    super.key,
  });

  static const routeName = _routeName;

  @override
  State<TagsListScreen> createState() => TagsListScreenState();
}

class TagsListScreenState extends State<TagsListScreen> with ScrollControllerProviderMixin {
  late Future dataFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.dataFuture = this._loadDataFuture();
  }

  _loadDataFuture() async {
    try {
      /* // DEBUG
       * await Future.delayed(Duration(seconds: 2));
       * throw new Exception('Test error');
       */
      return await loadTagsList(limit: 0);
    } catch (err, stacktrace) {
      final String msg = 'Error loading tags list.';
      logger.e('${msg}: $err', error: err, stackTrace: stacktrace);
      // debugger();
      final translatedMsg = msg.i18n;
      showErrorToast(translatedMsg);
      throw ConnectionException(translatedMsg);
    }
  }

  _retryDataLoad() {
    setState(() {
      this.dataFuture = this._loadDataFuture();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      title: 'Tags list'.i18n,
      child: FutureBuilder(
        future: this.dataFuture,
        builder: (context, snapshot) {
          final isReady = snapshot.connectionState == ConnectionState.done;
          final isError = isReady && snapshot.error != null;
          final hasData = !isError && snapshot.data != null;
          if (isError) {
            return ErrorBlock(
              error: snapshot.error,
              onRetry: this._retryDataLoad,
            );
          } else if (hasData) {
            final LoadTagsListResults data = snapshot.data!;
            return TagsListScreenView(
              tags: data.results,
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
