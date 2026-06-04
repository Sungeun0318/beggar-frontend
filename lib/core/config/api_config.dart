import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

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

  static String get wsUrl {
    final base = baseUrl;
    if (base.startsWith('https://')) {
      return base.replaceFirst('https://', 'wss://') + '/ws-stomp';
    }
    return base.replaceFirst('http://', 'ws://') + '/ws-stomp';
  }

  static Future<String> kakaoNativeAppKey() {
    return _value('KAKAO_NATIVE_APP_KEY');
  }

  // 🌟 이 부분을 웹 컴파일러가 안 터지게 정석대로 수정했습니다!
  static Future<String> _value(String key) async {
    if (key == 'KAKAO_NATIVE_APP_KEY') {
      // 왼쪽에만 const를 붙여서 중복 경고(Unnecessary const)를 완벽히 피했습니다!
      const definedValue = String.fromEnvironment('KAKAO_NATIVE_APP_KEY');
      if (definedValue.isNotEmpty) return definedValue;
    } else if (key == 'API_BASE_URL') {
      const definedValue = String.fromEnvironment('API_BASE_URL');
      if (definedValue.isNotEmpty) return definedValue;
    }

    return _envValue(key);
  }

  static Future<String> _envValue(String key) async {
    try {
      final env = await rootBundle.loadString('.env');
      for (final line in env.split('\n')) {
        final trimmed = line.trim();
        if (trimmed.isEmpty || trimmed.startsWith('#')) {
          continue;
        }
        final separatorIndex = trimmed.indexOf('=');
        if (separatorIndex <= 0) {
          continue;
        }
        final name = trimmed.substring(0, separatorIndex).trim();
        if (name == key) {
          return trimmed.substring(separatorIndex + 1).trim();
        }
      }
    } catch (_) {
      return '';
    }
    return '';
  }

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const int maxRetryCount = 3;
  static const Duration retryDelay = Duration(milliseconds: 700);
}