import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';

class AppTextStyles {
  static const appBrand = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.7,
    color: AppColors.text,
  );
  static const pageTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.45,
    color: AppColors.text,
  );
  static const sectionHeading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w900,
    letterSpacing: -0.7,
    color: AppColors.text,
  );
  static const bodyStrong = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.darkSub,
  );
  static const bodySub = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.sub,
  );
}
