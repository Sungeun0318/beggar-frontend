import 'package:beggar_app/data/models/user.dart';

// TODO(backend): 카카오 토큰 → Spring `/auth/kakao` → JWT 발급/저장.
// signup/login (이메일+비번)도 같은 위치에서 처리.
abstract class AuthRepository {
  Future<User> signInWithEmail({required String email, required String password});
  Future<User> signInWithKakao();
  Future<User> signUp({
    required String email,
    required String password,
    required String nickname,
  });
  Future<void> signOut();
  Future<User?> currentUser();
}
