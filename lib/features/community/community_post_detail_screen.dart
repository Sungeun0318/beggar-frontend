import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/app_radius.dart';
import 'package:beggar_app/core/theme/app_spacing.dart';
import 'package:beggar_app/core/utils/decorations.dart';
import 'package:beggar_app/shared/widgets/app_header.dart';
import 'package:beggar_app/shared/widgets/figma_frame.dart';

import 'package:beggar_app/data/api/api_client.dart';
import 'package:beggar_app/data/repositories/room_free_repository.dart';
import 'package:beggar_app/data/models/room_free_post.dart';
import 'package:beggar_app/features/community/community_screen.dart';

class CommunityPostDetailScreen extends StatefulWidget {
  final VoidCallback onBack;
  final int? postId; // null이면 CommunityScreen.selectedPostId 사용

  const CommunityPostDetailScreen({
    super.key,
    required this.onBack,
    this.postId,
  });

  @override
  State<CommunityPostDetailScreen> createState() => _CommunityPostDetailScreenState();
}

class _CommunityPostDetailScreenState extends State<CommunityPostDetailScreen> {
  final _repository = RoomFreeRepository(ApiClient());
  RoomFreePostDetail? _detail;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    final id = widget.postId ?? CommunityScreen.selectedPostId;
    try {
      final detail = await _repository.getPostDetail(id);
      if (mounted) {
        setState(() {
          _detail = detail;
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
    final post = _detail;

    return FigmaFrame(
      child: Stack(
        children: [
          AppHeader.titled(title: '게시글', onBack: widget.onBack),
          Positioned(
            top: AppSpacing.contentTop,
            left: 0,
            right: 0,
            bottom: 0,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : post == null
                    ? const Center(child: Text('게시글을 찾을 수 없습니다.'))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.only(
                          left: AppSpacing.pageH,
                          right: AppSpacing.pageH,
                          bottom: 120, // 입력창 높이 고려
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _PostBody(post: post),
                            const SizedBox(height: 22),
                            Text(
                              '댓글 ${post.comments.length}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.text,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...post.comments.map((comment) => _Comment(
                                  name: comment.author,
                                  body: comment.content,
                                  time: _formatDate(comment.createdAt),
                                )),
                            const SizedBox(height: AppSpacing.bottomSafe),
                          ],
                        ),
                      ),
          ),
          if (!_isLoading && post != null)
            CommunityCommentBar(
              postId: post.id,
              onSuccess: _loadDetail,
            ),
        ],
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

class CommunityCommentBar extends StatefulWidget {
  final int postId;
  final VoidCallback? onSuccess;

  const CommunityCommentBar({
    super.key,
    required this.postId,
    this.onSuccess,
  });

  @override
  State<CommunityCommentBar> createState() => _CommunityCommentBarState();
}

class _CommunityCommentBarState extends State<CommunityCommentBar> {
  final TextEditingController _commentController = TextEditingController();
  final RoomFreeRepository _repository = RoomFreeRepository(ApiClient());
  bool _isSending = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _sendComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty || _isSending) return;

    setState(() => _isSending = true);
    try {
      await _repository.createComment(widget.postId, content);
      if (!mounted) return;
      _commentController.clear();
      setState(() => _isSending = false);
      if (widget.onSuccess != null) {
        widget.onSuccess!();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('댓글이 등록되었습니다.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSending = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('전송 실패: $e')),
      );
    }
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
                      controller: _commentController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendComment(),
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
                    onPressed: _isSending ? null : () => _sendComment(),
                    icon: Icon(
                      Icons.send_outlined,
                      color: _isSending ? AppColors.placeholder : AppColors.accent,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PostBody extends StatelessWidget {
  final RoomFreePost post;
  const _PostBody({required this.post});

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
            child: Text(
              post.tag,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.accent,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            post.title,
            style: const TextStyle(
              fontSize: 22,
              height: 1.25,
              fontWeight: FontWeight.w900,
              color: AppColors.text,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${post.author} · ${_formatTime(post.createdAt)}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.lightSub,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            post.content,
            style: const TextStyle(
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

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return '방금 전';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    return '${date.month}/${date.day}';
  }
}

class _Comment extends StatelessWidget {
  final String name;
  final String body;
  final String time;

  const _Comment({
    required this.name,
    required this.body,
    required this.time,
  });

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text,
                      ),
                    ),
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
