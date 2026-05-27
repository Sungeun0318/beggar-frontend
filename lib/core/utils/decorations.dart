import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';

BoxDecoration softBox({
  Color color = Colors.white,
  double radius = 16,
  bool shadow = false,
}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(
      color: color == Colors.white ? AppColors.border : const Color(0xFFF0E6D5),
      width: 0.7,
    ),
    boxShadow: [
      if (shadow)
        const BoxShadow(
          color: Color(0x14000000),
          blurRadius: 30,
          offset: Offset(0, 8),
        ),
      const BoxShadow(
        color: Color(0x05000000),
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ],
  );
}
