import 'dart:async';
import 'dart:convert';

import 'package:beggar_app/core/config/api_config.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient({String? baseUrl}) : baseUrl = baseUrl ?? ApiConfig.baseUrl;

  final String baseUrl;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String?> query = const {},
  }) async {
    final uri = _uri(path, query);
    return _sendWithRetry(() async {
      final response = await http
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(ApiConfig.receiveTimeout);
      return _decode(response);
    });
  }

  Future<List<dynamic>> getList(
    String path, {
    Map<String, String?> query = const {},
  }) async {
    final uri = _uri(path, query);
    return _sendWithRetry(() async {
      final response = await http
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(ApiConfig.receiveTimeout);
      return _decodeList(response);
    });
  }

  Future<Map<String, dynamic>> post(String path, {Object? body}) async {
    final uri = _uri(path, {});
    return _sendWithRetry(() async {
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: body == null ? null : jsonEncode(body),
          )
          .timeout(ApiConfig.receiveTimeout);
      return _decode(response);
    });
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

  Map<String, dynamic> _decode(http.Response response) {
    final raw = utf8.decode(response.bodyBytes);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = decoded['message'] as String? ?? 'API 요청에 실패했어요.';
      throw ApiException(response.statusCode, message);
    }
    return decoded;
  }

  List<dynamic> _decodeList(http.Response response) {
    final raw = utf8.decode(response.bodyBytes);
    final decoded = jsonDecode(raw);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = decoded is Map<String, dynamic>
          ? decoded['message'] as String? ?? 'API 요청에 실패했어요.'
          : 'API 요청에 실패했어요.';
      throw ApiException(response.statusCode, message);
    }
    return decoded as List<dynamic>;
  }

  Future<T> _sendWithRetry<T>(Future<T> Function() send) async {
    Object? lastError;
    for (var attempt = 0; attempt < ApiConfig.maxRetryCount; attempt++) {
      try {
        return await send();
      } catch (error) {
        lastError = error;
        if (!_shouldRetry(error) || attempt == ApiConfig.maxRetryCount - 1) {
          break;
        }
        await Future<void>.delayed(ApiConfig.retryDelay * (attempt + 1));
      }
    }
    throw _toUserFacingException(lastError);
  }

  bool _shouldRetry(Object error) {
    if (error is TimeoutException || error is http.ClientException) {
      return true;
    }
    if (error is ApiException) {
      return error.statusCode == 502 ||
          error.statusCode == 503 ||
          error.statusCode == 504;
    }
    return false;
  }

  Exception _toUserFacingException(Object? error) {
    if (error is ApiException) {
      return error;
    }
    if (error is TimeoutException) {
      return const ApiException(408, '응답이 늦어지고 있어. 잠시 후 다시 시도해줘.');
    }
    if (error is http.ClientException) {
      return const ApiException(0, '서버와 연결하지 못했어. 실행 주소를 확인해줘.');
    }
    if (error is Exception) {
      return error;
    }
    return const ApiException(0, 'API 요청에 실패했어요.');
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException(this.statusCode, this.message);

  @override
  String toString() => message;
}
