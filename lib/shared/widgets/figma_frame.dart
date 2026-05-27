import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';

class FigmaFrame extends StatelessWidget {
  static const double designWidth = 393;
  static const double maxScale = 1.06;

  final Widget child;
  final double height;

  const FigmaFrame({super.key, required this.child, this.height = 852});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final safeBottom = MediaQuery.paddingOf(context).bottom;
          final safeTop = MediaQuery.paddingOf(context).top;
          final availableHeight = constraints.maxHeight - safeTop - safeBottom;
          final widthScale = constraints.maxWidth / designWidth;
          final heightScale = availableHeight / height;
          final scale = height > 852
              ? widthScale.clamp(0.0, maxScale)
              : widthScale.clamp(0.0, heightScale).clamp(0.0, maxScale);
          final scaledHeight = height * scale;

          return SingleChildScrollView(
            physics: scaledHeight > availableHeight
                ? const BouncingScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            child: SizedBox(
              width: constraints.maxWidth,
              height: scaledHeight < availableHeight
                  ? availableHeight
                  : scaledHeight,
              child: Padding(
                padding: EdgeInsets.only(top: safeTop * 0.45),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: designWidth * scale,
                    height: scaledHeight,
                    child: Transform.scale(
                      scale: scale,
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: designWidth,
                        height: height,
                        child: Stack(children: [Positioned.fill(child: child)]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class StatusRow extends StatelessWidget {
  const StatusRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class ScreenHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const ScreenHeader({super.key, required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 55,
      left: 8,
      right: 8,
      height: 42,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: onBack,
              icon: const Icon(
                Icons.chevron_left,
                size: 30,
                color: AppColors.text,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.43,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
