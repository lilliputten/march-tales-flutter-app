import 'package:flutter/material.dart';

import 'package:march_tales_app/features/Quote/types/Quote.dart';

class QuoteText extends StatelessWidget {
  const QuoteText({
    super.key,
    required this.quote,
  });

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    // var appState = context.watch<AppState>();
    var theme = Theme.of(context);
    var style = theme.textTheme.bodyMedium!; // .copyWith();
    return MergeSemantics(
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        // direction: Axis.vertical,
        children: [
          Text(
            quote.content,
            style: style.copyWith(
              // fontWeight: FontWeight.w200,
              fontSize: 18,
            ),
          ),
          Text(
            quote.author,
            style: style.copyWith(
              // fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          )
        ],
      ),
    );
  }
}
