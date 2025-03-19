import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/app/ErrorBlock.dart';
import 'package:march_tales_app/app/ScreenWrapper.dart';
import 'package:march_tales_app/components/LoadingSplash.dart';
import 'package:march_tales_app/components/mixins/ScrollControllerProviderMixin.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/exceptions/ConnectionException.dart';
import 'package:march_tales_app/core/helpers/showErrorToast.dart';
import 'package:march_tales_app/features/Track/loaders/loadRubricDetails.dart';
import 'package:march_tales_app/features/Track/types/Rubric.dart';
import 'package:march_tales_app/screens/views/RubricScreenView.dart';
import 'RubricScreen.i18n.dart';

final logger = Logger();

const _routeName = '/RubricScreen';

const _debugRubricId = 1;

@pragma('vm:entry-point')
class RubricScreen extends StatefulWidget {
  const RubricScreen({
    super.key,
  });

  static const routeName = _routeName;

  @override
  State<RubricScreen> createState() => RubricScreenState();
}

class RubricScreenState extends State<RubricScreen> with ScrollControllerProviderMixin {
  late Future<Rubric> dataFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.dataFuture = this._loadDataFuture();
  }

  int _getRubricId() {
    try {
      final int? id = ModalRoute.of(context)?.settings.arguments as int?;
      if (id == null) {
        throw Exception('No rubric id has been passed for RubricScreen');
      }
      return id;
    } catch (err) {
      if (AppConfig.LOCAL) {
        // Return demo id for debug purposes
        return _debugRubricId;
      }
      rethrow;
    }
  }

  Future<Rubric> _loadDataFuture() async {
    final int id = this._getRubricId();
    try {
      /* // DEBUG
       * await Future.delayed(Duration(seconds: 2));
       * throw new Exception('Test error');
       */
      return loadRubricDetails(id);
    } catch (err, stacktrace) {
      final String msg = 'Error loading rubric data.';
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
      title: 'Rubric'.i18n,
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
            final rubric = snapshot.data!;
            return RubricScreenView(
              rubric: rubric,
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
