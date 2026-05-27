class Receipt {
  final String date;
  final String room;
  final String image;
  final String title;
  final int amount;

  const Receipt({
    required this.date,
    required this.room,
    required this.image,
    required this.title,
    required this.amount,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) => Receipt(
        date: json['date'] as String,
        room: json['room'] as String,
        image: json['image'] as String,
        title: json['title'] as String,
        amount: json['amount'] as int,
      );

  Map<String, dynamic> toJson() => {
        'date': date,
        'room': room,
        'image': image,
        'title': title,
        'amount': amount,
      };
}
