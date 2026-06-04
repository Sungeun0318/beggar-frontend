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

  static Future<String> _value(String key) async {
    final definedValue = String.fromEnvironment(key);
    if (definedValue.isNotEmpty) {
      return definedValue;
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
