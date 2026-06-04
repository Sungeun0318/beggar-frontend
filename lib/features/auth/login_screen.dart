import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/app_radius.dart';
import 'package:beggar_app/core/theme/assets.dart';
import 'package:beggar_app/core/utils/decorations.dart';
import 'package:beggar_app/data/repositories/auth_repository.dart';
import 'package:beggar_app/shared/widgets/figma_frame.dart';
import 'package:beggar_app/shared/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLogin;
  final VoidCallback onSignup;

  const LoginScreen({super.key, required this.onLogin, required this.onSignup});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthRepository _authRepository = AuthRepository();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_isLoading) return;
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      _showSnack('이메일과 비밀번호를 입력해줘.');
      return;
    }

    setState(() {
      _isLoading = true;
    });
    try {
      await _authRepository.signInWithEmail(email: email, password: password);
      if (!mounted) return;
      widget.onLogin();
    } catch (error) {
      _showSnack(error.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loginWithKakao() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    try {
      await _authRepository.signInWithKakao();
      if (!mounted) return;
      widget.onLogin();
    } catch (error) {
      _showSnack(error.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return FigmaFrame(
      child: Stack(
        children: [
          Positioned(
            top: 104,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    Assets.logo,
                    width: 104,
                    height: 104,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  '거지 우정 수호대',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '친구의 자존심을 지키는 익명 예산 조율',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: AppColors.sub,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 34),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: softBox(radius: AppRadius.card),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '일반 로그인',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _AuthTextField(
                        controller: _emailController,
                        hintText: '이메일',
                        icon: Icons.mail_outline,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),
                      _AuthTextField(
                        controller: _passwordController,
                        hintText: '비밀번호',
                        icon: Icons.lock_outline,
                        obscureText: true,
                      ),
                      const SizedBox(height: 12),
                      PrimaryButton(
                        label: _isLoading ? '로그인 중...' : '로그인',
                        onTap: _login,
                        enabled: !_isLoading,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: Column(
              children: [
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.kakaoYellow,
                    borderRadius: BorderRadius.circular(AppRadius.card),
                  ),
                  child: GestureDetector(
                    onTap: _isLoading ? null : _loginWithKakao,
                    child: const Center(
                      child: Text(
                        '카카오로 시작하기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2C241B),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextButton(
                  onPressed: widget.onSignup,
                  child: const Text(
                    '아직 계정이 없나요? 회원가입',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.sub,
                      fontWeight: FontWeight.w800,
                    ),
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

class _AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;

  const _AuthTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: AppColors.placeholder),
        filled: true,
        fillColor: AppColors.bg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.compact),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
