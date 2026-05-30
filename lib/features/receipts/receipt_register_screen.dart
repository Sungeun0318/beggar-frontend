import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/app_radius.dart';
import 'package:beggar_app/core/theme/app_spacing.dart';
import 'package:beggar_app/core/utils/decorations.dart';
import 'package:beggar_app/shared/widgets/app_header.dart';
import 'package:beggar_app/shared/widgets/figma_frame.dart';

class ReceiptRegisterScreen extends StatelessWidget {
  final String modeTitle;
  final String modeDescription;
  final VoidCallback onBack;
  final VoidCallback onComplete;

  const ReceiptRegisterScreen({
    super.key,
    required this.modeTitle,
    required this.modeDescription,
    required this.onBack,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return FigmaFrame(
      child: Stack(
        children: [
          AppHeader.titled(title: '$modeTitle 등록', onBack: onBack),
          Positioned(
            top: AppSpacing.contentTop,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageH),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: softBox(
                      color: AppColors.accentBg,
                      radius: AppRadius.card,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          modeTitle,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppColors.text,
                            letterSpacing: -0.7,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          modeDescription,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.sub,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.gap24),
                  const Text(
                    '등록 방법을 선택해주세요',
                    style: TextStyle(
                      fontSize: 17,
                      height: 1.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text,
                      letterSpacing: -0.43,
                    ),
                  ),
                  const SizedBox(height: 13),
                  _RegisterMethodCard(
                    icon: Icons.camera_alt_outlined,
                    title: '사진 촬영',
                    body: '카메라로 영수증을 바로 찍어요',
                    onTap: onComplete,
                  ),
                  const SizedBox(height: AppSpacing.gap12),
                  _RegisterMethodCard(
                    icon: Icons.photo_library_outlined,
                    title: '갤러리에서 가져오기',
                    body: '이미 찍어둔 영수증 사진을 선택해요',
                    onTap: onComplete,
                  ),
                  const SizedBox(height: AppSpacing.gap12),
                  _RegisterMethodCard(
                    icon: Icons.edit_note,
                    title: '수동 입력',
                    body: '금액과 내용을 직접 입력해요',
                    onTap: onComplete,
                  ),
                  const SizedBox(height: AppSpacing.gap24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: softBox(radius: AppRadius.card),
                    child: const Text(
                      '현재 프로토타입에서는 선택 후 지출 내역 화면으로 이동해요. 실제 연동 때 카메라, 갤러리, 직접 입력 화면을 각각 연결하면 돼요.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.sub,
                      ),
                    ),
                  ),
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

class _RegisterMethodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final VoidCallback onTap;

  const _RegisterMethodCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 86,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: softBox(radius: AppRadius.card, shadow: true),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: AppColors.accentBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.accent, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    body,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.sub,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.lightSub),
          ],
        ),
      ),
    );
  }
}
