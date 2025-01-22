import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/shared/states/MyAppState.dart';
import 'package:march_tales_app/features/Quote/types/Quote.dart';
import 'package:march_tales_app/features/Quote/widgets/QuoteText.dart';
import 'package:march_tales_app/features/Quote/widgets/QuoteImage.dart';

class QuoteBuilder extends StatelessWidget {
  const QuoteBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return FutureBuilder<Quote>(
      future: appState.ensureQuote(),
      // @see https://www.dhiwise.com/post/how-to-resolve-flutter-setstate-called-during-build-issue
      builder: (BuildContext context, AsyncSnapshot<Quote> snapshot) {
        if (snapshot.hasData) {
          var quote = snapshot.data!;
          return Column(
            spacing: 20.0,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QuoteImage(quote: quote),
              QuoteText(quote: quote),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        // By default, show a loading spinner.
        return const CircularProgressIndicator(strokeWidth: 2);
      },
    );
  }
}
