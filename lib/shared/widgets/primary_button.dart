import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool enabled;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          gradient: enabled ? AppColors.goldGradient : null,
          color: enabled ? null : AppColors.border,
          borderRadius: BorderRadius.circular(20),
          boxShadow: enabled
              ? const [
                  BoxShadow(
                    color: Color(0x40D4AF37),
                    blurRadius: 10,
                    offset: Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: enabled ? Colors.white : AppColors.lightSub,
              letterSpacing: -0.31,
            ),
          ),
        ),
      ),
    );
  }
}
