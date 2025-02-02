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
    this.currentLocale = locale;
    // Update `django_language` cookie?
    this.cookies['django_language'] = locale;
    // Update header values
    this.headers['accept-language'] = locale;
    this.headers['content-language'] = locale;
    // this.headers['cookie'] = _generateCookieHeader();
  }

  void _updateCookie(http.Response response) {
    String? allSetCookie = response.headers['set-cookie'];

    if (allSetCookie != null) {
      var setCookies = allSetCookie.split(',');

      for (var setCookie in setCookies) {
        var cookies = setCookie.split(';');

        for (var cookie in cookies) {
          this._setCookie(cookie);
        }
      }

      // headers['cookie'] = _generateCookieHeader();
    }
  }

  void _setCookie(String? rawCookie) {
    if (rawCookie != null &&
        rawCookie.isNotEmpty &&
        !rawCookie.startsWith(' ')) {
      final keyValue = rawCookie.split('=');
      if (keyValue.length == 2) {
        final key = keyValue[0].trim();
        final value = keyValue[1];
        // ignore keys that aren't cookies
        if (key == 'path' || key == 'expires') return;
        this.cookies[key] = value;
      }
    }
  }

  _getHeaders() {
    final headers = Map<String, String>.from(this.headers);
    headers['cookie'] = this._generateCookieHeader();
    if (this.cookies['csrftoken'] != null &&
        this.cookies['csrftoken']!.isNotEmpty) {
      headers['X-CSRFToken'] = this.cookies['csrftoken']!;
    }
    return headers;
  }

  String _generateCookieHeader() {
    String cookie = '';

    for (var key in this.cookies.keys) {
      if (cookie.isNotEmpty) cookie += ';';
      cookie += '$key=${cookies[key]!}';
    }

    return cookie;
  }

  Future<dynamic> get(Uri uri) {
    return http
        .get(
      uri,
      headers: this._getHeaders(),
    )
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      this._updateCookie(response);

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
      headers: this._getHeaders(),
      encoding: encoding,
    )
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      this._updateCookie(response);

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
      headers: this._getHeaders(),
      encoding: encoding,
    )
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      this._updateCookie(response);

      if (statusCode < 200 || statusCode > 400) {
        throw Exception('Error fetching data (put)');
      }
      return _decoder.convert(res);
    });
  }
}

final serverSession = _ServerSession();
