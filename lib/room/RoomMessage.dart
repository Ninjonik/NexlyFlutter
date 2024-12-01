import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../utils/formatTime.dart';
import '../utils/getAvatar.dart';

class RoomMessage extends StatelessWidget {
  final dynamic message;

  const RoomMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? author = message['author'];
    final String authorName = author?['name'] ?? 'Unknown user';
    final String authorAvatar = author?['avatar'] ?? "defaultAvatar";
    final String updatedAt =
        formatTime(message['\$updatedAt']) ?? '16.5.2024 20:42';
    final String messageContent = message['message'] ?? message.toString();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          FutureBuilder<Uint8List?>(
            future: getAvatar(authorAvatar),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                      'https://appwrite.igportals.eu/v1/storage/buckets/avatars/files/defaultAvatar/view?project=nexlyv2&mode=admin'), // Predefined URL
                );
              } else if (snapshot.hasError || snapshot.data == null) {
                return const CircleAvatar(
                  radius: 25,
                  child: Icon(Icons.error), // Placeholder for error
                );
              } else {
                return CircleAvatar(
                  radius: 25,
                  backgroundImage: MemoryImage(snapshot.data!),
                );
              }
            },
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(authorName),
                  const SizedBox(width: 5),
                  Text(updatedAt),
                ],
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Light grey color
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                child: Text(messageContent),
              ),
            ],
          )
        ],
      ),
    );
  }
}
