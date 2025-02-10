import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:march_tales_app/features/Quote/types/Quote.dart';

Future<Quote> fetchQuote() async {
  final response = await http.get(Uri.parse('https://api.quotable.io/random'));

  Map<String, dynamic>? decoded;

  // Try to decode json response
  if (response.body.isNotEmpty && response.body.startsWith('{')) {
    try {
      decoded = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      // NOOP
    }
  }

  if (response.statusCode == 200 && decoded != null) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    // var decoded = jsonDecode(response.body) as Map<String, dynamic>;
    var quote = Quote.fromJson(decoded);
    return quote;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    final reason =
        decoded!['statusMessage'] ?? response.reasonPhrase ?? 'Unknown error';
    final errMsg = "Failed to load quote (${response.statusCode}): $reason";
    print("ERROR: $errMsg");
    throw Exception(errMsg);
  }
}
