import 'package:flutter/material.dart';

import 'package:march_tales_app/features/Quote/widgets/QuoteBuilder.dart';
import 'package:march_tales_app/features/Quote/widgets/QuoteButtons.dart';

// @see https://docs.flutter.dev/cookbook/networking/fetch-data

class QuotePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          spacing: 20.0,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QuoteBuilder(),
            QuoteButtons(),
          ],
        ),
      ),
    );
  }
}
