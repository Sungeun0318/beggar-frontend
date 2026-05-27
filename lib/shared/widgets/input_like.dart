import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/utils/decorations.dart';

class InputLike extends StatelessWidget {
  final String label;
  final IconData icon;

  const InputLike({super.key, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: softBox(radius: 16),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.placeholder,
              letterSpacing: -0.31,
            ),
          ),
          const Spacer(),
          Icon(icon, size: 24, color: AppColors.placeholder),
        ],
      ),
    );
  }
}
