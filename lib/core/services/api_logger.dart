import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// HTTP client for Supabase that prints every request and its response to
/// the debug console. Does nothing extra in release builds.
///
/// Passwords and auth tokens are masked so they never reach the logs.
class ApiLoggingClient extends http.BaseClient {
  ApiLoggingClient([http.Client? inner]) : _inner = inner ?? http.Client();

  final http.Client _inner;
  static const _maxBodyLength = 2000;
  static const _secretKeys = {
    'password',
    'access_token',
    'refresh_token',
    'provider_token',
    'provider_refresh_token',
    'code_verifier',
    'token',
  };

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (!kDebugMode) return _inner.send(request);

    final watch = Stopwatch()..start();
    final label = '${request.method} ${_shortUrl(request.url)}';
    final requestBody = request is http.Request && request.body.isNotEmpty
        ? _format(request.body)
        : null;
    debugPrint('[API] --> $label'
        '${requestBody == null ? '' : '\n[API]     body: $requestBody'}');

    final http.StreamedResponse response;
    try {
      response = await _inner.send(request);
    } catch (error) {
      debugPrint('[API] <-- $label FAILED after ${watch.elapsedMilliseconds}ms: $error');
      rethrow;
    }

    final bytes = await response.stream.toBytes();
    final contentType = response.headers['content-type'] ?? '';
    final isText = contentType.contains('json') || contentType.contains('text');
    final body = bytes.isEmpty
        ? '(empty)'
        : isText
            ? _format(utf8.decode(bytes, allowMalformed: true))
            : '(${bytes.length} bytes, $contentType)';
    final status = response.statusCode >= 400 ? 'ERROR ${response.statusCode}' : '${response.statusCode}';
    debugPrint('[API] <-- $status $label (${watch.elapsedMilliseconds}ms)\n[API]     $body');

    return http.StreamedResponse(
      http.ByteStream.fromBytes(bytes),
      response.statusCode,
      contentLength: bytes.length,
      request: response.request,
      headers: response.headers,
      isRedirect: response.isRedirect,
      persistentConnection: response.persistentConnection,
      reasonPhrase: response.reasonPhrase,
    );
  }

  @override
  void close() => _inner.close();

  static String _shortUrl(Uri url) {
    final query = Uri.decodeQueryComponent(url.query);
    return query.isEmpty ? url.path : '${url.path}?$query';
  }

  static String _format(String raw) {
    String text;
    try {
      text = jsonEncode(_mask(jsonDecode(raw)));
    } catch (_) {
      text = raw;
    }
    if (text.length <= _maxBodyLength) return text;
    return '${text.substring(0, _maxBodyLength)}… (${text.length} chars)';
  }

  static Object? _mask(Object? value) {
    if (value is Map) {
      return value.map((key, v) => MapEntry(
            key,
            _secretKeys.contains(key) ? '***' : _mask(v),
          ));
    }
    if (value is List) return value.map(_mask).toList();
    return value;
  }
}
