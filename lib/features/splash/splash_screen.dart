import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/assets.dart';
import 'package:beggar_app/shared/widgets/figma_frame.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onDone;

  const SplashScreen({super.key, required this.onDone});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (mounted) widget.onDone();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FigmaFrame(
      height: 930,
      child: Stack(
        children: [
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Assets.logo,
                  width: 118,
                  height: 118,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24),
                const Text(
                  '거지 우정 수호대',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.7,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Save My Friendship',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.sub,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 42),
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 42,
            child: Text(
              '익명 예산 조율을 준비하고 있어요',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.lightSub,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
