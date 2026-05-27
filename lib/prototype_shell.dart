import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/data/mock/mock_db.dart';
import 'package:beggar_app/features/auth/login_screen.dart';
import 'package:beggar_app/features/auth/signup_screen.dart';
import 'package:beggar_app/features/budget/budget_input_screen.dart';
import 'package:beggar_app/features/budget/budget_result_screen.dart';
import 'package:beggar_app/features/home/home_screen.dart';
import 'package:beggar_app/features/placeholders/placeholder_tab_screen.dart';
import 'package:beggar_app/features/receipts/receipts_screen.dart';
import 'package:beggar_app/features/recommendation/recommendation_screen.dart';
import 'package:beggar_app/features/room/active_room_screen.dart';
import 'package:beggar_app/features/room/create_room_screen.dart';
import 'package:beggar_app/features/room/invite_room_screen.dart';
import 'package:beggar_app/features/splash/splash_screen.dart';
import 'package:beggar_app/shared/widgets/bottom_nav.dart';

enum PrototypePage {
  splash,
  login,
  signup,
  home,
  createRoom,
  invite,
  budgetInput,
  budgetResult,
  recommendation,
  activeRoom,
  receipts,
  ranking,
  myPage,
}

class PrototypeShell extends StatefulWidget {
  const PrototypeShell({super.key});

  @override
  State<PrototypeShell> createState() => _PrototypeShellState();
}

class _PrototypeShellState extends State<PrototypeShell> {
  PrototypePage _page = PrototypePage.splash;

  void _go(PrototypePage page) => setState(() => _page = page);

  @override
  Widget build(BuildContext context) {
    Widget child;
    switch (_page) {
      case PrototypePage.splash:
        child = SplashScreen(onDone: () => _go(PrototypePage.login));
      case PrototypePage.login:
        child = LoginScreen(
          onLogin: () => _go(PrototypePage.home),
          onSignup: () => _go(PrototypePage.signup),
        );
      case PrototypePage.signup:
        child = SignupScreen(
          onBack: () => _go(PrototypePage.login),
          onComplete: () => _go(PrototypePage.login),
        );
      case PrototypePage.home:
        child = HomeScreen(
          onOpenRoom: () => _go(PrototypePage.activeRoom),
          onCreate: () => _go(PrototypePage.createRoom),
        );
      case PrototypePage.receipts:
        child = ReceiptsScreen(
          onCreate: () => _go(PrototypePage.createRoom),
          onBack: () => _go(PrototypePage.activeRoom),
        );
      case PrototypePage.createRoom:
        child = CreateRoomScreen(
          onBack: () => _go(PrototypePage.home),
          onNext: () => _go(PrototypePage.invite),
        );
      case PrototypePage.invite:
        child = InviteRoomScreen(
          onBack: () => _go(PrototypePage.createRoom),
          onNext: () => _go(PrototypePage.budgetInput),
        );
      case PrototypePage.budgetInput:
        child = BudgetInputScreen(
          onBack: () => _go(PrototypePage.invite),
          onNext: () => _go(PrototypePage.budgetResult),
        );
      case PrototypePage.budgetResult:
        child = BudgetResultScreen(
          onBack: () => _go(PrototypePage.budgetInput),
          onNext: () => _go(PrototypePage.recommendation),
        );
      case PrototypePage.recommendation:
        child = RecommendationScreen(
          onBack: () => _go(PrototypePage.budgetResult),
          onDone: () => _go(PrototypePage.activeRoom),
        );
      case PrototypePage.activeRoom:
        child = ActiveRoomScreen(
          onAddReceipt: () => _go(PrototypePage.receipts),
          onCreate: () => _go(PrototypePage.createRoom),
        );
      case PrototypePage.ranking:
        child = const PlaceholderTabScreen(
          title: '랭킹',
          icon: Icons.emoji_events_outlined,
          body: '명예의 거지 전당은 거지력 지수와 절약률 기준으로 보여줄 예정이에요.',
        );
      case PrototypePage.myPage:
        child = PlaceholderTabScreen(
          title: '마이',
          icon: Icons.person_outline,
          body: '${MockDb.currentUser.name}님의 계정과 참여한 거지방을 관리해요.',
        );
    }

    final showBottomNav = switch (_page) {
      PrototypePage.splash ||
      PrototypePage.login ||
      PrototypePage.signup => false,
      _ => true,
    };

    return ColoredBox(
      color: AppColors.canvas,
      child: Stack(
        children: [
          child,
          if (showBottomNav)
            BottomNav(
              activeIndex: _activeIndex,
              onHome: () => _go(PrototypePage.home),
              onExpense: () => _go(PrototypePage.receipts),
              onAdd: () => _go(PrototypePage.createRoom),
              onRanking: () => _go(PrototypePage.ranking),
              onMy: () => _go(PrototypePage.myPage),
            ),
        ],
      ),
    );
  }

  int get _activeIndex {
    return switch (_page) {
      PrototypePage.activeRoom => 0,
      PrototypePage.home => 0,
      PrototypePage.receipts => 1,
      PrototypePage.createRoom ||
      PrototypePage.invite ||
      PrototypePage.budgetInput ||
      PrototypePage.budgetResult ||
      PrototypePage.recommendation => 2,
      PrototypePage.ranking => 3,
      PrototypePage.myPage => 4,
      _ => 0,
    };
  }
}
