import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/app/AppErrorScreen.dart';
import 'package:march_tales_app/app/ScreenWrapper.dart';
import 'package:march_tales_app/components/LoadingSplash.dart';
import 'package:march_tales_app/components/mixins/ScrollControllerProviderMixin.dart';
import 'package:march_tales_app/core/exceptions/ConnectionException.dart';
import 'package:march_tales_app/core/helpers/showErrorToast.dart';
import 'package:march_tales_app/features/Track/loaders/LoadRubricsListResults.dart';
import 'package:march_tales_app/features/Track/loaders/loadRubricsList.dart';
import 'package:march_tales_app/screens/views/RubricsListScreenView.dart';
import 'RubricsListScreen.i18n.dart';

final logger = Logger();

const _routeName = '/RubricsListScreen';

@pragma('vm:entry-point')
class RubricsListScreen extends StatefulWidget {
  const RubricsListScreen({
    super.key,
  });

  static const routeName = _routeName;

  @override
  State<RubricsListScreen> createState() => RubricsListScreenState();
}

class RubricsListScreenState extends State<RubricsListScreen> with ScrollControllerProviderMixin {
  late Future dataFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.dataFuture = this._loadDataFuture();
  }

  _loadDataFuture() async {
    try {
      return await loadRubricsList();
    } catch (err, stacktrace) {
      final String msg = 'Error loading rubrics list.';
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
      title: 'Rubrics list',
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
            final LoadRubricsListResults data = snapshot.data!;
            return RubricsListScreenView(
              rubrics: data.results,
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
