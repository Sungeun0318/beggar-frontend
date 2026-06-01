import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/app_spacing.dart';
import 'package:beggar_app/core/theme/app_text_styles.dart';
import 'package:beggar_app/core/theme/assets.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final bool showNotification;
  final VoidCallback? onNotification;
  final bool _centerTitle;

  const AppHeader.brand({
    super.key,
    this.title = '거지 우정 수호대',
    this.onBack,
    this.showNotification = true,
    this.onNotification,
  }) : _centerTitle = false;

  const AppHeader.titled({
    super.key,
    required this.title,
    required VoidCallback this.onBack,
  }) : showNotification = false,
       onNotification = null,
       _centerTitle = true;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: AppSpacing.headerTop - 16,
      left: AppSpacing.pageH,
      right: AppSpacing.pageH,
      height: AppSpacing.headerHeight,
      child: _centerTitle
          ? _TitledHeader(title: title, onBack: onBack!)
          : _BrandHeader(
              title: title,
              onBack: onBack,
              showNotification: showNotification,
              onNotification: onNotification,
            ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final bool showNotification;
  final VoidCallback? onNotification;

  const _BrandHeader({
    required this.title,
    required this.onBack,
    required this.showNotification,
    required this.onNotification,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onBack != null) ...[
          _HeaderIconButton(
            onPressed: onBack,
            icon: Icons.chevron_left,
            size: 30,
          ),
          const SizedBox(width: 6),
        ],
        ClipOval(
          child: Image.asset(
            Assets.logo,
            width: 44,
            height: 44,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.sectionHeading.copyWith(fontSize: 25),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(
          width: 40,
          child: showNotification
              ? _HeaderIconButton(
                  onPressed: onNotification,
                  icon: Icons.notifications_none,
                  size: 24,
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _TitledHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const _TitledHeader({required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: _HeaderIconButton(
            onPressed: onBack,
            icon: Icons.chevron_left,
            size: 30,
          ),
        ),
        Text(title, style: AppTextStyles.sectionHeading.copyWith(fontSize: 21)),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final double size;

  const _HeaderIconButton({
    required this.onPressed,
    required this.icon,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: size, color: AppColors.text),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 40, height: 40),
    );
  }
}
