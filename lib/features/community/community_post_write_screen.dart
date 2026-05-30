import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/app_radius.dart';
import 'package:beggar_app/core/theme/app_spacing.dart';
import 'package:beggar_app/core/utils/decorations.dart';
import 'package:beggar_app/shared/widgets/app_header.dart';
import 'package:beggar_app/shared/widgets/figma_frame.dart';
import 'package:beggar_app/shared/widgets/primary_button.dart';

class CommunityPostWriteScreen extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  const CommunityPostWriteScreen({
    super.key,
    required this.onBack,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return FigmaFrame(
      child: Stack(
        children: [
          AppHeader.titled(title: '글쓰기', onBack: onBack),
          Positioned(
            top: AppSpacing.contentTop,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageH),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _CategorySelector(),
                  const SizedBox(height: 16),
                  const _InputBox(
                    label: '제목',
                    value: '오늘 점심 8천원 이하 맛집 공유해요',
                    height: 92,
                  ),
                  const SizedBox(height: 14),
                  const _InputBox(
                    label: '내용',
                    value: '가성비 좋은 식당이나 쿠폰 조합을 공유해보세요.',
                    height: 204,
                    multiline: true,
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(label: '게시하기', onTap: onSubmit),
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

class _CategorySelector extends StatelessWidget {
  const _CategorySelector();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _CategoryChip(label: '절약팁', active: true)),
        SizedBox(width: 8),
        Expanded(child: _CategoryChip(label: '질문')),
        SizedBox(width: 8),
        Expanded(child: _CategoryChip(label: '같이해요')),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool active;

  const _CategoryChip({required this.label, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active ? AppColors.accent : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: Border.all(color: active ? AppColors.accent : AppColors.border),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: active ? Colors.white : AppColors.sub,
        ),
      ),
    );
  }
}

class _InputBox extends StatelessWidget {
  final String label;
  final String value;
  final double height;
  final bool multiline;

  const _InputBox({
    required this.label,
    required this.value,
    this.height = 84,
    this.multiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: softBox(radius: AppRadius.compact),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.lightSub,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              height: 1.4,
              fontWeight: FontWeight.w700,
              color: AppColors.placeholder,
            ),
            maxLines: multiline ? 5 : 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
