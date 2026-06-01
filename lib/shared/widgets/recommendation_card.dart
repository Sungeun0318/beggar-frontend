import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/app_radius.dart';
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
  final VoidCallback? onMapTap;

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
    this.onMapTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onMapTap,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Container(
        height: 146,
        padding: const EdgeInsets.all(12),
        decoration: softBox(radius: AppRadius.card),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.compact),
                  child: Image.asset(
                    image,
                    width: 94,
                    height: 94,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
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
                          borderRadius: BorderRadius.circular(AppRadius.chip),
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
                      Padding(
                        padding: const EdgeInsets.only(right: 48),
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              rating,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.darkSub,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            amount,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Text(
                        walk,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.lightSub,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: const BoxDecoration(
                  color: AppColors.kakaoYellow,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(AppRadius.card),
                    bottomLeft: Radius.circular(AppRadius.compact),
                  ),
                ),
                child: const Text(
                  '착한가격업소',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.brown,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
