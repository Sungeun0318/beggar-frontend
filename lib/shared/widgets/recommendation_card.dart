import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/utils/decorations.dart';

class RecommendationCard extends StatelessWidget {
  final String image;
  final String tag;
  final String title;
  final String walk;
  final String rating;
  final String amount;
  final Color tagBg;
  final Color tagColor;

  const RecommendationCard({
    super.key,
    required this.image,
    required this.tag,
    required this.title,
    required this.walk,
    required this.rating,
    required this.amount,
    required this.tagBg,
    required this.tagColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 148,
      padding: const EdgeInsets.all(14),
      decoration: softBox(radius: 20),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              image,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: tagBg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: tagColor,
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.7,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.bg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.muted),
                      ),
                      child: Text(
                        walk,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.lightSub,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      rating,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.sub,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5A4F43),
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
