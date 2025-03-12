import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/app/AppErrorScreen.dart';
import 'package:march_tales_app/app/ScreenWrapper.dart';
import 'package:march_tales_app/components/LoadingSplash.dart';
import 'package:march_tales_app/components/mixins/ScrollControllerProviderMixin.dart';
import 'package:march_tales_app/features/Track/loaders/LoadTagsListResults.dart';
import 'package:march_tales_app/features/Track/loaders/loadTagsList.dart';
import 'package:march_tales_app/screens/views/TagsListScreenView.dart';

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
  late Future<LoadTagsListResults> dataFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.dataFuture = loadTagsList();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      title: 'Show tags list',
      child: FutureBuilder(
        future: this.dataFuture,
        builder: (context, snapshot) {
          if (snapshot.error != null) {
            return AppErrorScreen(error: snapshot.error);
          }
          if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
            final data = snapshot.data!;
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
