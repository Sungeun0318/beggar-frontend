import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/utils/decorations.dart';

class ChoiceBox extends StatelessWidget {
  final IconData icon;
  final String label;

  const ChoiceBox({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: softBox(radius: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: AppColors.brown),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.sub,
            ),
          ),
        ],
      ),
    );
  }
}
