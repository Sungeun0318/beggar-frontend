// TODO(auth): 카카오 로그인 SDK 연동.
// - 패키지: `kakao_flutter_sdk_user` pubspec 추가
// - main()에서 KakaoSdk.init(nativeAppKey: ApiConfig.kakaoNativeAppKey)
// - login(): isKakaoTalkInstalled → loginWithKakaoTalk / loginWithKakaoAccount
// - 받은 OAuth 토큰을 Spring 백엔드 `/auth/kakao` 로 전송 → 자체 JWT 발급
class KakaoAuthService {
  Future<String> signInWithKakao() {
    throw UnimplementedError('KakaoAuthService.signInWithKakao — SDK 연동 후 구현');
  }

  Future<void> signOut() {
    throw UnimplementedError('KakaoAuthService.signOut — SDK 연동 후 구현');
  }
}
