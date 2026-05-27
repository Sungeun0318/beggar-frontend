import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/assets.dart';
import 'package:beggar_app/core/utils/decorations.dart';
import 'package:beggar_app/shared/widgets/figma_frame.dart';
import 'package:beggar_app/shared/widgets/info_card.dart';
import 'package:beggar_app/shared/widgets/primary_button.dart';

class BudgetResultScreen extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onNext;

  const BudgetResultScreen({
    super.key,
    required this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return FigmaFrame(
      child: Stack(
        children: [
          ScreenHeader(title: '예산 결정 완료', onBack: onBack),
          Positioned(
            top: 112,
            left: 24,
            right: 24,
            child: SizedBox(
              height: 145,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Positioned(
                    left: 85,
                    top: 2,
                    child: Icon(Icons.star, size: 16, color: Color(0xFFE9C867)),
                  ),
                  const Positioned(
                    left: 90,
                    bottom: 22,
                    child: Icon(
                      Icons.auto_awesome,
                      size: 20,
                      color: Color(0xFFF0A282),
                    ),
                  ),
                  const Positioned(
                    right: 60,
                    top: 55,
                    child: Icon(Icons.star, size: 15, color: Color(0xFFB994F2)),
                  ),
                  Image.asset(
                    Assets.mascotCelebration,
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 274,
            left: 24,
            right: 24,
            child: Container(
              height: 332,
              padding: const EdgeInsets.fromLTRB(28, 28, 28, 28),
              decoration: softBox(radius: 28, shadow: true),
              child: Column(
                children: [
                  const Text(
                    '4명이 모두 예산을 입력했어요!',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.muted,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '1인 기준 최저 예산 ',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.sub,
                            ),
                          ),
                          TextSpan(
                            text: '15,000원',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF5A4F43),
                            ),
                          ),
                        ],
                      ),
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    '오늘의 총예산',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.lightSub,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '60,000',
                          style: TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -1.8,
                          ),
                        ),
                        TextSpan(
                          text: ' 원',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Divider(color: AppColors.muted),
                  const SizedBox(height: 16),
                  Container(
                    height: 49,
                    decoration: BoxDecoration(
                      color: AppColors.bg,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.muted),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.groups_outlined,
                            size: 16,
                            color: AppColors.brown,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '4명의 참여자 × 최저 예산 15,000원',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.sub,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            left: 24,
            right: 24,
            top: 632,
            child: InfoCard(
              icon: Icons.lock_outline,
              title: '개인 예산은 익명으로 보호돼요',
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 120,
            child: PrimaryButton(label: '추천 보기', onTap: onNext),
          ),
        ],
      ),
    );
  }
}
