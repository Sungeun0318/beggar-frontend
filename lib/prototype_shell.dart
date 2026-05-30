import 'package:flutter/material.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/features/auth/login_screen.dart';
import 'package:beggar_app/features/auth/my_page_screen.dart';
import 'package:beggar_app/features/auth/signup_screen.dart';
import 'package:beggar_app/features/budget/budget_input_screen.dart';
import 'package:beggar_app/features/budget/budget_result_screen.dart';
import 'package:beggar_app/features/community/community_chat_screen.dart';
import 'package:beggar_app/features/community/community_post_detail_screen.dart';
import 'package:beggar_app/features/community/community_post_write_screen.dart';
import 'package:beggar_app/features/community/community_screen.dart';
import 'package:beggar_app/features/home/home_screen.dart';
import 'package:beggar_app/features/home/ranking_screen.dart';
import 'package:beggar_app/features/receipts/receipt_register_screen.dart';
import 'package:beggar_app/features/receipts/receipts_screen.dart';
import 'package:beggar_app/features/recommendation/recommendation_screen.dart';
import 'package:beggar_app/features/room/active_room_screen.dart';
import 'package:beggar_app/features/room/create_room_screen.dart';
import 'package:beggar_app/features/room/invite_room_screen.dart';
import 'package:beggar_app/features/room/room_rating_screen.dart';
import 'package:beggar_app/features/room/room_settings_screen.dart';
import 'package:beggar_app/features/splash/splash_screen.dart';
import 'package:beggar_app/shared/widgets/bottom_nav.dart';

enum PrototypePage {
  splash,
  login,
  signup,
  home,
  community,
  communityChat,
  communityPostDetail,
  communityPostWrite,
  createRoom,
  invite,
  budgetInput,
  budgetResult,
  recommendation,
  activeRoom,
  roomRating,
  roomSettings,
  receiptRegister,
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
  PrototypePage _receiptsBackPage = PrototypePage.myPage;
  String _receiptModeTitle = '통합 영수증';
  String _receiptModeDescription = '한 식당이나 장소에서 한 번에 결제한 영수증을 등록해요.';
  int _roomTabIndex = 0;

  void _go(PrototypePage page) => setState(() => _page = page);
  void _openRoom(int tabIndex) {
    setState(() {
      _roomTabIndex = tabIndex;
      _page = PrototypePage.activeRoom;
    });
  }

  void _openCreateRoom(int tabIndex) {
    setState(() {
      _roomTabIndex = tabIndex;
      _page = PrototypePage.createRoom;
    });
  }

  void _openReceipts(PrototypePage backPage) {
    setState(() {
      _receiptsBackPage = backPage;
      _page = PrototypePage.receipts;
    });
  }

  void _openReceiptRegister({
    required String title,
    required String description,
  }) {
    setState(() {
      _receiptModeTitle = title;
      _receiptModeDescription = description;
      _page = PrototypePage.receiptRegister;
    });
  }

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
          onOpenRoom: () => _openRoom(0),
          onCreate: () => _openCreateRoom(0),
        );
      case PrototypePage.community:
        child = CommunityScreen(
          onOpenChat: () => _go(PrototypePage.communityChat),
          onOpenPost: () => _go(PrototypePage.communityPostDetail),
          onWritePost: () => _go(PrototypePage.communityPostWrite),
        );
      case PrototypePage.communityChat:
        child = CommunityChatScreen(onBack: () => _go(PrototypePage.community));
      case PrototypePage.communityPostDetail:
        child = CommunityPostDetailScreen(
          onBack: () => _go(PrototypePage.community),
        );
      case PrototypePage.communityPostWrite:
        child = CommunityPostWriteScreen(
          onBack: () => _go(PrototypePage.community),
          onSubmit: () => _go(PrototypePage.community),
        );
      case PrototypePage.receipts:
        child = ReceiptsScreen(
          onCreate: () => _go(PrototypePage.createRoom),
          onBack: () => _go(_receiptsBackPage),
        );
      case PrototypePage.createRoom:
        child = CreateRoomScreen(
          onBack: () => _go(
            _roomTabIndex == 1 ? PrototypePage.community : PrototypePage.home,
          ),
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
          onBack: () => _go(
            _roomTabIndex == 1 ? PrototypePage.community : PrototypePage.home,
          ),
          onOpenRating: () => _go(PrototypePage.roomRating),
          onOpenSettings: () => _go(PrototypePage.roomSettings),
        );
      case PrototypePage.roomRating:
        child = RoomRatingScreen(onBack: () => _go(PrototypePage.activeRoom));
      case PrototypePage.roomSettings:
        child = RoomSettingsScreen(
          onBack: () => _go(PrototypePage.activeRoom),
          onSave: () => _go(PrototypePage.activeRoom),
        );
      case PrototypePage.receiptRegister:
        child = ReceiptRegisterScreen(
          modeTitle: _receiptModeTitle,
          modeDescription: _receiptModeDescription,
          onBack: () => _go(PrototypePage.activeRoom),
          onComplete: () => _openReceipts(PrototypePage.activeRoom),
        );
      case PrototypePage.ranking:
        child = const RankingScreen();
      case PrototypePage.myPage:
        child = MyPageScreen(
          onOpenReceipts: () => _openReceipts(PrototypePage.myPage),
          onLogout: () => _go(PrototypePage.login),
        );
    }

    final showBottomNav = switch (_page) {
      PrototypePage.splash ||
      PrototypePage.login ||
      PrototypePage.signup ||
      PrototypePage.communityChat ||
      PrototypePage.communityPostDetail ||
      PrototypePage.communityPostWrite ||
      PrototypePage.activeRoom ||
      PrototypePage.roomRating ||
      PrototypePage.roomSettings ||
      PrototypePage.receiptRegister => false,
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
              onCommunity: () => _go(PrototypePage.community),
              onRanking: () => _go(PrototypePage.ranking),
              onMy: () => _go(PrototypePage.myPage),
            ),
          if (_page == PrototypePage.activeRoom)
            RoomReceiptBar(
              onAddCombinedReceipt: () => _openReceiptRegister(
                title: '통합 영수증',
                description: '한 식당이나 장소에서 한 번에 결제한 영수증을 등록해요.',
              ),
              onAddSplitReceipt: () => _openReceiptRegister(
                title: '분할 영수증',
                description: '같은 식당이나 장소에서 각자 계산해 여러 장으로 나뉜 영수증을 등록해요.',
              ),
            ),
          if (_page == PrototypePage.communityChat) const CommunityMessageBar(),
        ],
      ),
    );
  }

  int get _activeIndex {
    return switch (_page) {
      PrototypePage.activeRoom => _roomTabIndex,
      PrototypePage.roomRating => _roomTabIndex,
      PrototypePage.roomSettings => _roomTabIndex,
      PrototypePage.receiptRegister => _roomTabIndex,
      PrototypePage.home => 0,
      PrototypePage.community => 1,
      PrototypePage.communityChat ||
      PrototypePage.communityPostDetail ||
      PrototypePage.communityPostWrite => 1,
      PrototypePage.receipts =>
        _receiptsBackPage == PrototypePage.myPage ? 3 : 0,
      PrototypePage.createRoom ||
      PrototypePage.invite ||
      PrototypePage.budgetInput ||
      PrototypePage.budgetResult ||
      PrototypePage.recommendation => _roomTabIndex,
      PrototypePage.ranking => 2,
      PrototypePage.myPage => 3,
      _ => 0,
    };
  }
}
