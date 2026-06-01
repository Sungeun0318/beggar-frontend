import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';

class BottomNav extends StatelessWidget {
  final int activeIndex;
  final VoidCallback onHome;
  final VoidCallback onCommunity;
  final VoidCallback onRanking;
  final VoidCallback onMy;

  const BottomNav({
    super.key,
    required this.activeIndex,
    required this.onHome,
    required this.onCommunity,
    required this.onRanking,
    required this.onMy,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: 92,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xF2FFFFFF),
          border: Border(top: BorderSide(color: AppColors.border, width: 0.7)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavItem(
              icon: Icons.home_outlined,
              label: '홈',
              active: activeIndex == 0,
              onTap: onHome,
            ),
            NavItem(
              icon: Icons.forum_outlined,
              label: '커뮤니티',
              active: activeIndex == 1,
              onTap: onCommunity,
            ),
            NavItem(
              icon: Icons.emoji_events_outlined,
              label: '랭킹',
              active: activeIndex == 2,
              onTap: onRanking,
            ),
            NavItem(
              icon: Icons.person_outline,
              label: '마이',
              active: activeIndex == 3,
              onTap: onMy,
            ),
          ],
        ),
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.text : AppColors.lightSub;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 58,
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            children: [
              Icon(icon, size: 26, color: color),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
