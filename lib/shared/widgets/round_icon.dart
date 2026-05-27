import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';

class RoundIcon extends StatelessWidget {
  final IconData icon;

  const RoundIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColors.muted,
      child: Icon(icon, size: 22, color: AppColors.sub),
    );
  }
}
