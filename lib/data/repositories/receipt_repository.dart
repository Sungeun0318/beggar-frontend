import 'package:beggar_app/data/models/receipt.dart';

// TODO(backend): /receipts — OCR 업로드 / 수동 등록 / 목록.
abstract class ReceiptRepository {
  Future<List<Receipt>> listAll();
  Future<List<Receipt>> listByRoom(int roomNo);
  Future<Receipt> create({
    required int roomNo,
    required String title,
    required int amount,
    String? imagePath,
  });
}
