import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/app_radius.dart';
import 'package:beggar_app/core/theme/app_spacing.dart';
import 'package:beggar_app/core/utils/decorations.dart';
import 'package:beggar_app/shared/widgets/app_header.dart';
import 'package:beggar_app/shared/widgets/figma_frame.dart';

class CommunityPostDetailScreen extends StatefulWidget {
  final VoidCallback onBack;

  const CommunityPostDetailScreen({super.key, required this.onBack});

  @override
  State<CommunityPostDetailScreen> createState() => _CommunityPostDetailScreenState();
}

class _CommunityPostDetailScreenState extends State<CommunityPostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

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
                bottom: 100, // 입력창 높이만큼 하단 여백 추가
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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildCommentInput(),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 34),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(AppRadius.card),
              ),
              child: TextField(
                controller: _commentController,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
                decoration: const InputDecoration(
                  hintText: '댓글을 입력하세요...',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: AppColors.lightSub,
                    fontWeight: FontWeight.w600,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onPressed: () {
              if (_commentController.text.isNotEmpty) {
                // TODO: 댓글 전송 로직 구현
                _commentController.clear();
              }
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
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
