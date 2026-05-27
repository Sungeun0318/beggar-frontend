import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/shared/widgets/figma_frame.dart';

class PlaceholderTabScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final String body;

  const PlaceholderTabScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return FigmaFrame(
      child: Stack(
        children: [
          Positioned(
            top: 80,
            left: 24,
            right: 24,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.accentBg,
                  child: Icon(icon, color: AppColors.accent, size: 34),
                ),
                const SizedBox(height: 22),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  body,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.sub,
                    fontWeight: FontWeight.w600,
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
