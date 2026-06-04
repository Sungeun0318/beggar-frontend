import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/app_radius.dart';
import 'package:beggar_app/core/theme/app_spacing.dart';
import 'package:beggar_app/core/theme/assets.dart';
import 'package:beggar_app/core/utils/decorations.dart';
import 'package:beggar_app/data/mock/mock_db.dart';
import 'package:beggar_app/shared/widgets/app_header.dart';
import 'package:beggar_app/shared/widgets/figma_frame.dart';
import 'package:beggar_app/shared/widgets/info_card.dart';
import 'package:beggar_app/shared/widgets/participant_tile.dart';
import 'package:beggar_app/shared/widgets/primary_button.dart';
import 'package:beggar_app/shared/widgets/section_title.dart';

class InviteRoomScreen extends StatelessWidget {
  final String roomName;
  final String location;
  final int maxMemberCount;
  final String inviteCode;

  final VoidCallback onBack;
  final VoidCallback onNext;

  const InviteRoomScreen({
    super.key,
    required this.roomName,
    required this.location,
    required this.maxMemberCount,
    required this.inviteCode,
    required this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return FigmaFrame(
      child: Stack(
        children: [
          AppHeader.titled(title: '친구 초대', onBack: onBack),
          Positioned(
            top: AppSpacing.contentTop,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageH),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
                    decoration: softBox(
                      color: AppColors.accentBg,
                      radius: AppRadius.card,
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          Assets.mascotSmall,
                          width: 82,
                          height: 82,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 16),
                        // 🌟 진짜 백엔드 방 이름 반영!
                        Text(
                          roomName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // 🌟 진짜 백엔드 장소 및 최대 인원 반영!
                        Text(
                          '$location · $maxMemberCount명',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.sub,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          height: 54,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              AppRadius.compact,
                            ),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.link,
                                color: AppColors.accent,
                                size: 22,
                              ),
                              const SizedBox(width: 10),
                              // 🌟 가로 화면 터짐 억까를 방어하기 위해 Expanded와 Text옵션 추가!
                              Expanded(
                                child: Text(
                                  'beggar.app/join/$inviteCode', // 🎲 자바가 준 진짜 생성 코드 안착!
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.darkSub,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: SectionTitle('입장 현황'),
                  ),
                  const SizedBox(height: 14),
                  ...MockDb.members.map(
                        (member) => ParticipantTile(
                      name: member.name,
                      status: member.mine ? '방장' : '입장 완료',
                      active: member.mine,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const InfoCard(
                    icon: Icons.chat_bubble_outline,
                    title: '카톡 링크 공유만 사용해요',
                    body: '채팅 없이 초대와 예산 제출 상태만 확인해요.',
                  ),
                  const SizedBox(height: AppSpacing.gap24),
                  PrimaryButton(label: '예산 입력 시작', onTap: onNext),
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