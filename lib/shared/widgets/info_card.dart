import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/app_radius.dart';
import 'package:beggar_app/core/utils/decorations.dart';

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? body;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: body == null ? 67 : 107,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: softBox(color: AppColors.accentBg, radius: AppRadius.compact),
      child: Row(
        children: [
          CircleAvatar(
            radius: body == null ? 17 : 19,
            backgroundColor: Colors.white,
            child: Icon(
              icon,
              color: AppColors.accent,
              size: body == null ? 17 : 20,
            ),
          ),
          const SizedBox(width: 13),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.55,
                ),
              ),
              if (body != null) ...[
                const SizedBox(height: 6),
                Text(
                  body!,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.38,
                    color: AppColors.sub,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
