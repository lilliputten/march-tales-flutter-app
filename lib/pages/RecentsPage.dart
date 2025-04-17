import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/components/mixins/ScrollControllerProviderMixin.dart';
import 'package:march_tales_app/screens/RecentsScreen.dart';

// import 'package:march_tales_app/components/data-driven/RecentsLoader.dart';

final logger = Logger();

class RecentsPage extends StatefulWidget {
  @override
  State<RecentsPage> createState() => RecentsPageState();
}

class RecentsPageState extends State<RecentsPage> with ScrollControllerProviderMixin {
  @override
  Widget build(BuildContext context) {
    return RecentsScreen(
      scrollController: this.getScrollController(),
    );
  }
}
