import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/app_radius.dart';
import 'package:beggar_app/core/theme/app_spacing.dart';
import 'package:beggar_app/core/utils/decorations.dart';
import 'package:beggar_app/shared/widgets/app_header.dart';
import 'package:beggar_app/shared/widgets/figma_frame.dart';

class CommunityChatScreen extends StatelessWidget {
  final VoidCallback onBack;

  const CommunityChatScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return FigmaFrame(
      child: Stack(
        children: [
          AppHeader.titled(title: '전체 채팅방', onBack: onBack),
          Positioned(
            top: AppSpacing.contentTop,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageH),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  _ChatNotice(),
                  SizedBox(height: 18),
                  _ChatBubble(
                    name: '절약왕',
                    message: '오늘 편의점 도시락 할인 정보 본 사람?',
                    time: '오후 2:13',
                  ),
                  _ChatBubble(
                    name: '거지판다',
                    message: 'CU 앱에서 쿠폰 같이 쓰면 6천원대로 가능하더라.',
                    time: '오후 2:14',
                    mine: true,
                  ),
                  _ChatBubble(
                    name: '소금커피',
                    message: '명학역 쪽 착한가격 업소도 괜찮았어.',
                    time: '오후 2:18',
                  ),
                  _ChatBubble(
                    name: '한푼두푼',
                    message: '게시판에 링크 올려줄게.',
                    time: '오후 2:20',
                  ),
                  SizedBox(height: AppSpacing.bottomSafe),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CommunityMessageBar extends StatefulWidget {
  const CommunityMessageBar({super.key});

  @override
  State<CommunityMessageBar> createState() => _CommunityMessageBarState();
}

class _CommunityMessageBarState extends State<CommunityMessageBar> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardBottom = MediaQuery.viewInsetsOf(context).bottom;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.only(bottom: keyboardBottom),
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: 92,
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 18),
            decoration: const BoxDecoration(
              color: Color(0xF2FFFFFF),
              border: Border(
                top: BorderSide(color: AppColors.border, width: 0.7),
              ),
            ),
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: softBox(radius: AppRadius.chip, shadow: true),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      textInputAction: TextInputAction.send,
                      cursorColor: AppColors.accent,
                      decoration: const InputDecoration(
                        hintText: '메시지 입력',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.placeholder,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  const Icon(Icons.send_outlined, color: AppColors.accent),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatNotice extends StatelessWidget {
  const _ChatNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: softBox(color: AppColors.accentBg, radius: AppRadius.card),
      child: const Text(
        '전체 사용자 128명이 참여 중이에요. 착한가격 업소, 쿠폰, 절약 루트를 자유롭게 공유해요.',
        style: TextStyle(
          fontSize: 13,
          height: 1.45,
          fontWeight: FontWeight.w700,
          color: AppColors.sub,
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final bool mine;

  const _ChatBubble({
    required this.name,
    required this.message,
    required this.time,
    this.mine = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 270),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: softBox(
          color: mine ? AppColors.accentBg : Colors.white,
          radius: AppRadius.card,
          shadow: !mine,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              time,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.lightSub,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
