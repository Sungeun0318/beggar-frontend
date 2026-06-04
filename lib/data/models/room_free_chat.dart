class RoomFreeChat {
  final int id;
  final String sender;
  final String message;
  final DateTime createdAt;
  final bool isMine;

  RoomFreeChat({
    required this.id,
    required this.sender,
    required this.message,
    required this.createdAt,
    this.isMine = false,
  });

  factory RoomFreeChat.fromJson(Map<String, dynamic> json) {
    return RoomFreeChat(
      id: json['id'] as int? ?? 0,
      sender: json['sender'] as String? ?? '익명',
      message: json['message'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
