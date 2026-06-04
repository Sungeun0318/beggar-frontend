import 'package:beggar_app/data/api/api_client.dart';
import 'package:beggar_app/data/auth/kakao_auth_service.dart';
import 'package:beggar_app/data/auth/token_storage.dart';
import 'package:beggar_app/data/models/user.dart';

class AuthRepository {
  AuthRepository({
    ApiClient? apiClient,
    TokenStorage? tokenStorage,
    KakaoAuthService? kakaoAuthService,
  }) : _apiClient = apiClient ?? ApiClient(),
       _tokenStorage = tokenStorage ?? TokenStorage(),
       _kakaoAuthService = kakaoAuthService ?? KakaoAuthService();

  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;
  final KakaoAuthService _kakaoAuthService;

  Future<User> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final json = await _apiClient.post(
      '/auth/login',
      body: {'email': email, 'password': password},
    );
    final data = json['data'] as Map<String, dynamic>;
    await _tokenStorage.saveTokens(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String?,
    );
    return User(
      no: (data['userNo'] as num).toInt(),
      name: data['userName'] as String,
      email: email,
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String nickname,
    required String ageRange,
    int? gender,
  }) async {
    await _apiClient.post(
      '/users/signup',
      body: {
        'email': email,
        'password': password,
        'userName': nickname,
        'ageRange': ageRange,
        'gender': gender,
      },
    );
  }

  Future<User> signInWithKakao() async {
    final kakaoAccessToken = await _kakaoAuthService.signInWithKakao();
    final json = await _apiClient.post(
      '/auth/kakao',
      body: {'kakaoAccessToken': kakaoAccessToken},
    );
    final data = json['data'] as Map<String, dynamic>;
    await _tokenStorage.saveTokens(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String?,
    );
    return User(
      no: (data['userNo'] as num).toInt(),
      name: data['userName'] as String,
      email: '',
    );
  }

  Future<void> signOut() async {
    await _tokenStorage.clear();
    await _kakaoAuthService.signOut();
  }

  Future<User?> currentUser() async {
    final accessToken = await _tokenStorage.readAccessToken();
    if (accessToken == null) {
      return null;
    }
    return null;
  }
}
