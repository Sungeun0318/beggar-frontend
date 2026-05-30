import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/app_radius.dart';
import 'package:beggar_app/core/utils/decorations.dart';
import 'package:beggar_app/shared/widgets/chip_label.dart';

class ReceiptCard extends StatelessWidget {
  final String date;
  final String room;
  final String image;
  final String title;
  final String amount;

  const ReceiptCard({
    super.key,
    required this.date,
    required this.room,
    required this.image,
    required this.title,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 146,
      padding: const EdgeInsets.all(17),
      decoration: softBox(radius: AppRadius.card),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.lightSub,
                ),
              ),
              const Spacer(),
              ChipLabel(icon: Icons.group_outlined, label: room),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: AppColors.muted),
          const SizedBox(height: 12),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.compact),
                child: Image.asset(
                  image,
                  width: 54,
                  height: 54,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.7,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    amount,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.danger,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
