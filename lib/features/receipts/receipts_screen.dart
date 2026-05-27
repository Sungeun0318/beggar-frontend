import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/assets.dart';
import 'package:beggar_app/core/utils/decorations.dart';
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
                  '거지 우정 수호대',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.92,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.undo, size: 20, color: AppColors.sub),
                const SizedBox(width: 22),
                const Icon(Icons.notifications_none, size: 24),
              ],
            ),
          ),
          if (onBack != null)
            Positioned(
              top: 54,
              left: 2,
              child: IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.chevron_left, size: 30),
              ),
            ),
          Positioned(
            top: 124,
            left: 24,
            right: 24,
            child: Row(
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
                Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.sub),
              ],
            ),
          ),
          Positioned(
            top: 174,
            left: 24,
            right: 24,
            child: Container(
              height: 98,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
              decoration: softBox(color: AppColors.accentBg, radius: 20),
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
          ),
          Positioned(
            top: 296,
            left: 24,
            right: 24,
            child: Column(
              children: const [
                ReceiptCard(
                  date: '2024.05.18',
                  room: '명학역 데이트',
                  image: Assets.receiptFood,
                  title: '정성 한식',
                  amount: '35,000원',
                ),
                SizedBox(height: 16),
                ReceiptCard(
                  date: '2024.05.12',
                  room: '전시 보러 가요',
                  image: Assets.receiptCafe,
                  title: '블루보틀 삼청',
                  amount: '14,000원',
                ),
                SizedBox(height: 16),
                ReceiptCard(
                  date: '2024.05.05',
                  room: '주말 브런치 클럽',
                  image: Assets.receiptBrunch,
                  title: '오아시스 한남',
                  amount: '52,000원',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
