import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:nexly/room/RoomMessage.dart';

import '../appwrite.dart';

class RoomWidget extends StatefulWidget {
  final String roomCode;

  const RoomWidget({Key? key, required this.roomCode}) : super(key: key);

  @override
  State<RoomWidget> createState() => _RoomWidgetState();
}

class _RoomWidgetState extends State<RoomWidget> {
  late List<dynamic> messages = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      Document result = (await databases.getDocument(
        databaseId: database,
        collectionId: "rooms",
        documentId: widget.roomCode,
      ));
      print(result.data);
      dynamic resultData = result.data;
      print(resultData["messages"]);
      List<dynamic> messagesData = resultData["messages"] ?? [];
      setState(() {
        messages = messagesData;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(
              'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Divočákos"),
            Text("1 members"),
          ],
        ),
        titleSpacing: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (BuildContext context, int index) {
                  return RoomMessage(message: messages[index]);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[200], // Light grey color
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      minLines: 1,
                      maxLines: 10,
                      decoration: InputDecoration(
                        hintText: 'Enter your message...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Row(
                    children: [
                      Icon(Icons.gif, size: 30),
                      SizedBox(width: 10),
                      Icon(Icons.emoji_emotions),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      endDrawer: const Drawer(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('This is the Drawer'),
            ],
          ),
        ),
      ),
    );
  }
}
