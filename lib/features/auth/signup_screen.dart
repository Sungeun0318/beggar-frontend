import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/theme/app_radius.dart';
import 'package:beggar_app/core/theme/app_spacing.dart';
import 'package:beggar_app/data/repositories/auth_repository.dart';
import 'package:beggar_app/shared/widgets/app_header.dart';
import 'package:beggar_app/shared/widgets/figma_frame.dart';
import 'package:beggar_app/shared/widgets/info_card.dart';
import 'package:beggar_app/shared/widgets/primary_button.dart';
import 'package:beggar_app/shared/widgets/section_title.dart';

class SignupScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onComplete;

  const SignupScreen({
    super.key,
    required this.onBack,
    required this.onComplete,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  static const List<({String label, String value})> _ageRanges = [
    (label: '10대', value: '10~19'),
    (label: '20대', value: '20~29'),
    (label: '30대', value: '30~39'),
    (label: '40대', value: '40~49'),
    (label: '50대 이상', value: '50~'),
  ];

  final AuthRepository _authRepository = AuthRepository();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  int? _selectedGender;
  String? _selectedAgeRange;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nicknameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;
    final nickname = _nicknameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (nickname.isEmpty || email.isEmpty || password.isEmpty) {
      _showSnack('닉네임, 이메일, 비밀번호를 입력해줘.');
      return;
    }
    if (_selectedAgeRange == null) {
      _showSnack('연령대를 선택해줘.');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });
    try {
      await _authRepository.signUp(
        email: email,
        password: password,
        nickname: nickname,
        ageRange: _selectedAgeRange!,
        gender: _selectedGender,
      );
      if (!mounted) return;
      _showSnack('회원가입이 완료됐어. 로그인해줘.');
      widget.onComplete();
    } catch (error) {
      _showSnack(error.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
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
      height: 930,
      child: Stack(
        children: [
          AppHeader.titled(title: '회원가입', onBack: widget.onBack),
          Positioned(
            top: AppSpacing.contentTop,
            left: AppSpacing.pageH,
            right: AppSpacing.pageH,
            bottom: 0,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: AppSpacing.bottomSafe),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '처음 오셨나요?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.7,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '연령대는 추천 품질 개선에만 사용돼.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: AppColors.sub,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const SectionTitle('기본 정보'),
                  const SizedBox(height: 13),
                  _SignupTextField(
                    controller: _nicknameController,
                    hintText: '닉네임',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 12),
                  _SignupTextField(
                    controller: _emailController,
                    hintText: '이메일',
                    icon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  _SignupTextField(
                    controller: _passwordController,
                    hintText: '비밀번호',
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  const SizedBox(height: 12),
                  _SignupSelect<int?>(
                    value: _selectedGender,
                    hintText: '성별',
                    icon: Icons.wc_outlined,
                    items: const [
                      DropdownMenuItem(value: null, child: Text('선택 안 함')),
                      DropdownMenuItem(value: 0, child: Text('남성')),
                      DropdownMenuItem(value: 1, child: Text('여성')),
                    ],
                    onChanged: (value) => setState(() {
                      _selectedGender = value;
                    }),
                  ),
                  const SizedBox(height: 12),
                  _SignupSelect<String>(
                    value: _selectedAgeRange,
                    hintText: '연령대',
                    icon: Icons.cake_outlined,
                    items: _ageRanges
                        .map(
                          (item) => DropdownMenuItem(
                            value: item.value,
                            child: Text(item.label),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() {
                      _selectedAgeRange = value;
                    }),
                  ),
                  const SizedBox(height: 24),
                  const InfoCard(
                    icon: Icons.verified_user_outlined,
                    title: '예산 정보는 익명으로 보호돼요',
                    body: '성별과 연령대는 추천 품질 개선에만 사용하고\n개인 예산은 다른 사람에게 공개하지 않아요.',
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    label: _isSubmitting ? '가입 중...' : '회원가입 완료',
                    onTap: _submit,
                    enabled: !_isSubmitting,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignupTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;

  const _SignupTextField({
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

class _SignupSelect<T> extends StatelessWidget {
  final T? value;
  final String hintText;
  final IconData icon;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _SignupSelect({
    required this.value,
    required this.hintText,
    required this.icon,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: onChanged,
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
