import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/apis.dart' as apis;

// See https://developers.google.com/custom-search/v1/overview:
//
// Custom Search JSON API provides 100 search queries per day for free. If you
// need more, you may sign up for billing in the API Console. Additional
// requests cost $5 per 1000 queries, up to 10k queries per day.

Future<List<String>> fetchGoogleImages(String search) async {
  // // DEBUG: Return sample data
  // return Future<List<String>>.value([
  //   'xxx',
  //   'https://cdn-icons-png.flaticon.com/512/9908/9908191.png',
  // ]);
  print("Trying to get an image for the search: $search...");
  final urlString = apis.googleImageUrlTemplate
      .replaceAll('{apiKey}', apis.googleApiKey)
      .replaceAll('{cseId}', apis.googleCseId)
      .replaceAll('{search}', search);
  print("Trying to fetch an image with url: $urlString...");
  try {
    final urlObject = Uri.parse(urlString);
    final response = await http.get(urlObject);

    Map<String, dynamic>? decoded;

    // Try to decode json response
    if (response.body.isNotEmpty && response.body.startsWith('{')) {
      try {
        decoded = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (e) {
        // NOOP
      }
    }

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final items = decoded['items'] as List;
      final links = items.map((item) {
        return item['link'].toString();
      }).toList();
      print('[fetchGoogleImages] Found image links: $links');
      return links;
    } else {
      // throw Exception("Failed to load an image ($urlString)");
      final reason =
          decoded!['statusMessage'] ?? response.reasonPhrase ?? 'Unknown error';
      final errMsg = "Error returned (${response.statusCode}): $reason";
      throw Exception(errMsg);
    }
  } catch (error) {
    //  with url ($urlString)
    var msg = "Failed to fetch an images data: $error";
    print("ERROR: $msg (image url is: $urlString)");
    throw FormatException(msg);
  }
}
