import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/app_radius.dart';
import 'package:beggar_app/core/utils/decorations.dart';

class ParticipantTile extends StatelessWidget {
  static const _avatarRadius = 18.0;

  final String name;
  final String status;
  final bool active;

  const ParticipantTile({
    super.key,
    required this.name,
    required this.status,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: softBox(radius: AppRadius.compact),
      child: Row(
        children: [
          CircleAvatar(
            radius: _avatarRadius,
            backgroundColor: active ? AppColors.accentBg : AppColors.bg,
            child: Icon(
              Icons.person_outline,
              color: active ? AppColors.accent : AppColors.lightSub,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            name,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          Text(
            status,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: active ? AppColors.accent : AppColors.sub,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            active ? Icons.hourglass_empty : Icons.check_circle_outline,
            size: 18,
            color: active ? AppColors.accent : AppColors.sub,
          ),
        ],
      ),
    );
  }
}
