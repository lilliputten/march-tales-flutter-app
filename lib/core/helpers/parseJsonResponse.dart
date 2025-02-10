import 'dart:convert';

// import 'package:http/http.dart' as http;

parseJsonResponse(String? body) {
  Map<String, dynamic>? decoded;
  if (body != null && body.isNotEmpty && body.startsWith('{')) {
    try {
      decoded = jsonDecode(body) as Map<String, dynamic>;
    } catch (e) {
      // NOOP
    }
  }
  return decoded;
}
