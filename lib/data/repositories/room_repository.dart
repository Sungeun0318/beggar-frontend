import 'package:beggar_app/data/models/member.dart';
import 'package:beggar_app/data/models/room.dart';

// TODO(backend): /rooms 관련 CRUD.
abstract class RoomRepository {
  Future<List<Room>> myRooms();
  Future<Room> create({
    required String name,
    required String location,
    required List<String> tags,
    required int memberCount,
  });
  Future<Room> join(String code);
  Future<List<Member>> members(int roomNo);
}
