import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/app_radius.dart';
import 'package:beggar_app/core/theme/app_spacing.dart';
import 'package:beggar_app/core/theme/assets.dart';
import 'package:beggar_app/core/utils/decorations.dart';
import 'package:beggar_app/core/utils/formatters.dart';
import 'package:beggar_app/data/models/recommendation.dart';
import 'package:beggar_app/data/repositories/recommendation_repository.dart';
import 'package:beggar_app/shared/widgets/app_header.dart';
import 'package:beggar_app/shared/widgets/figma_frame.dart';
import 'package:beggar_app/shared/widgets/primary_button.dart';
import 'package:beggar_app/shared/widgets/recommendation_card.dart';
import 'package:beggar_app/shared/widgets/summary_row.dart';
import 'package:url_launcher/url_launcher.dart';

class RecommendationScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onDone;

  const RecommendationScreen({
    super.key,
    required this.onBack,
    required this.onDone,
  });

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  static const _roomNo = 1;
  static const _tag = '식사';
  static const _region = '서울특별시 중구';

  late final Future<RecommendationResult> _recommendationFuture;

  @override
  void initState() {
    super.initState();
    _recommendationFuture = RecommendationRepository().recommend(
      roomNo: _roomNo,
      tag: _tag,
      region: _region,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FigmaFrame(
      child: Stack(
        children: [
          AppHeader.titled(title: '예산에 맞는 추천', onBack: widget.onBack),
          Positioned(
            top: AppSpacing.contentTop,
            left: 0,
            right: 0,
            bottom: 0,
            child: FutureBuilder<RecommendationResult>(
              future: _recommendationFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const _RecommendationLoading();
                }
                if (snapshot.hasError) {
                  return _RecommendationError(
                    message: snapshot.error.toString(),
                  );
                }
                final result = snapshot.data!;
                return _RecommendationContent(
                  result: result,
                  onDone: widget.onDone,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationContent extends StatelessWidget {
  final RecommendationResult result;
  final VoidCallback onDone;

  const _RecommendationContent({required this.result, required this.onDone});

  @override
  Widget build(BuildContext context) {
    final budgetLabel = result.totalBudget == null
        ? '예산 정보 없이 추천'
        : '총예산 ${money(result.totalBudget!)}원 기준 추천';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SummaryRow(
            icon: Icons.location_on_outlined,
            label: result.requestedRegion ?? '지역 전체',
            trailing: result.requestedTag,
            bg: AppColors.accentBg,
          ),
          const SizedBox(height: 10),
          SummaryRow(
            icon: Icons.account_balance_wallet_outlined,
            label: budgetLabel,
            bg: const Color(0xFFF4F6FF),
          ),
          const SizedBox(height: 22),
          if (result.places.isEmpty)
            const _EmptyRecommendation()
          else
            for (final place in result.places) ...[
              _ApiRecommendationCard(
                place: place,
                onMapTap: () => _openMap(context, place.mapUrl),
              ),
              const SizedBox(height: 14),
            ],
          const SizedBox(height: AppSpacing.gap24),
          const _RecommendationNotice(),
          const SizedBox(height: AppSpacing.gap24),
          PrimaryButton(label: '거지방 시작하기', onTap: onDone),
          const SizedBox(height: AppSpacing.bottomSafe),
        ],
      ),
    );
  }

  Future<void> _openMap(BuildContext context, String mapUrl) async {
    final uri = Uri.tryParse(mapUrl);
    final opened = uri != null
        ? await launchUrl(uri, mode: LaunchMode.externalApplication)
        : false;

    if (!opened && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('카카오맵을 열 수 없어요.')));
    }
  }
}

class _ApiRecommendationCard extends StatelessWidget {
  final RecommendedPlace place;
  final VoidCallback onMapTap;

  const _ApiRecommendationCard({required this.place, required this.onMapTap});

  @override
  Widget build(BuildContext context) {
    final (tagBg, tagColor) = _tagColors(place.category);
    return RecommendationCard(
      image: place.thumbnailUrl,
      tag: place.category,
      title: place.name,
      walk: place.address,
      rating: '착한가격업소',
      amount: place.expectedPrice == null
          ? '가격 정보 없음'
          : '최저 ${money(place.expectedPrice!)}원',
      tagBg: tagBg,
      tagColor: tagColor,
      onMapTap: onMapTap,
    );
  }

  (Color, Color) _tagColors(String category) {
    if (category.contains('기타')) {
      return (AppColors.tagBgCafe, AppColors.tagFgCafe);
    }
    return (AppColors.tagBgFood, AppColors.danger);
  }
}

class _RecommendationNotice extends StatelessWidget {
  const _RecommendationNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 69,
      padding: const EdgeInsets.symmetric(horizontal: 17),
      decoration: softBox(
        color: AppColors.accentBg,
        radius: AppRadius.card,
        shadow: true,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Image.asset(Assets.mascotSmall, width: 28, height: 28),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              '남는 예산까지 고려한 조합을\n추천해드려요!',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w600,
                color: AppColors.darkSub,
              ),
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.brown),
        ],
      ),
    );
  }
}

class _RecommendationLoading extends StatelessWidget {
  const _RecommendationLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.accent),
    );
  }
}

class _RecommendationError extends StatelessWidget {
  final String message;

  const _RecommendationError({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageH),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: softBox(radius: AppRadius.card),
          child: Text(
            '추천을 불러오지 못했어요.\n$message',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w600,
              color: AppColors.darkSub,
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyRecommendation extends StatelessWidget {
  const _EmptyRecommendation();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: softBox(radius: AppRadius.card),
      child: const Text(
        '조건에 맞는 착한가격업소가 없어요.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.darkSub,
        ),
      ),
    );
  }
}
