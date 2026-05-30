import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/app_radius.dart';
import 'package:beggar_app/core/theme/app_spacing.dart';
import 'package:beggar_app/core/utils/decorations.dart';
import 'package:beggar_app/data/mock/mock_db.dart';
import 'package:beggar_app/shared/widgets/app_header.dart';
import 'package:beggar_app/shared/widgets/choice_box.dart';
import 'package:beggar_app/shared/widgets/figma_frame.dart';
import 'package:beggar_app/shared/widgets/input_like.dart';
import 'package:beggar_app/shared/widgets/primary_button.dart';
import 'package:beggar_app/shared/widgets/round_icon.dart';
import 'package:beggar_app/shared/widgets/section_title.dart';

class RoomSettingsScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onSave;

  const RoomSettingsScreen({
    super.key,
    required this.onBack,
    required this.onSave,
  });

  @override
  State<RoomSettingsScreen> createState() => _RoomSettingsScreenState();
}

class _RoomSettingsScreenState extends State<RoomSettingsScreen> {
  late int maxMemberCount;

  @override
  void initState() {
    super.initState();
    maxMemberCount = MockDb.room.maxMemberCount;
  }

  void _changeMaxMemberCount(int delta) {
    final room = MockDb.room;
    final next = (maxMemberCount + delta).clamp(room.memberCount, 100);
    setState(() => maxMemberCount = next);
  }

  @override
  Widget build(BuildContext context) {
    final room = MockDb.room;
    final isOwner = MockDb.currentUser.no == room.ownerNo;

    return FigmaFrame(
      child: Stack(
        children: [
          AppHeader.titled(title: '거지방 설정', onBack: widget.onBack),
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
                  const SectionTitle('거지방 정보'),
                  const SizedBox(height: 13),
                  _RoomInfoCard(
                    code: room.code.toUpperCase(),
                    currentCount: room.memberCount,
                    maxCount: maxMemberCount,
                  ),
                  const SizedBox(height: 38),
                  const SectionTitle('인원 제한'),
                  const SizedBox(height: 13),
                  _MemberLimitCard(
                    currentCount: room.memberCount,
                    maxCount: maxMemberCount,
                    enabled: isOwner,
                    onDecrease: () => _changeMaxMemberCount(-1),
                    onIncrease: () => _changeMaxMemberCount(1),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isOwner
                        ? '* 반장은 방 생성 후에도 인원 제한을 조정할 수 있어요.'
                        : '* 인원 제한 변경은 반장만 가능해요.',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.sub,
                    ),
                  ),
                  const SizedBox(height: 38),
                  const SectionTitle('지역 변경'),
                  const SizedBox(height: 13),
                  InputLike(
                    label: room.location,
                    icon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 38),
                  const SectionTitle('추천 태그 변경'),
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
                  const SizedBox(
                    height: 56,
                    child: ChoiceBox(icon: Icons.restaurant, label: '기타 요식업'),
                  ),
                  const SizedBox(height: 38),
                  PrimaryButton(label: '설정 저장', onTap: widget.onSave),
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

class _RoomInfoCard extends StatelessWidget {
  final String code;
  final int currentCount;
  final int maxCount;

  const _RoomInfoCard({
    required this.code,
    required this.currentCount,
    required this.maxCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: softBox(radius: AppRadius.card),
      child: Column(
        children: [
          _InfoRow(icon: Icons.tag, label: '거지방 코드', value: code),
          const SizedBox(height: 14),
          _InfoRow(
            icon: Icons.groups_outlined,
            label: '현재 참여 인원',
            value: '$currentCount / $maxCount명',
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.bg,
          child: Icon(icon, size: 20, color: AppColors.brown),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.sub,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.text,
          ),
        ),
      ],
    );
  }
}

class _MemberLimitCard extends StatelessWidget {
  final int currentCount;
  final int maxCount;
  final bool enabled;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const _MemberLimitCard({
    required this.currentCount,
    required this.maxCount,
    required this.enabled,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 17),
      decoration: softBox(radius: AppRadius.compact),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.bg,
            child: Icon(
              Icons.person_add_alt_1_outlined,
              color: AppColors.brown,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            '최대 인원',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.darkSub,
            ),
          ),
          const Spacer(),
          _LimitButton(
            icon: Icons.remove,
            enabled: enabled && maxCount > currentCount,
            onTap: onDecrease,
          ),
          const SizedBox(width: 16),
          Text(
            '$maxCount',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: enabled ? AppColors.text : AppColors.placeholder,
            ),
          ),
          const SizedBox(width: 16),
          _LimitButton(
            icon: Icons.add,
            enabled: enabled && maxCount < 100,
            onTap: onIncrease,
          ),
        ],
      ),
    );
  }
}

class _LimitButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _LimitButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        behavior: HitTestBehavior.opaque,
        child: RoundIcon(icon: icon),
      ),
    );
  }
}
