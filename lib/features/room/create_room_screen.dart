import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/utils/decorations.dart';
import 'package:beggar_app/shared/widgets/choice_box.dart';
import 'package:beggar_app/shared/widgets/figma_frame.dart';
import 'package:beggar_app/shared/widgets/info_card.dart';
import 'package:beggar_app/shared/widgets/input_like.dart';
import 'package:beggar_app/shared/widgets/primary_button.dart';
import 'package:beggar_app/shared/widgets/round_icon.dart';
import 'package:beggar_app/shared/widgets/section_title.dart';

class CreateRoomScreen extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onNext;

  const CreateRoomScreen({
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
          ScreenHeader(title: '새 거지방 만들기', onBack: onBack),
          Positioned(
            top: 130,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle('어디서 모이나요?'),
                const SizedBox(height: 13),
                const InputLike(
                  label: '예) 강남역, 홍대입구',
                  icon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 38),
                const SectionTitle('어떤 모임인가요?'),
                const SizedBox(height: 13),
                GridView.count(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 166 / 56,
                  children: const [
                    ChoiceBox(icon: Icons.restaurant, label: '한식'),
                    ChoiceBox(icon: Icons.restaurant, label: '양식'),
                    ChoiceBox(icon: Icons.ramen_dining, label: '일식'),
                    ChoiceBox(icon: Icons.outdoor_grill, label: '중식'),
                  ],
                ),
                const SizedBox(height: 12),
                const ChoiceBox(icon: Icons.restaurant, label: '기타 요식업'),
                const SizedBox(height: 38),
                const SectionTitle('몇 명이서 모이나요?'),
                const SizedBox(height: 13),
                Container(
                  height: 72,
                  padding: const EdgeInsets.symmetric(horizontal: 17),
                  decoration: softBox(radius: 16),
                  child: Row(
                    children: const [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.bg,
                        child: Icon(
                          Icons.groups_outlined,
                          color: AppColors.brown,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        '참여 인원',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF5A4F43),
                        ),
                      ),
                      Spacer(),
                      RoundIcon(icon: Icons.remove),
                      SizedBox(width: 16),
                      Text(
                        '4',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 16),
                      RoundIcon(icon: Icons.add),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '* 최소 2명부터 최대 20명까지 참여 가능해요.',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.sub,
                  ),
                ),
                const SizedBox(height: 34),
                const InfoCard(
                  icon: Icons.lock_outline,
                  title: '개인 예산은 익명으로 수집돼요',
                  body: '가장 낮은 금액 기준으로\n오늘의 총예산이 정해져요.',
                ),
                const SizedBox(height: 110),
              ],
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 120,
            child: PrimaryButton(label: '방 만들기', onTap: onNext),
          ),
        ],
      ),
    );
  }
}
