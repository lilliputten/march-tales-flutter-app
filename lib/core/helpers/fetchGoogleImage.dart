import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/apis.dart' as apis;

Future<String> fetchGoogleImage(String search) async {
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
      final item = items[0];
      final link = item['link'].toString();
      print('Found image: $link');
      return link;
    } else {
      // throw Exception("Failed to load an image ($urlString)");
      final reason = decoded!['statusMessage'] ?? response.reasonPhrase ?? 'Unknown error';
      final errMsg = "Error returned (${response.statusCode}): $reason";
      throw Exception(errMsg);
    }
  } catch (error) {
    var msg = "Failed to fetch an image url ($urlString): $error";
    print("ERROR: $msg");
    throw FormatException(msg);
  }
}
