import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/assets.dart';
import 'package:beggar_app/core/utils/decorations.dart';
import 'package:beggar_app/data/mock/mock_db.dart';
import 'package:beggar_app/shared/widgets/figma_frame.dart';
import 'package:beggar_app/shared/widgets/room_home_card.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onOpenRoom;
  final VoidCallback onCreate;

  const HomeScreen({
    super.key,
    required this.onOpenRoom,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    return FigmaFrame(
      child: Stack(
        children: [
          Positioned(
            top: 48,
            left: 24,
            right: 24,
            height: 48,
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
            top: 116,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '내 거지방',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.7,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '참여 중인 방에서 예산과 지출을 확인해요.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.sub,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  height: 54,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: softBox(radius: 16),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: AppColors.placeholder,
                        size: 22,
                      ),
                      SizedBox(width: 10),
                      Text(
                        '방 이름, 위치로 검색',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.placeholder,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                RoomHomeCard(
                  title: MockDb.room.name,
                  location: MockDb.room.location,
                  budget: MockDb.budgetResult.totalBudget,
                  spent:
                      MockDb.receipts.first.amount + MockDb.receipts[1].amount,
                  memberCount: MockDb.room.memberCount,
                  status: '진행 중',
                  onTap: onOpenRoom,
                ),
                const SizedBox(height: 14),
                RoomHomeCard(
                  title: '전시 보러 가요',
                  location: '삼청동 블루보틀 근처',
                  budget: 100000,
                  spent: 14000,
                  memberCount: 5,
                  status: '예산 확정',
                  onTap: onOpenRoom,
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: onCreate,
                  child: Container(
                    height: 92,
                    decoration: softBox(color: AppColors.accentBg, radius: 20),
                    child: const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add_circle_outline,
                            color: AppColors.accent,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '새 거지방 만들기',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                    ),
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
