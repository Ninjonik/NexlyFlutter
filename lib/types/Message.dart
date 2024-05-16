import 'Room.dart';
import 'User.dart';

class Message {
  String $id;
  String $createdAt;
  String $updatedAt;
  List<String> $permissions;
  User author;
  Room room;
  String? message;
  List<String> attachments;
  String $databaseId;
  String $collectionId;

  Message({
    required this.$id,
    required this.$createdAt,
    required this.$updatedAt,
    required this.$permissions,
    required this.author,
    required this.room,
    this.message,
    required this.attachments,
    required this.$databaseId,
    required this.$collectionId,
  });
}
