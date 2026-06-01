import 'package:beggar_app/core/theme/assets.dart';
import 'package:beggar_app/data/models/budget_result.dart';
import 'package:beggar_app/data/models/member.dart';
import 'package:beggar_app/data/models/receipt.dart';
import 'package:beggar_app/data/models/room.dart';
import 'package:beggar_app/data/models/user.dart';

class MockDb {
  static const currentUser = User(
    no: 3,
    name: '거지판다',
    email: 'flutter_dev03@kakao.com',
  );

  static const room = Room(
    no: 1,
    ownerNo: 3,
    name: '명학역 데이트',
    code: 'abc001',
    location: '경기 안양시 만안구',
    tags: ['한식'],
    memberCount: 4,
    maxMemberCount: 8,
  );

  static const members = [
    Member(name: '거지판다', status: '제출 완료', mine: true),
    Member(name: '거지진감', status: '제출 완료'),
    Member(name: '거지로봇', status: '제출 완료'),
    Member(name: '거거', status: '제출 완료'),
  ];

  static const budgetResult = BudgetResult(
    minBudgetPerPerson: 15000,
    memberCount: 4,
    totalBudget: 60000,
  );

  static const receipts = [
    Receipt(
      date: '2024.05.18',
      room: '명학역 데이트',
      image: Assets.receiptFood,
      title: '정성 한식',
      amount: 35000,
    ),
    Receipt(
      date: '2024.05.12',
      room: '전시 보러 가요',
      image: Assets.receiptCafe,
      title: '블루보틀 삼청',
      amount: 14000,
    ),
    Receipt(
      date: '2024.05.05',
      room: '주말 브런치 클럽',
      image: Assets.receiptBrunch,
      title: '오아시스 한남',
      amount: 52000,
    ),
  ];
}
