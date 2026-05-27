import 'package:beggar_app/core/config/api_config.dart';

// TODO(backend): Spring 백엔드 연동 시 HTTP 클라이언트 구현.
// - 패키지: `dio` 또는 `http` 중 결정 후 pubspec에 추가
// - 인터셉터: TokenStorage 에서 JWT 읽어 Authorization 헤더에 주입
// - 401 응답 시 토큰 재발급 또는 로그아웃 처리
class ApiClient {
  ApiClient({String? baseUrl}) : baseUrl = baseUrl ?? ApiConfig.baseUrl;

  final String baseUrl;

  Future<Map<String, dynamic>> get(String path) {
    throw UnimplementedError('ApiClient.get — 백엔드 연동 후 구현');
  }

  Future<Map<String, dynamic>> post(String path, {Object? body}) {
    throw UnimplementedError('ApiClient.post — 백엔드 연동 후 구현');
  }
}
