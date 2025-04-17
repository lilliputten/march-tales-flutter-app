import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/components/data-driven/RecentsLoader.dart';

final logger = Logger();

class RecentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RecentsLoader(),
      ],
    );
  }
}
