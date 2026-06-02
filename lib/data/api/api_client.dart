import 'dart:convert';
import 'dart:io';

import 'package:beggar_app/core/config/api_config.dart';

class ApiClient {
  ApiClient({String? baseUrl}) : baseUrl = baseUrl ?? ApiConfig.baseUrl;

  final String baseUrl;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String?> query = const {},
  }) async {
    final uri = _uri(path, query);
    final client = HttpClient()..connectionTimeout = ApiConfig.connectTimeout;
    try {
      final request = await client.getUrl(uri);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.headers.set(HttpHeaders.connectionHeader, 'close');
      final response = await request.close().timeout(ApiConfig.receiveTimeout);
      return _decode(response);
    } finally {
      client.close(force: true);
    }
  }

  Future<List<dynamic>> getList(
    String path, {
    Map<String, String?> query = const {},
  }) async {
    final uri = _uri(path, query);
    final client = HttpClient()..connectionTimeout = ApiConfig.connectTimeout;
    try {
      final request = await client.getUrl(uri);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.headers.set(HttpHeaders.connectionHeader, 'close');
      final response = await request.close().timeout(ApiConfig.receiveTimeout);
      return _decodeList(response);
    } finally {
      client.close(force: true);
    }
  }

// 앱이 '10.0.2.2:38326' 으로 접속
  Future<Map<String, dynamic>> post(String path, {Object? body}) async {
    final uri = _uri(path, {});
    final client = HttpClient()..connectionTimeout = ApiConfig.connectTimeout;
    try {
      final request = await client.postUrl(uri);
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      if (body != null) {
        request.add(utf8.encode(jsonEncode(body)));
      }
      final response = await request.close().timeout(ApiConfig.receiveTimeout);
      return _decode(response);
    } finally {
      client.close(force: true);
    }
  }

  Uri _uri(String path, Map<String, String?> query) {
    final base = Uri.parse(baseUrl);
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    final basePath = base.path.endsWith('/') ? base.path : '${base.path}/';
    final queryParameters = <String, String>{};
    query.forEach((key, value) {
      if (value != null && value.isNotEmpty) queryParameters[key] = value;
    });
    return base.replace(
      path: '$basePath$cleanPath',
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );
  }

  Future<Map<String, dynamic>> _decode(HttpClientResponse response) async {
    final raw = await utf8.decodeStream(response);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = decoded['message'] as String? ?? 'API 요청에 실패했어요.';
      throw ApiException(response.statusCode, message);
    }
    return decoded;
  }

  Future<List<dynamic>> _decodeList(HttpClientResponse response) async {
    final raw = await utf8.decodeStream(response);
    final decoded = jsonDecode(raw);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = decoded is Map<String, dynamic>
          ? decoded['message'] as String? ?? 'API 요청에 실패했어요.'
          : 'API 요청에 실패했어요.';
      throw ApiException(response.statusCode, message);
    }
    return decoded as List<dynamic>;
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException(this.statusCode, this.message);

  @override
  String toString() => message;
}
