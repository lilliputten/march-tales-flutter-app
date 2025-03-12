import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/app/AppErrorScreen.dart';
import 'package:march_tales_app/app/ScreenWrapper.dart';
import 'package:march_tales_app/components/LoadingSplash.dart';
import 'package:march_tales_app/components/mixins/ScrollControllerProviderMixin.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/features/Track/loaders/loadRubricDetails.dart';
import 'package:march_tales_app/features/Track/types/Rubric.dart';
import 'package:march_tales_app/screens/views/RubricScreenView.dart';

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
    final int id = this._getRubricId();
    super.didChangeDependencies();
    this.dataFuture = loadRubricDetails(id);
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

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      title: 'Show rubric',
      child: FutureBuilder(
        future: this.dataFuture,
        builder: (context, snapshot) {
          if (snapshot.error != null) {
            return AppErrorScreen(error: snapshot.error);
          }
          if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
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
