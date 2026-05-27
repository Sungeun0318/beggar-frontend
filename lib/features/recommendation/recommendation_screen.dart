import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/assets.dart';
import 'package:beggar_app/core/utils/decorations.dart';
import 'package:beggar_app/shared/widgets/figma_frame.dart';
import 'package:beggar_app/shared/widgets/primary_button.dart';
import 'package:beggar_app/shared/widgets/recommendation_card.dart';
import 'package:beggar_app/shared/widgets/summary_row.dart';

class RecommendationScreen extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onDone;

  const RecommendationScreen({
    super.key,
    required this.onBack,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return FigmaFrame(
      height: 994,
      child: Stack(
        children: [
          ScreenHeader(title: '예산에 맞는 추천', onBack: onBack),
          Positioned(
            top: 122,
            left: 24,
            right: 24,
            child: Column(
              children: const [
                SummaryRow(
                  icon: Icons.location_on_outlined,
                  label: '명학역 1번 출구 근처',
                  trailing: '변경',
                  bg: AppColors.accentBg,
                ),
                SizedBox(height: 10),
                SummaryRow(
                  icon: Icons.account_balance_wallet_outlined,
                  label: '총예산 60,000원 이내 추천',
                  bg: Color(0xFFF4F6FF),
                ),
                SizedBox(height: 22),
                RecommendationCard(
                  image: Assets.recoFood,
                  tag: '식사',
                  title: '정성 한식 세트',
                  walk: '도보 5분',
                  rating: '★ 4.6 (128)',
                  amount: '총 38,000원',
                  tagBg: Color(0xFFFFEADD),
                  tagColor: AppColors.danger,
                ),
                SizedBox(height: 14),
                RecommendationCard(
                  image: Assets.recoCafe,
                  tag: '카페',
                  title: '따뜻한 하루 카페',
                  walk: '도보 7분',
                  rating: '★ 4.5 (96)',
                  amount: '총 18,000원',
                  tagBg: Color(0xFFFFF2D1),
                  tagColor: Color(0xFFB88B2D),
                ),
                SizedBox(height: 14),
                RecommendationCard(
                  image: Assets.recoGame,
                  tag: '놀거리',
                  title: '보드게임 놀이터',
                  walk: '도보 9분',
                  rating: '★ 4.7 (74)',
                  amount: '총 24,000원',
                  tagBg: Color(0xFFEAE4FE),
                  tagColor: Color(0xFF8B6CE0),
                ),
              ],
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            top: 779,
            child: Container(
              height: 69,
              padding: const EdgeInsets.symmetric(horizontal: 17),
              decoration: softBox(
                color: AppColors.accentBg,
                radius: 20,
                shadow: true,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Image.asset(
                      Assets.mascotSmall,
                      width: 28,
                      height: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      '남는 예산까지 고려한 조합을\n추천해드려요!',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF5A4F43),
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.brown),
                ],
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 120,
            child: PrimaryButton(label: '거지방 시작하기', onTap: onDone),
          ),
        ],
      ),
    );
  }
}
