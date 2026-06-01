import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';

class FigmaFrame extends StatelessWidget {
  static const double designWidth = 393;
  static const double designHeight = 852;
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
          final heightScale = availableHeight / designHeight;
          final scale = widthScale.clamp(0.0, heightScale).clamp(0.0, maxScale);
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
