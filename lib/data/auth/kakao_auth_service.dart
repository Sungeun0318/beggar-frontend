import 'package:flutter/foundation.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoAuthService {
  Future<String> signInWithKakao() async {
    OAuthToken token;
    if (!kIsWeb && await isKakaoTalkInstalled()) {
      try {
        debugPrint('Kakao login: try KakaoTalk');
        token = await UserApi.instance.loginWithKakaoTalk();
      } catch (error) {
        debugPrint('KakaoTalk login failed, fallback to account login: $error');
        token = await UserApi.instance.loginWithKakaoAccount();
      }
    } else {
      debugPrint('Kakao login: try KakaoAccount');
      token = await UserApi.instance.loginWithKakaoAccount();
    }
    debugPrint('Kakao login: OAuth token issued');
    return token.accessToken;
  }

  Future<void> signOut() => UserApi.instance.logout();
}
