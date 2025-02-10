import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';
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
    // Update `django_language` cookie
    this.cookies['django_language'] = locale;
    // Update header values
    this.headers['accept-language'] = locale;
    this.headers['content-language'] = locale;
    // this.headers['cookie'] = _generateCookieHeader();
  }

  updateCSRFToken(String token) {
    this.cookies['csrftoken'] = token;
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
    if (!AppConfig.LOCAL) {
      headers['referer'] = AppConfig.WEB_SITE_HOST;
    }
    return headers;
  }

  String _generateCookieHeader() {
    String cookie = '';

    for (var key in this.cookies.keys) {
      if (cookie.isNotEmpty) {
        cookie += ';';
      }
      cookie += '$key=${cookies[key]!}';
    }

    return cookie;
  }

  Future<dynamic> get(Uri uri) {
    final requestHeaders = this._getHeaders();
    // logger.t('[ServerSession] GET starting uri=${uri} headers=${requestHeaders}');
    return http
        .get(
      uri,
      headers: requestHeaders,
    )
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      // logger.t('[ServerSession:get] response uri=${uri} cookie=${response.headers["set-cookie"]} headers=${response.headers} requestHeaders=${requestHeaders}');
      dynamic data = {};
      try {
        data = _decoder.convert(res);
      } catch (_) {}

      this._updateCookie(response);

      if (statusCode < 200 || statusCode > 400) {
        String reason = response.reasonPhrase ?? 'Unknown error';
        if (data != null && data['detail'] != null) {
          reason = data['detail'].toString();
        }
        final message = 'GET error ${statusCode}: ${reason}';
        logger.e(
            '[ServerSession:get] ${message}, url: ${uri} requestHeaders: ${requestHeaders}');
        debugger();
        throw Exception(message);
      }

      return data;
    });
  }

  Future<dynamic> post(Uri uri, {dynamic body, Encoding? encoding}) {
    final requestHeaders = this._getHeaders();
    // logger.t('[ServerSession] POST starting uri=${uri} headers=${requestHeaders}');
    return http
        .post(
      uri,
      body: _encoder.convert(body),
      headers: requestHeaders,
      encoding: encoding,
    )
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      dynamic data = {};
      try {
        data = _decoder.convert(res);
      } catch (_) {}

      this._updateCookie(response);

      if (statusCode < 200 || statusCode > 400) {
        String reason = response.reasonPhrase ?? 'Unknown error';
        if (data != null && data['detail'] != null) {
          reason = data['detail'].toString();
        }
        final message = 'POST error ${statusCode}: ${reason}';
        logger.e(
            '[ServerSession] ${message}, url: ${uri} body: ${body} requestHeaders: ${requestHeaders}');
        debugger();
        throw Exception(message);
      }

      return data;
    });
  }

  Future<dynamic> put(Uri uri, {dynamic body, Encoding? encoding}) {
    final requestHeaders = this._getHeaders();
    // logger.t('[ServerSession] PUT starting uri=${uri} headers=${requestHeaders}');
    return http
        .put(
      uri,
      body: _encoder.convert(body),
      headers: requestHeaders,
      encoding: encoding,
    )
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      dynamic data = {};
      try {
        data = _decoder.convert(res);
      } catch (_) {}

      this._updateCookie(response);

      if (statusCode < 200 || statusCode > 400) {
        String reason = response.reasonPhrase ?? 'Unknown error';
        if (data != null && data['detail'] != null) {
          reason = data['detail'].toString();
        }
        final message = 'PUT error ${statusCode}: ${reason}';
        logger.e(
            '[ServerSession] ${message}, url: ${uri} body: ${body} requestHeaders: ${requestHeaders}');
        debugger();
        throw Exception(message);
      }

      return data;
    });
  }
}

final serverSession = _ServerSession();
