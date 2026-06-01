import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/app_radius.dart';
import 'package:beggar_app/core/theme/app_spacing.dart';
import 'package:beggar_app/core/theme/assets.dart';
import 'package:beggar_app/core/utils/decorations.dart';
import 'package:beggar_app/core/utils/formatters.dart';
import 'package:beggar_app/data/mock/mock_db.dart';
import 'package:beggar_app/shared/widgets/figma_frame.dart';

class ActiveRoomScreen extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onOpenRating;
  final VoidCallback onOpenSettings;

  const ActiveRoomScreen({
    super.key,
    required this.onBack,
    required this.onOpenRating,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    final total = MockDb.budgetResult.totalBudget;

    return FigmaFrame(
      child: Stack(
        children: [
          _RoomHeader(onBack: onBack, onOpenSettings: onOpenSettings),
          Positioned(
            top: AppSpacing.contentTop - 7,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 124),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _BudgetSummary(total: total),
                  const SizedBox(height: 10),
                  _RoomRatingButton(onTap: onOpenRating),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 17),
                      decoration: softBox(radius: AppRadius.card),
                      alignment: Alignment.center,
                      child: const Text(
                        '오늘의 예산을 바탕으로 추천해보겠습니다.',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.text,
                          letterSpacing: -0.71,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const _RoomRecommendationCard(),
                  const SizedBox(height: 14),
                  const _ReceiptPreview(),
                  const SizedBox(height: AppSpacing.gap24),
                  const _NextCourseSection(),
                  const SizedBox(height: AppSpacing.gap20),
                  const _EndRoomButton(),
                  const SizedBox(height: AppSpacing.gap28),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoomRatingButton extends StatelessWidget {
  final VoidCallback onTap;

  const _RoomRatingButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 65,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: softBox(radius: AppRadius.card, shadow: true),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF6D8),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.emoji_events_outlined,
                size: 18,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(width: 11),
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '거지평가 보기',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.35,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                      letterSpacing: -0.23,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '이 방의 절약 점수와 순위를 확인해요',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                      color: AppColors.sub,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 24, color: AppColors.sub),
          ],
        ),
      ),
    );
  }
}

class RoomReceiptBar extends StatelessWidget {
  final VoidCallback onAddCombinedReceipt;
  final VoidCallback onAddSplitReceipt;

