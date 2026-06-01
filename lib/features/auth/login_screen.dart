import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/app_radius.dart';
import 'package:beggar_app/core/theme/assets.dart';
import 'package:beggar_app/core/utils/decorations.dart';
import 'package:beggar_app/data/mock/mock_db.dart';
import 'package:beggar_app/shared/widgets/figma_frame.dart';
import 'package:beggar_app/shared/widgets/input_like.dart';
import 'package:beggar_app/shared/widgets/primary_button.dart';

class LoginScreen extends StatelessWidget {
  final VoidCallback onLogin;
  final VoidCallback onSignup;

  const LoginScreen({super.key, required this.onLogin, required this.onSignup});

  @override
  Widget build(BuildContext context) {
    return FigmaFrame(
      child: Stack(
        children: [
          Positioned(
            top: 104,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    Assets.logo,
                    width: 104,
                    height: 104,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  '거지 우정 수호대',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '친구의 자존심을 지키는 익명 예산 조율',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: AppColors.sub,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 34),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: softBox(radius: AppRadius.card),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '일반 로그인',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      InputLike(
                        label: MockDb.currentUser.email,
                        icon: Icons.mail_outline,
                      ),
                      const SizedBox(height: 10),
                      const InputLike(label: '비밀번호', icon: Icons.lock_outline),
                      const SizedBox(height: 12),
                      PrimaryButton(label: '로그인', onTap: onLogin),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: Column(
              children: [
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.kakaoYellow,
                    borderRadius: BorderRadius.circular(AppRadius.card),
                  ),
                  child: GestureDetector(
                    onTap: onLogin,
                    child: const Center(
                      child: Text(
                        '카카오로 시작하기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2C241B),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextButton(
                  onPressed: onSignup,
                  child: const Text(
                    '아직 계정이 없나요? 회원가입',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.sub,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
