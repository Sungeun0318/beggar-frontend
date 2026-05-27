import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/assets.dart';
import 'package:beggar_app/core/utils/decorations.dart';
import 'package:beggar_app/core/utils/formatters.dart';
import 'package:beggar_app/data/mock/mock_db.dart';
import 'package:beggar_app/shared/widgets/action_box.dart';
import 'package:beggar_app/shared/widgets/chip_label.dart';
import 'package:beggar_app/shared/widgets/figma_frame.dart';
import 'package:beggar_app/shared/widgets/receipt_card.dart';
import 'package:beggar_app/shared/widgets/recommendation_card.dart';
import 'package:beggar_app/shared/widgets/section_title.dart';

class ActiveRoomScreen extends StatelessWidget {
  final VoidCallback onAddReceipt;
  final VoidCallback onCreate;

  const ActiveRoomScreen({
    super.key,
    required this.onAddReceipt,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    final spent = MockDb.receipts.first.amount + MockDb.receipts[1].amount;
    final total = MockDb.budgetResult.totalBudget;
    final left = total - spent;
    final ratio = spent / total;

    return FigmaFrame(
      child: Stack(
        children: [
          Positioned(
            top: 55,
            left: 24,
            right: 24,
            height: 40,
            child: Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    Assets.logo,
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  '거지방 진행 중',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.7,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.notifications_none, size: 24),
              ],
            ),
          ),
          Positioned(
            top: 122,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: softBox(color: AppColors.accentBg, radius: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            MockDb.room.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(),
                          ChipLabel(
                            icon: Icons.location_on_outlined,
                            label: MockDb.room.location,
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            '남은 예산',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.sub,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: money(left),
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const TextSpan(
                                  text: '원',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.sub,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          value: ratio,
                          minHeight: 10,
                          backgroundColor: Colors.white,
                          valueColor: const AlwaysStoppedAnimation(
                            AppColors.accent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '총 ${money(total)}원 중 ${money(spent)}원 사용 · 사용률 ${(ratio * 100).round()}%',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.sub,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const SectionTitle('오늘의 추천 코스'),
                const SizedBox(height: 14),
                const RecommendationCard(
                  image: Assets.recoFood,
                  tag: '식사',
                  title: '정성 한식 세트',
                  walk: '도보 5분',
                  rating: '★ 4.6 (128)',
                  amount: '총 38,000원',
                  tagBg: Color(0xFFFFEADD),
                  tagColor: AppColors.danger,
                ),
                const SizedBox(height: 20),
                const SectionTitle('지출 입력'),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: ActionBox(
                        icon: Icons.camera_alt_outlined,
                        title: '영수증 촬영',
                        body: 'OCR로 자동 입력',
                        onTap: onAddReceipt,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ActionBox(
                        icon: Icons.edit_note,
                        title: '수동 입력',
                        body: '금액 직접 등록',
                        onTap: onAddReceipt,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const SectionTitle('최근 지출'),
                const SizedBox(height: 14),
                ReceiptCard(
                  date: MockDb.receipts.first.date,
                  room: MockDb.receipts.first.room,
                  image: MockDb.receipts.first.image,
                  title: MockDb.receipts.first.title,
                  amount: '${money(MockDb.receipts.first.amount)}원',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
