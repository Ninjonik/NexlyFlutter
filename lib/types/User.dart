import 'Room.dart';

class User {
  String name;
  String avatar;
  Room room;
  String $id;
  String $createdAt;
  String $updatedAt;
  List<dynamic> $permissions;
  String $databaseId;
  String $collectionId;

  User({
    required this.name,
    required this.avatar,
    required this.room,
    required this.$id,
    required this.$createdAt,
    required this.$updatedAt,
    required this.$permissions,
    required this.$databaseId,
    required this.$collectionId,
  });
}
