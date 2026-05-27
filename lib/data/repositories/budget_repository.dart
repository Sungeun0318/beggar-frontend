import 'package:beggar_app/data/models/budget_result.dart';

// TODO(backend): /rooms/{no}/budget — 익명 제출/결과 조회.
abstract class BudgetRepository {
  Future<void> submit({required int roomNo, required int amount});
  Future<BudgetResult> result(int roomNo);
}
