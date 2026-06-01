import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/app_radius.dart';
import 'package:beggar_app/core/theme/app_spacing.dart';
import 'package:beggar_app/core/theme/assets.dart';
import 'package:beggar_app/core/utils/decorations.dart';
import 'package:beggar_app/shared/widgets/app_header.dart';
import 'package:beggar_app/shared/widgets/figma_frame.dart';
import 'package:beggar_app/shared/widgets/receipt_card.dart';

class ReceiptsScreen extends StatelessWidget {
  final VoidCallback onCreate;
  final VoidCallback? onBack;

  const ReceiptsScreen({super.key, required this.onCreate, this.onBack});

  @override
  Widget build(BuildContext context) {
    return FigmaFrame(
      child: Stack(
        children: [
          AppHeader.brand(
            title: '지출 내역',
            onBack: onBack,
            showNotification: true,
          ),
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
                  Row(
                    children: const [
                      Text(
                        '모든 지출 내역',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.45,
                        ),
                      ),
                      Spacer(),
                      Text(
                        '최신순',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.sub,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: AppColors.sub,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.gap20),
                  Container(
                    height: 98,
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
                    decoration: softBox(
                      color: AppColors.accentBg,
                      radius: AppRadius.card,
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '이번 달 총 지출',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.lightSub,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '101,000',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.text,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '원',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.sub,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.receipt_long,
                            color: AppColors.accent,
                            size: 21,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.gap24),
                  const ReceiptCard(
                    date: '2024.05.18',
                    room: '명학역 데이트',
                    image: Assets.receiptFood,
                    title: '정성 한식',
                    amount: '35,000원',
                  ),
                  const SizedBox(height: AppSpacing.gap16),
                  const ReceiptCard(
                    date: '2024.05.12',
                    room: '전시 보러 가요',
                    image: Assets.receiptCafe,
                    title: '블루보틀 삼청',
                    amount: '14,000원',
                  ),
                  const SizedBox(height: AppSpacing.gap16),
                  const ReceiptCard(
                    date: '2024.05.05',
                    room: '주말 브런치 클럽',
                    image: Assets.receiptBrunch,
                    title: '오아시스 한남',
                    amount: '52,000원',
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
