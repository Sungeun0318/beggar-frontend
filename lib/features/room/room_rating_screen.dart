import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/app_radius.dart';
import 'package:beggar_app/core/theme/app_spacing.dart';
import 'package:beggar_app/core/theme/app_text_styles.dart';
import 'package:beggar_app/core/utils/decorations.dart';
import 'package:beggar_app/shared/widgets/app_header.dart';
import 'package:beggar_app/shared/widgets/figma_frame.dart';

class RoomRatingScreen extends StatelessWidget {
  final VoidCallback onBack;

  const RoomRatingScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return FigmaFrame(
      child: Stack(
        children: [
          AppHeader.titled(title: '거지방 평가', onBack: onBack),
          Positioned.fill(
            top: AppSpacing.contentTop,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageH,
                0,
                AppSpacing.pageH,
                AppSpacing.bottomSafe,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('거지방1 평가', style: AppTextStyles.sectionHeading),
                  SizedBox(height: 6),
                  Text(
                    '이 방 멤버가 함께 만든 공동 절약 점수예요.',
                    style: AppTextStyles.bodySub,
                  ),
                  SizedBox(height: AppSpacing.gap20),
                  _RoomScoreCard(),
                  SizedBox(height: AppSpacing.gap20),
                  _ScoreBreakdown(),
                  SizedBox(height: AppSpacing.gap24),
                  _SharedScoreNotice(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoomScoreCard extends StatelessWidget {
  const _RoomScoreCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: softBox(radius: AppRadius.card, shadow: true),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.emoji_events, size: 30, color: AppColors.accent),
              SizedBox(width: 10),
              Text(
                '이 방 점수',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            '82점',
            style: TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.w900,
              color: AppColors.text,
              letterSpacing: -0.7,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '알뜰한 거지',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.darkSub,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreBreakdown extends StatelessWidget {
  const _ScoreBreakdown();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: softBox(radius: AppRadius.card, shadow: true),
      child: const Column(
        children: [
          _BreakdownRow(label: '예산 준수율', value: '92%'),
          SizedBox(height: 12),
          _BreakdownRow(label: '절약률', value: '18%'),
          SizedBox(height: 12),
          _BreakdownRow(label: '착한가격업소 인증', value: '1회'),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final String label;
  final String value;

  const _BreakdownRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.sub,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppColors.text,
          ),
        ),
      ],
    );
  }
}

class _SharedScoreNotice extends StatelessWidget {
  const _SharedScoreNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: softBox(radius: AppRadius.card, shadow: true),
      child: const Row(
        children: [
          Icon(Icons.groups_2_outlined, size: 28, color: AppColors.accent),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '멤버 모두 같은 방 점수를 공유해요',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '개인별 점수가 아니라 이 방의 예산 사용과 착한가격업소 인증 결과로 계산돼요.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                    color: AppColors.sub,
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
