import 'package:flutter/material.dart';

import 'package:beggar_app/shared/widgets/app_header.dart';
import 'package:beggar_app/shared/widgets/figma_frame.dart';
import 'package:beggar_app/shared/widgets/info_card.dart';
import 'package:beggar_app/shared/widgets/input_like.dart';
import 'package:beggar_app/shared/widgets/primary_button.dart';
import 'package:beggar_app/shared/widgets/section_title.dart';

class SignupScreen extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onComplete;

  const SignupScreen({
    super.key,
    required this.onBack,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return FigmaFrame(
      child: Stack(
        children: [
          AppHeader.titled(title: '회원가입', onBack: onBack),
          Positioned(
            top: 128,
            left: 24,
            right: 24,
            bottom: 102,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '처음 오셨나요?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.7,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '프로토타입에서는 DB 샘플 계정으로 가입 흐름만 확인합니다.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Color(0xFF8C7E6A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 30),
                  SectionTitle('기본 정보'),
                  SizedBox(height: 13),
                  InputLike(label: '닉네임', icon: Icons.person_outline),
                  SizedBox(height: 12),
                  InputLike(label: '이메일', icon: Icons.mail_outline),
                  SizedBox(height: 12),
                  InputLike(label: '비밀번호', icon: Icons.lock_outline),
                  SizedBox(height: 12),
                  InputLike(label: '성별', icon: Icons.wc_outlined),
                  SizedBox(height: 12),
                  InputLike(label: '나이', icon: Icons.cake_outlined),
                  SizedBox(height: 24),
                  InfoCard(
                    icon: Icons.verified_user_outlined,
                    title: '예산 정보는 익명으로 보호돼요',
                    body: '성별과 나이는 추천 품질 개선에만 사용하고\n개인 예산은 다른 사람에게 공개하지 않아요.',
                  ),
                  SizedBox(height: 18),
                ],
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: PrimaryButton(label: '회원가입 완료', onTap: onComplete),
          ),
        ],
      ),
    );
  }
}
