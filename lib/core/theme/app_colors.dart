import 'package:flutter/material.dart';

class AppColors {
  static const bg = Color(0xFFFDFBF7);
  static const canvas = Color(0xFFF3EFE6);
  static const text = Color(0xFF2C241B);
  static const darkSub = Color(0xFF5A4F43);
  static const sub = Color(0xFF8C7E6A);
  static const lightSub = Color(0xFFA69986);
  static const placeholder = Color(0xFFC4B8A5);
  static const border = Color(0xFFE8E3D9);
  static const muted = Color(0xFFF3EFE6);
  static const accent = Color(0xFFD4AF37);
  static const brown = Color(0xFFC69C6D);
  static const danger = Color(0xFFD9734C);
  static const accentBg = Color(0xFFFFF9F0);
  static const kakaoYellow = Color(0xFFFEE500);
  static const tagBgFood = Color(0xFFFFEADD);
  static const tagBgCafe = Color(0xFFFFF2D1);
  static const tagFgCafe = Color(0xFFB88B2D);
  static const tagBgPlay = Color(0xFFEAE4FE);
  static const tagFgPlay = Color(0xFF8B6CE0);
  static const sparkleYellow = Color(0xFFE9C867);
  static const sparkleOrange = Color(0xFFF0A282);
  static const sparklePurple = Color(0xFFB994F2);

  static const goldGradient = LinearGradient(colors: [accent, brown]);
  static const medalGold = LinearGradient(
    colors: [Color(0xFFFFE7A2), Color(0xFFFFFBD0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const medalSilver = LinearGradient(
    colors: [Color(0xFFF4F4F4), Color(0xFF8E8E8E)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const medalBronze = LinearGradient(
    colors: [Color(0xFFFFDBA9), Color(0xFFD0701B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
