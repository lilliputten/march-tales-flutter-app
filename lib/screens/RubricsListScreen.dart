import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/app/AppErrorScreen.dart';
import 'package:march_tales_app/app/ScreenWrapper.dart';
import 'package:march_tales_app/components/LoadingSplash.dart';
import 'package:march_tales_app/components/mixins/ScrollControllerProviderMixin.dart';
import 'package:march_tales_app/features/Track/loaders/LoadRubricsListResults.dart';
import 'package:march_tales_app/features/Track/loaders/loadRubricsList.dart';
import 'package:march_tales_app/screens/views/RubricsListScreenView.dart';

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
  late Future<LoadRubricsListResults> dataFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.dataFuture = loadRubricsList();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      title: 'Show rubrics list',
      child: FutureBuilder(
        future: this.dataFuture,
        builder: (context, snapshot) {
          if (snapshot.error != null) {
            return AppErrorScreen(error: snapshot.error);
          }
          if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
            final data = snapshot.data!;
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
