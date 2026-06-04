import 'package:beggar_app/data/api/api_client.dart';
import 'package:beggar_app/data/models/room_free_post.dart';
import 'package:beggar_app/data/models/room_free_chat.dart';

class RoomFreeRepository {
  final ApiClient _api;

  RoomFreeRepository(this._api);

  /// 1. 게시글 목록 조회
  Future<List<RoomFreePost>> getPosts({String? keyword}) async {
    final response = await _api.get(
      '/api/freerooms/posts',
      query: keyword != null ? {'keyword': keyword} : {},
    );
    // ApiResponse.data가 List인 경우
    final List<dynamic> data = response['data'];
    return data.map((json) => RoomFreePost.fromJson(json)).toList();
  }

  /// 2. 게시글 상세 조회
  Future<RoomFreePostDetail> getPostDetail(int postId) async {
    final response = await _api.get('/api/freerooms/posts/$postId');
    return RoomFreePostDetail.fromJson(response['data']);
  }

  /// 3. 댓글 작성
  Future<void> createComment(int postId, String content) async {
    await _api.post(
      '/api/freerooms/posts/$postId/comments',
      body: {'content': content},
    );
  }

  /// 4. 게시글 작성
  Future<void> createPost({
    required String title,
    required String content,
    required String tag,
  }) async {
    await _api.post(
      '/api/freerooms/posts',
      body: {
        'title': title,
        'content': content,
        'tag': tag,
      },
    );
  }

  /// 5. 전체 채팅 내역 조회
  Future<List<RoomFreeChat>> getChatHistory() async {
    final response = await _api.get('/api/freerooms/chats');
    final List<dynamic> data = response['data'];
    return data.map((json) => RoomFreeChat.fromJson(json)).toList();
  }

  /// 5. 채팅 메시지 전송
  Future<RoomFreeChat> sendChat(String message) async {
    final response = await _api.post('/api/freerooms/chats', body: {'content': message});
    
    // 백엔드에서 data를 null로 줄 경우를 대비한 방어 코드
    if (response['data'] == null) {
      return RoomFreeChat(
        id: -1, // 임시 ID
        sender: '나',
        message: message,
        createdAt: DateTime.now(),
        isMine: true,
      );
    }
    
    return RoomFreeChat.fromJson(response['data']);
  }
}
