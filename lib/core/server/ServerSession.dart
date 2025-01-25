// import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;

final defaultHeaders = {
  'credentials': 'include',
  'content-language': 'en', // TODO: Use current locale language
  'accept': 'application/json',
  'content-type': 'application/json',
};

class _ServerSession {
  final JsonDecoder _decoder = const JsonDecoder();
  final JsonEncoder _encoder = const JsonEncoder();

  Map<String, String> headers = Map.from(defaultHeaders);
  Map<String, String> cookies = {};

  void _updateCookie(http.Response response) {
    String? allSetCookie = response.headers['set-cookie'];

    if (allSetCookie != null) {
      var setCookies = allSetCookie.split(',');

      for (var setCookie in setCookies) {
        var cookies = setCookie.split(';');

        for (var cookie in cookies) {
          _setCookie(cookie);
        }
      }

      headers['cookie'] = _generateCookieHeader();
    }
  }

  void _setCookie(String? rawCookie) {
    if (rawCookie != null &&
        rawCookie.isNotEmpty &&
        !rawCookie.startsWith(' ')) {
      var keyValue = rawCookie.split('=');
      if (keyValue.length == 2) {
        var key = keyValue[0].trim();
        var value = keyValue[1];

        // ignore keys that aren't cookies
        if (key == 'path' || key == 'expires') return;

        cookies[key] = value;
      }
    }
  }

  String _generateCookieHeader() {
    String cookie = '';

    for (var key in cookies.keys) {
      if (cookie.isNotEmpty) cookie += ';';
      cookie += '$key=${cookies[key]!}';
    }

    return cookie;
  }

  Future<dynamic> get(Uri uri) {
    return http
        .get(
      uri,
      headers: headers,
    )
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      _updateCookie(response);

      if (statusCode < 200 || statusCode > 400) {
        throw Exception('Error while fetching data');
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> post(Uri uri, {dynamic body, Encoding? encoding}) {
    return http
        .post(
      uri,
      body: _encoder.convert(body),
      headers: headers,
      encoding: encoding,
    )
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      _updateCookie(response);

      if (statusCode < 200 || statusCode > 400) {
        throw Exception('Error while fetching data');
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> put(Uri uri, {dynamic body, Encoding? encoding}) {
    return http
        .put(
      uri,
      body: _encoder.convert(body),
      headers: headers,
      encoding: encoding,
    )
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      _updateCookie(response);

      if (statusCode < 200 || statusCode > 400) {
        throw Exception('Error while fetching data');
      }
      return _decoder.convert(res);
    });
  }

  // Map<String, String> recentHeaders = {};
  // Future<Map> get(String url) async {
  //   http.Response response = await http.get(Uri.parse(url), headers: recentHeaders);
  //   updateCookie(response);
  //   return json.decode(response.body);
  // }
  // Future<Map> post(String url, dynamic data) async {
  //   http.Response response = await http.post(Uri.parse(url), body: data, headers: recentHeaders);
  //   updateCookie(response);
  //   return json.decode(response.body);
  // }
  // void updateCookie(http.Response response) {
  //   String? rawCookie = response.headers['set-cookie'];
  //   if (rawCookie != null) {
  //     int index = rawCookie.indexOf(';');
  //     recentHeaders['cookie'] =
  //         (index == -1) ? rawCookie : rawCookie.substring(0, index);
  //   }
  // }
}

final serverSession = _ServerSession();
