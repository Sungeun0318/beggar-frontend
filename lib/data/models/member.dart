class Member {
  final String name;
  final String status;
  final bool mine;

  const Member({
    required this.name,
    required this.status,
    this.mine = false,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        name: json['name'] as String,
        status: json['status'] as String,
        mine: json['mine'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'status': status,
        'mine': mine,
      };
}
