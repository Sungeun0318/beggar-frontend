import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/app_radius.dart';
import 'package:beggar_app/core/theme/app_spacing.dart';
import 'package:beggar_app/core/utils/decorations.dart';
import 'package:beggar_app/shared/widgets/app_header.dart';
import 'package:beggar_app/shared/widgets/figma_frame.dart';

import 'package:beggar_app/data/api/api_client.dart';
import 'package:beggar_app/data/repositories/room_free_repository.dart';

class CommunityPostDetailScreen extends StatefulWidget {
  final VoidCallback onBack;
  final int postId; // 게시글 ID 추가

  const CommunityPostDetailScreen({
    super.key,
    required this.onBack,
    this.postId = 1, // 프로토타입용 기본값
  });

  @override
  State<CommunityPostDetailScreen> createState() => _CommunityPostDetailScreenState();
}

class _CommunityPostDetailScreenState extends State<CommunityPostDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return FigmaFrame(
      child: Stack(
        children: [
          AppHeader.titled(title: '게시글', onBack: widget.onBack),
          Positioned(
            top: AppSpacing.contentTop,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: AppSpacing.pageH,
                right: AppSpacing.pageH,
                bottom: 120, // 입력창 높이 고려
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _PostBody(),
                  SizedBox(height: 22),
                  Text(
                    '댓글 12',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text,
                    ),
                  ),
                  SizedBox(height: 12),
                  _Comment(name: '소금커피', body: '역삼 쪽 착한가격 업소 하나 있는데 링크 찾아볼게.'),
                  _Comment(name: '거지판다', body: '나는 김밥집 + 카페 쿠폰 조합 추천.'),
                  _Comment(name: '절약왕', body: '점심이면 백반집이 제일 안정적이긴 해.'),
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

class CommunityCommentBar extends StatefulWidget {
  final int postId;

  const CommunityCommentBar({super.key, this.postId = 1});

  @override
  State<CommunityCommentBar> createState() => _CommunityCommentBarState();
}

class _CommunityCommentBarState extends State<CommunityCommentBar> {
  final TextEditingController _commentController = TextEditingController();
  final RoomFreeRepository _repository = RoomFreeRepository(ApiClient());

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _sendComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    try {
      await _repository.createComment(widget.postId, content);
      if (!mounted) return;
      _commentController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('댓글이 등록되었습니다.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('전송 실패: $e')),
      );
    }
  }

  Widget _buildCommentInput() {
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
          child: _CommentInputSurface(
            controller: _commentController,
            onSend: _sendComment,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => _buildCommentInput();
}

class _CommentInputSurface extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _CommentInputSurface({
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 18),
      decoration: BoxDecoration(
        color: const Color(0xF2FFFFFF),
        border: const Border(
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
                controller: controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                cursorColor: AppColors.accent,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
                decoration: const InputDecoration(
                  hintText: '댓글 입력',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: AppColors.placeholder,
                    fontWeight: FontWeight.w700,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            IconButton(
              onPressed: onSend,
              icon: const Icon(
                Icons.send_outlined,
                color: AppColors.accent,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostBody extends StatelessWidget {
  const _PostBody();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: softBox(radius: AppRadius.card, shadow: true),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.accentBg,
              borderRadius: BorderRadius.circular(AppRadius.chip),
            ),
            child: const Text(
              '절약팁',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.accent,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '오늘 점심 8천원 이하 맛집 공유해요',
            style: TextStyle(
              fontSize: 22,
              height: 1.25,
              fontWeight: FontWeight.w900,
              color: AppColors.text,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '거지판다 · 방금 전',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.lightSub,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            '강남역 근처에서 가성비 괜찮았던 곳 있으면 같이 추천해봐요. 착한가격 업소 기준이면 더 좋고, 쿠폰 조합도 괜찮아요.',
            style: TextStyle(
              fontSize: 15,
              height: 1.55,
              fontWeight: FontWeight.w600,
              color: AppColors.sub,
            ),
          ),
        ],
      ),
    );
  }
}

class _Comment extends StatelessWidget {
  final String name;
  final String body;

  const _Comment({required this.name, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: softBox(radius: AppRadius.card),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 17,
            backgroundColor: AppColors.accentBg,
            child: Icon(
              Icons.person_outline,
              size: 18,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  body,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                    color: AppColors.sub,
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
