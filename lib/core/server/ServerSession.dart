import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import 'package:march_tales_app/supportedLocales.dart';

final defaultHeaders = {
  'credentials': 'include',
  'content-language': defaultLocale,
  'accept-language': defaultLocale,
  'accept': 'application/json',
  'content-type': 'application/json',
};

final logger = Logger();

class _ServerSession {
  final JsonDecoder _decoder = const JsonDecoder();
  final JsonEncoder _encoder = const JsonEncoder();

  String currentLocale = defaultLocale;

  Map<String, String> headers = Map.from(defaultHeaders);
  Map<String, String> cookies = {};

  updateLocale(String locale) {
    // Store language
    currentLocale = locale;
    // Update `django_language` cookie?
    cookies['django_language'] = locale;
    // Update header values
    headers['accept-language'] = locale;
    headers['content-language'] = locale;
    headers['cookie'] = _generateCookieHeader();
  }

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
        throw Exception('Error fetching data (get)');
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
        throw Exception('Error fetching data (post)');
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
        throw Exception('Error fetching data (put)');
      }
      return _decoder.convert(res);
    });
  }
}

final serverSession = _ServerSession();
