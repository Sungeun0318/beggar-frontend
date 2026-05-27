import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/utils/decorations.dart';
import 'package:beggar_app/core/utils/formatters.dart';

class RoomHomeCard extends StatelessWidget {
  final String title;
  final String location;
  final int budget;
  final int spent;
  final int memberCount;
  final String status;
  final VoidCallback onTap;

  const RoomHomeCard({
    super.key,
    required this.title,
    required this.location,
    required this.budget,
    required this.spent,
    required this.memberCount,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = spent / budget;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 158,
        padding: const EdgeInsets.all(18),
        decoration: softBox(radius: 22, shadow: true),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentBg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.accent,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '$location · $memberCount명',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.sub,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  '${money(spent)}원 사용',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                  ),
                ),
                const Spacer(),
                Text(
                  '총 ${money(budget)}원',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.lightSub,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 8,
                backgroundColor: AppColors.muted,
                valueColor: const AlwaysStoppedAnimation(AppColors.accent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
