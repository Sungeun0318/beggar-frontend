import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/app_radius.dart';
import 'package:beggar_app/core/theme/app_spacing.dart';
import 'package:beggar_app/core/utils/decorations.dart';
import 'package:beggar_app/shared/widgets/app_header.dart';
import 'package:beggar_app/shared/widgets/figma_frame.dart';

class CommunityScreen extends StatelessWidget {
  final VoidCallback onOpenChat;
  final VoidCallback onOpenPost;
  final VoidCallback onWritePost;

  const CommunityScreen({
    super.key,
    required this.onOpenChat,
    required this.onOpenPost,
    required this.onWritePost,
  });

  @override
  Widget build(BuildContext context) {
    return FigmaFrame(
      child: Stack(
        children: [
          const AppHeader.brand(title: '커뮤니티', showNotification: true),
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
                  const Text(
                    '모든 사용자들과 절약 팁과 모임 이야기를 나눠요.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.sub,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const _SearchBox(),
                  const SizedBox(height: 18),
                  _CommunityChatCard(onTap: onOpenChat),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      const Text(
                        '게시판',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: onWritePost,
                        behavior: HitTestBehavior.opaque,
                        child: const Row(
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              size: 18,
                              color: AppColors.accent,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '글쓰기',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const _BoardTabs(),
                  const SizedBox(height: 14),
                  _CommunityPostCard(
                    tag: '절약팁',
                    title: '오늘 점심 8천원 이하 맛집 공유해요',
                    body: '강남역 근처에서 가성비 괜찮았던 곳 있으면 같이 추천해봐요.',
                    meta: '댓글 12 · 방금 전',
                    onTap: onOpenPost,
                  ),
                  const SizedBox(height: 14),
                  _CommunityPostCard(
                    tag: '질문',
                    title: '데이트 예산 3만원이면 어떻게 짜?',
                    body: '밥이랑 카페까지 가고 싶은데 괜찮은 루트 있으면 알려줘.',
                    meta: '댓글 8 · 9분 전',
                    onTap: onOpenPost,
                  ),
                  const SizedBox(height: 14),
                  _CommunityPostCard(
                    tag: '같이해요',
                    title: '이번 주말 홍대 근처 절약 모임',
                    body: '카페 대신 무료 전시 보고 산책하는 코스로 생각 중이에요.',
                    meta: '댓글 5 · 18분 전',
                    onTap: onOpenPost,
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

class _SearchBox extends StatelessWidget {
  const _SearchBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: softBox(radius: AppRadius.compact),
      child: const Row(
        children: [
          Icon(Icons.search, color: AppColors.placeholder, size: 22),
          SizedBox(width: 10),
          Text(
            '게시글, 채팅 검색',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.placeholder,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CommunityChatCard extends StatelessWidget {
  final VoidCallback onTap;

  const _CommunityChatCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        height: 104,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: softBox(color: AppColors.accentBg, radius: AppRadius.card),
        child: const Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white,
              child: Icon(Icons.forum_outlined, color: AppColors.accent),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '전체 채팅방',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '지금 128명이 절약 이야기를 나누는 중',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.sub,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.brown),
          ],
        ),
      ),
    );
  }
}

class _BoardTabs extends StatelessWidget {
  const _BoardTabs();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _BoardTab(label: '인기글', active: true)),
        SizedBox(width: 7),
        Expanded(child: _BoardTab(label: '최신글')),
        SizedBox(width: 7),
        Expanded(child: _BoardTab(label: '절약팁')),
        SizedBox(width: 7),
        Expanded(child: _BoardTab(label: '질문')),
      ],
    );
  }
}

class _BoardTab extends StatelessWidget {
  final String label;
  final bool active;

  const _BoardTab({required this.label, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active ? AppColors.accent : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: Border.all(color: active ? AppColors.accent : AppColors.border),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: active ? Colors.white : AppColors.sub,
        ),
      ),
    );
  }
}

class _CommunityPostCard extends StatelessWidget {
  final String tag;
  final String title;
  final String body;
  final String meta;
  final VoidCallback onTap;

  const _CommunityPostCard({
    required this.tag,
    required this.title,
    required this.body,
    required this.meta,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        height: 170,
        padding: const EdgeInsets.all(18),
        decoration: softBox(radius: AppRadius.card, shadow: true),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 62,
              height: 26,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.accentBg,
                borderRadius: BorderRadius.circular(AppRadius.chip),
              ),
              child: Text(
                tag,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.accent,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.text,
                letterSpacing: -0.4,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                fontWeight: FontWeight.w600,
                color: AppColors.sub,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Text(
              meta,
              style: const TextStyle(
                fontSize: 12,
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
