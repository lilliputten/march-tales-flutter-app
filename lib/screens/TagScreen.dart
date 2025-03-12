import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/app/AppErrorScreen.dart';
import 'package:march_tales_app/app/ScreenWrapper.dart';
import 'package:march_tales_app/components/LoadingSplash.dart';
import 'package:march_tales_app/components/mixins/ScrollControllerProviderMixin.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/features/Track/loaders/loadTagDetails.dart';
import 'package:march_tales_app/features/Track/types/Tag.dart';
import 'package:march_tales_app/screens/views/TagScreenView.dart';

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
    final int id = this._getTagId();
    super.didChangeDependencies();
    this.dataFuture = loadTagDetails(id);
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

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      title: 'Show tag',
      child: FutureBuilder(
        future: this.dataFuture,
        builder: (context, snapshot) {
          if (snapshot.error != null) {
            return AppErrorScreen(error: snapshot.error);
          }
          if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
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
