class RoomFreePost {
  final int id;
  final String title;
  final String content;
  final String author;
  final String tag;
  final int commentCount;
  final DateTime createdAt;

  RoomFreePost({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.tag,
    required this.commentCount,
    required this.createdAt,
  });

  factory RoomFreePost.fromJson(Map<String, dynamic> json) {
    return RoomFreePost(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      author: json['author'] as String? ?? '익명',
      tag: json['tag'] as String? ?? '일반',
      commentCount: json['commentCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class RoomFreePostDetail extends RoomFreePost {
  final List<RoomFreeComment> comments;

  RoomFreePostDetail({
    required super.id,
    required super.title,
    required super.content,
    required super.author,
    required super.tag,
    required super.commentCount,
    required super.createdAt,
    required this.comments,
  });

  factory RoomFreePostDetail.fromJson(Map<String, dynamic> json) {
    final base = RoomFreePost.fromJson(json);
    return RoomFreePostDetail(
      id: base.id,
      title: base.title,
      content: base.content,
      author: base.author,
      tag: base.tag,
      commentCount: base.commentCount,
      createdAt: base.createdAt,
      comments: (json['comments'] as List<dynamic>?)
              ?.map((e) => RoomFreeComment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class RoomFreeComment {
  final int id;
  final String author;
  final String content;
  final DateTime createdAt;

  RoomFreeComment({
    required this.id,
    required this.author,
    required this.content,
    required this.createdAt,
  });

  factory RoomFreeComment.fromJson(Map<String, dynamic> json) {
    return RoomFreeComment(
      id: json['id'] as int,
      author: json['author'] as String? ?? '익명',
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
