import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    const definedUrl = String.fromEnvironment('API_BASE_URL');
    if (definedUrl.isNotEmpty) {
      return definedUrl;
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8080';
    }
    return 'http://127.0.0.1:8080';
  }

  static const String kakaoNativeAppKey = String.fromEnvironment(
    'KAKAO_NATIVE_APP_KEY',
    defaultValue: '',
  );

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const int maxRetryCount = 3;
  static const Duration retryDelay = Duration(milliseconds: 700);
}
