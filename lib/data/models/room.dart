class Room {
  final int no;
  final int ownerNo;
  final String name;
  final String code;
  final String location;
  final List<String> tags;
  final int memberCount;

  const Room({
    required this.no,
    required this.ownerNo,
    required this.name,
    required this.code,
    required this.location,
    required this.tags,
    required this.memberCount,
  });

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        no: json['no'] as int,
        ownerNo: json['ownerNo'] as int,
        name: json['name'] as String,
        code: json['code'] as String,
        location: json['location'] as String,
        tags: (json['tags'] as List).cast<String>(),
        memberCount: json['memberCount'] as int,
      );

  Map<String, dynamic> toJson() => {
        'no': no,
        'ownerNo': ownerNo,
        'name': name,
        'code': code,
        'location': location,
        'tags': tags,
        'memberCount': memberCount,
      };
}