  const RoomReceiptBar({
    super.key,
    required this.onAddCombinedReceipt,
    required this.onAddSplitReceipt,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: 92,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xF2FFFFFF),
          border: Border(top: BorderSide(color: AppColors.border, width: 0.7)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _ReceiptBarItem(
              icon: Icons.receipt_long_outlined,
              label: '통합 영수증',
              onTap: onAddCombinedReceipt,
            ),
            _ReceiptBarItem(
              icon: Icons.call_split,
              label: '분할 영수증',
              onTap: onAddSplitReceipt,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ReceiptBarItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 116,
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            children: [
              Icon(icon, size: 26, color: AppColors.text),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.text,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoomHeader extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onOpenSettings;

  const _RoomHeader({required this.onBack, required this.onOpenSettings});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: AppSpacing.headerTop - 16,
      left: AppSpacing.pageH,
      right: AppSpacing.pageH,
      height: AppSpacing.headerHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            top: 8,
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 40, height: 40),
              icon: const Icon(Icons.chevron_left, size: 30),
              color: AppColors.text,
              onPressed: onBack,
            ),
          ),
          const Text(
            '거지방1',
            style: TextStyle(
              fontSize: 21,
              height: 1.3,
              fontWeight: FontWeight.w900,
              color: AppColors.text,
              letterSpacing: -0.7,
            ),
          ),
          Positioned(
            right: 0,
            top: 12,
            child: GestureDetector(
              onTap: onOpenSettings,
              behavior: HitTestBehavior.opaque,
              child: const SizedBox(
                width: 32,
                height: 32,
                child: Icon(Icons.settings, size: 24, color: AppColors.text),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BudgetSummary extends StatelessWidget {
  final int total;

  const _BudgetSummary({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: softBox(radius: 18, shadow: true),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFFF4F6FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              size: 17,
              color: Color(0xFF6E83FF),
            ),
          ),
          const SizedBox(width: 11),
          const Text(
            '오늘의 예산',
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              fontWeight: FontWeight.w500,
              color: AppColors.text,
              letterSpacing: -0.23,
            ),
          ),
          const Spacer(),
          Text(
            '${money(total)} 원',
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              fontWeight: FontWeight.w500,
              color: AppColors.text,
              letterSpacing: -0.23,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoomRecommendationCard extends StatelessWidget {
  const _RoomRecommendationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 156,
      padding: const EdgeInsets.fromLTRB(12, 12, 11, 12),
      decoration: softBox(radius: AppRadius.card, shadow: true),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              Assets.recoFood,
              width: 110,
              height: 112,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.tagBgFood,
                          borderRadius: BorderRadius.circular(AppRadius.chip),
                        ),
                        child: const Text(
                          '한식',
                          style: TextStyle(
                            fontSize: 11,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.danger,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: const [
                          Text(
                            '1 / 3',
                            style: TextStyle(
                              fontSize: 16,
                              height: 1,
                              fontWeight: FontWeight.w400,
                              color: AppColors.text,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.arrow_forward, size: 16),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    '정성 한식 세트',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                      letterSpacing: -0.71,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.bg,
                          borderRadius: BorderRadius.circular(AppRadius.chip),
                          border: Border.all(color: AppColors.muted),
                        ),
                        child: const Text(
                          '도보 5분',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.lightSub,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '★ 4.6 (128)',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.sub,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '총 38,000원',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkSub,
                      letterSpacing: -0.31,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptPreview extends StatelessWidget {
  const _ReceiptPreview();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 293,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Spacer(),
          const Padding(
            padding: EdgeInsets.only(bottom: 65),
            child: Text(
              '19 : 30',
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                letterSpacing: -0.71,
              ),
            ),
          ),
          const SizedBox(width: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(
              Assets.receiptUpload,
              width: 161,
              height: 293,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

class _NextCourseSection extends StatelessWidget {
  const _NextCourseSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: softBox(radius: AppRadius.card, shadow: true),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Text(
            '다음 코스 고르기',
            style: TextStyle(
              fontSize: 19,
              height: 1.35,
              fontWeight: FontWeight.w900,
              color: AppColors.text,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '태그를 바꾸면 남은 예산에 맞춰 추천이 다시 나와요.',
            style: TextStyle(
              fontSize: 13,
              height: 1.45,
              fontWeight: FontWeight.w600,
              color: AppColors.sub,
              letterSpacing: -0.23,
            ),
          ),
          SizedBox(height: 16),
          _CategoryGrid(),
          SizedBox(height: 18),
          _CourseResultHeader(),
          SizedBox(height: 10),
          _NextCourseCard(),
        ],
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: const [
        _CategoryButton(label: '한식', selected: true),
        _CategoryButton(label: '양식'),
        _CategoryButton(label: '일식'),
        _CategoryButton(label: '중식'),
        _CategoryButton(label: '기타 요식업', wide: true),
      ],
    );
  }
}

class _CourseResultHeader extends StatelessWidget {
  const _CourseResultHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Text(
          '한식 추천',
          style: TextStyle(
            fontSize: 16,
            height: 1.4,
            fontWeight: FontWeight.w900,
            color: AppColors.text,
            letterSpacing: -0.35,
          ),
        ),
        Spacer(),
        Text(
          '남은 예산 기준',
          style: TextStyle(
            fontSize: 12,
            height: 1.4,
            fontWeight: FontWeight.w700,
            color: AppColors.lightSub,
          ),
        ),
      ],
    );
  }
}

class _NextCourseCard extends StatelessWidget {
  const _NextCourseCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 118,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.accentBg,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.storefront_outlined,
              color: AppColors.accent,
              size: 28,
            ),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '착한가격 업소',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.4,
                    fontWeight: FontWeight.w900,
                    color: AppColors.accent,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '명학 순두부',
                  style: TextStyle(
                    fontSize: 17,
                    height: 1.25,
                    fontWeight: FontWeight.w900,
                    color: AppColors.text,
                    letterSpacing: -0.4,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '도보 6분 · 1인 8,000원',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    fontWeight: FontWeight.w700,
                    color: AppColors.sub,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '남은 예산으로 가능',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkSub,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.brown),
        ],
      ),
    );
  }
}

class _EndRoomButton extends StatelessWidget {
  const _EndRoomButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.compact),
        border: Border.all(color: AppColors.border),
      ),
      child: const Text(
        '오늘 방 종료하기',
        style: TextStyle(
          fontSize: 14,
          height: 1.5,
          fontWeight: FontWeight.w700,
          color: AppColors.sub,
          letterSpacing: -0.23,
        ),
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final String label;
  final bool selected;
  final bool wide;

  const _CategoryButton({
    required this.label,
    this.selected = false,
    this.wide = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: wide ? 142 : 78,
      height: 38,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFE7B8) : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.chip),
          border: Border.all(
            color: selected ? const Color(0xFF5E4B24) : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selected) ...[
              const Icon(Icons.check, size: 16, color: AppColors.text),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                height: 1.35,
                fontWeight: FontWeight.w800,
                color: selected ? AppColors.text : AppColors.sub,
                letterSpacing: -0.23,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
