import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/app_radius.dart';

class ChipLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const ChipLabel({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: Border.all(color: AppColors.muted, width: 0.7),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: AppColors.accent),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.sub,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
