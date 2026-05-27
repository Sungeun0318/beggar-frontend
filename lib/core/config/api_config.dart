class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );

  static const String kakaoNativeAppKey = String.fromEnvironment(
    'KAKAO_NATIVE_APP_KEY',
    defaultValue: '',
  );

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
