import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/app_radius.dart';
import 'package:beggar_app/core/theme/app_spacing.dart';
import 'package:beggar_app/core/utils/decorations.dart';
import 'package:beggar_app/shared/widgets/app_header.dart';
import 'package:beggar_app/shared/widgets/figma_frame.dart';
import 'package:beggar_app/shared/widgets/primary_button.dart';

import 'package:beggar_app/data/api/api_client.dart';
import 'package:beggar_app/data/repositories/room_free_repository.dart';

class CommunityPostWriteScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  const CommunityPostWriteScreen({
    super.key,
    required this.onBack,
    required this.onSubmit,
  });

  @override
  State<CommunityPostWriteScreen> createState() => _CommunityPostWriteScreenState();
}

class _CommunityPostWriteScreenState extends State<CommunityPostWriteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _repository = RoomFreeRepository(ApiClient());
  String _selectedTag = '절약팁';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목과 내용을 입력해주세요.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await _repository.createPost(
        title: title,
        content: content,
        tag: _selectedTag,
      );
      widget.onSubmit();
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('게시글 등록 실패: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FigmaFrame(
      child: Stack(
        children: [
          AppHeader.titled(title: '글쓰기', onBack: widget.onBack),
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
                  _CategorySelector(
                    selectedTag: _selectedTag,
                    onSelected: (tag) => setState(() => _selectedTag = tag),
                  ),
                  const SizedBox(height: 16),
                  _InputBox(
                    label: '제목',
                    controller: _titleController,
                    hint: '제목을 입력해주세요',
                    height: 92,
                  ),
                  const SizedBox(height: 14),
                  _InputBox(
                    label: '내용',
                    controller: _contentController,
                    hint: '가성비 좋은 식당이나 쿠폰 조합을 공유해보세요.',
                    height: 204,
                    multiline: true,
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    label: _isSubmitting ? '게시 중...' : '게시하기',
                    onTap: () => _handleSubmit(),
                    enabled: !_isSubmitting,
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

class _CategorySelector extends StatelessWidget {
  final String selectedTag;
  final ValueChanged<String> onSelected;

  const _CategorySelector({
    required this.selectedTag,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _CategoryChip(
            label: '절약팁',
            active: selectedTag == '절약팁',
            onTap: () => onSelected('절약팁'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _CategoryChip(
            label: '질문',
            active: selectedTag == '질문',
            onTap: () => onSelected('질문'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _CategoryChip(
            label: '같이해요',
            active: selectedTag == '같이해요',
            onTap: () => onSelected('같이해요'),
          ),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.accent : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.chip),
          border:
              Border.all(color: active ? AppColors.accent : AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: active ? Colors.white : AppColors.sub,
          ),
        ),
      ),
    );
  }
}

class _InputBox extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final double height;
  final bool multiline;

  const _InputBox({
    required this.label,
    required this.controller,
    required this.hint,
    this.height = 84,
    this.multiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: softBox(radius: AppRadius.compact),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.lightSub,
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: multiline ? 10 : 1,
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.placeholder,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
