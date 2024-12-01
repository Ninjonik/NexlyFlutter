import 'Message.dart';
import 'User.dart';

class Room {
  String name;
  bool closed;
  String description;
  bool call;
  String avatar;
  String $id;
  String $createdAt;
  String $updatedAt;
  List<dynamic> $permissions;
  List<User> users;
  List<Message> messages;
  String $databaseId;
  String $collectionId;

  Room({
    required this.name,
    required this.closed,
    required this.description,
    required this.call,
    required this.avatar,
    required this.$id,
    required this.$createdAt,
    required this.$updatedAt,
    required this.$permissions,
    required this.users,
    required this.messages,
    required this.$databaseId,
    required this.$collectionId,
  });
}
