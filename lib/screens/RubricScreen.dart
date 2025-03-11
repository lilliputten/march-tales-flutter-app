import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/app/AppErrorScreen.dart';
import 'package:march_tales_app/app/ScreenWrapper.dart';
import 'package:march_tales_app/components/LoadingSplash.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/features/Track/loaders/loadRubricDetails.dart';
import 'package:march_tales_app/features/Track/types/Rubric.dart';
import 'package:march_tales_app/features/Track/widgets/RubricDetails.dart';
import 'package:march_tales_app/shared/states/AppState.dart';

// import 'package:march_tales_app/features/Track/widgets/RubricDetails.dart';

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

class RubricScreenState extends State<RubricScreen> {
  late AppState _appState;
  late Future<Rubric> dataFuture;
  final ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    this._appState = context.read<AppState>();
    Future.delayed(Duration.zero, () {
      this._appState.addScrollController(this.scrollController);
    });
  }

  @override
  void dispose() {
    Future.delayed(Duration.zero, () {
      this._appState.removeScrollController(this.scrollController);
    });
    super.dispose();
  }

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
            return RubricItemFull(rubric: rubric, scrollController: scrollController);
          } else {
            return LoadingSplash();
          }
        },
      ),
    );
  }
}

class RubricItemFull extends StatelessWidget {
  const RubricItemFull({
    super.key,
    required this.rubric,
    required this.scrollController,
  });

  final Rubric rubric;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            restorationId: 'RubricItemFull-${this.rubric.id}',
            controller: this.scrollController,
            child: Padding(
              padding: const EdgeInsets.all(10),
              // child: Text(this.rubric.text),
              child: RubricDetails(rubric: this.rubric, fullView: true),
            ),
          ),
        ),
      ],
    );
  }
}
