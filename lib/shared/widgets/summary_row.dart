import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/app_radius.dart';
import 'package:beggar_app/core/utils/decorations.dart';

class SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final Color bg;

  const SummaryRow({
    super.key,
    required this.icon,
    required this.label,
    this.trailing,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: softBox(radius: AppRadius.card),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: bg,
            child: Icon(
              icon,
              size: 17,
              color: trailing == null
                  ? const Color(0xFF5B6DFF)
                  : AppColors.accent,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.23,
            ),
          ),
          const Spacer(),
          if (trailing != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.muted,
                borderRadius: BorderRadius.circular(AppRadius.chip),
              ),
              child: Text(
                trailing!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.sub,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
