import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/assets.dart';
import 'package:beggar_app/shared/widgets/figma_frame.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FigmaFrame(
      child: Stack(
        children: [
          // Header
          Positioned(
            top: 55,
            left: 24,
            right: 24,
            child: Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    Assets.logo,
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  '거지 우정 수호대',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.92,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ),
          // Title
          const Positioned(
            top: 119,
            left: 24,
            child: Text(
              '거지 랭킹',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.45,
                color: AppColors.text,
              ),
            ),
          ),
          // List
          Positioned.fill(
            top: 173,
            child: ListView.separated(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 120),
              itemCount: 15,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return ParticipantRow(
                  rank: index + 1,
                  name: index < 3 ? '박진감' : '거지가 아닙니다',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ParticipantRow extends StatelessWidget {
  final int rank;
  final String name;

  const ParticipantRow({
    super.key,
    required this.rank,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    Gradient? gradient;
    Color textColor = AppColors.text;
    Color? shadowColor;

    if (rank == 1) {
      gradient = const LinearGradient(
        colors: [Color(0xFFFFE7A2), Color(0xFFFFFBD0)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      textColor = Colors.white;
      shadowColor = Colors.black.withOpacity(0.25);
    } else if (rank == 2) {
      gradient = const LinearGradient(
        colors: [Color(0xFFF4F4F4), Color(0xFF8E8E8E)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );
      textColor = Colors.white;
      shadowColor = Colors.black.withOpacity(0.25);
    } else if (rank == 3) {
      gradient = const LinearGradient(
        colors: [Color(0xFFFFDBA9), Color(0xFFD0701B)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
      textColor = Colors.white;
      shadowColor = Colors.black.withOpacity(0.25);
    }

    return Container(
      height: 79,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: gradient == null ? Colors.white : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8D9D9), width: 0.65),
        boxShadow: [
          if (shadowColor != null)
            BoxShadow(
              color: shadowColor,
              blurRadius: 2,
              offset: const Offset(0, 4),
            )
          else
            const BoxShadow(
              color: Color(0x40000000),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              '$rank위',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: textColor,
                letterSpacing: -0.31,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.bg,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black45, width: 0.65),
            ),
            padding: const EdgeInsets.all(2),
            child: const CircleAvatar(
              backgroundColor: AppColors.canvas,
              child: Icon(Icons.person, color: AppColors.sub),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            name,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: textColor,
              letterSpacing: -0.23,
            ),
          ),
          const Spacer(),
          // Character/Icon placeholder
          Container(
            width: 80,
            height: 60,
            child: Icon(
              rank <= 3 ? Icons.emoji_events : Icons.face,
              size: 40,
              color: textColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
