import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/shared/states/MyAppState.dart';

class QuoteButtons extends StatelessWidget {
  const QuoteButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            print('Load next quote button pressed');
            appState.reloadQuote();
          },
          icon: Icon(Icons.refresh),
          label: Text('Load next'),
        ),
      ],
    );
  }
}
