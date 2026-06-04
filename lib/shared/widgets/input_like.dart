import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/app_radius.dart';
import 'package:beggar_app/core/utils/decorations.dart';

class InputLike extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;

  const InputLike({
    super.key,
    required this.label,
    required this.icon,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.text : AppColors.placeholder;
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: softBox(radius: AppRadius.compact),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: -0.31,
            ),
          ),
          const Spacer(),
          Icon(icon, size: 24, color: color),
        ],
      ),
    );
  }
}
