import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/app_radius.dart';
import 'package:beggar_app/core/theme/app_spacing.dart';
import 'package:beggar_app/core/utils/decorations.dart';
import 'package:beggar_app/shared/widgets/app_header.dart';
import 'package:beggar_app/shared/widgets/figma_frame.dart';
import 'package:beggar_app/shared/widgets/participant_tile.dart';
import 'package:beggar_app/shared/widgets/primary_button.dart';
import 'package:beggar_app/shared/widgets/section_title.dart';

class BudgetInputScreen extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onNext;

  const BudgetInputScreen({
    super.key,
    required this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return FigmaFrame(
      height: 930,
      child: Stack(
        children: [
          AppHeader.titled(title: '예산 입력', onBack: onBack),
          Positioned(
            top: AppSpacing.contentTop,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageH),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: softBox(
                      color: AppColors.accentBg,
                      radius: AppRadius.card,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '명학역 데이트',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '명학역 1번 출구 근처 · 참여 인원 4명',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.sub,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: SectionTitle('내 예산을 입력해주세요'),
                  ),
                  const SizedBox(height: 13),
                  Container(
                    height: 72,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: softBox(radius: AppRadius.compact),
                    child: const Row(
                      children: [
                        Text(
                          '15,000',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '원',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.sub,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.edit_outlined, color: AppColors.placeholder),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: SectionTitle('참여자 입력 현황'),
                  ),
                  const SizedBox(height: 14),
                  const ParticipantTile(
                    name: '거지님',
                    status: '입력 중',
                    active: true,
                  ),
                  const ParticipantTile(
                    name: '절약왕',
                    status: '제출 완료',
                    active: false,
                  ),
                  const ParticipantTile(
                    name: '김짠돌',
                    status: '제출 완료',
                    active: false,
                  ),
                  const ParticipantTile(
                    name: '거짓말마세요거지님',
                    status: '제출 완료',
                    active: false,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(
                        Icons.info_outline,
                        size: 18,
                        color: AppColors.accent,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '시스템이 가장 낮은 제출 금액을 기준으로\n오늘의 총예산을 계산해요.',
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.sub,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.gap24),
                  PrimaryButton(label: '입력 완료', onTap: onNext),
                  const SizedBox(height: AppSpacing.bottomSafe),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
