import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';

class FlowStep extends StatelessWidget {
  final String index;
  final String title;
  final String body;

  const FlowStep({
    super.key,
    required this.index,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white,
            child: Text(
              index,
              style: const TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  body,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.sub,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
