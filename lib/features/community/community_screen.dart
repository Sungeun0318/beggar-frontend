import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/app_radius.dart';
import 'package:beggar_app/core/theme/app_spacing.dart';
import 'package:beggar_app/core/utils/decorations.dart';
import 'package:beggar_app/shared/widgets/app_header.dart';
import 'package:beggar_app/shared/widgets/figma_frame.dart';

import 'package:beggar_app/data/api/api_client.dart';
import 'package:beggar_app/data/models/room_free_post.dart';
import 'package:beggar_app/data/repositories/room_free_repository.dart';

class CommunityScreen extends StatefulWidget {
  final VoidCallback onOpenChat;
  final VoidCallback onOpenPost;
  final VoidCallback onWritePost;

  // 셸(PrototypeShell) 수정을 피하기 위해 정적 변수로 선택된 ID 공유
  static int selectedPostId = 1;

  const CommunityScreen({
    super.key,
    required this.onOpenChat,
    required this.onOpenPost,
    required this.onWritePost,
  });

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final _repository = RoomFreeRepository(ApiClient());
  List<RoomFreePost> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      final posts = await _repository.getPosts();
      if (mounted) {
        setState(() {
          _posts = posts;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('게시글을 불러오지 못했습니다: $e')),
        );
      }
    }
  }

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
            child: RefreshIndicator(
              onRefresh: _loadPosts,
              color: AppColors.accent,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.pageH),
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
                    _CommunityChatCard(onTap: widget.onOpenChat),
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
                          onTap: widget.onWritePost,
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
                    if (_isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (_posts.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Text('등록된 게시글이 없습니다.'),
                        ),
                      )
                    else
                      ..._posts.map((post) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _CommunityPostCard(
                              post: post,
                              onTap: () {
                                CommunityScreen.selectedPostId = post.id;
                                widget.onOpenPost();
                              },
                            ),
                          )),
                    const SizedBox(height: AppSpacing.bottomSafe),
                  ],
                ),
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
  final RoomFreePost post;
  final VoidCallback onTap;

  const _CommunityPostCard({
    required this.post,
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accentBg,
                borderRadius: BorderRadius.circular(AppRadius.chip),
              ),
              child: Text(
                post.tag,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.accent,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              post.title,
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
              post.content,
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
              '댓글 ${post.commentCount} · ${post.author} · ${_formatDate(post.createdAt)}',
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return '방금 전';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    return '${date.month}월 ${date.day}일';
  }
}
