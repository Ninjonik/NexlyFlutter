import 'dart:convert';

import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../appwrite.dart';
import '../main.dart';

class JoinRoom extends StatefulWidget {
  JoinRoom({Key? key}) : super(key: key);

  @override
  State<JoinRoom> createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _roomCodeController = TextEditingController();

  @override
  void dispose() {
    _nicknameController.dispose();
    _roomCodeController.dispose();
    super.dispose();
  }

  Future<void> handleSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Joining a room...')),
      );

      final account = AppwriteProvider.of(context)?.account;
      if (account == null) return;

      String nickname = _nicknameController.text;
      String roomCode = _roomCodeController.text;

      print("Form submitted");
      try {
        await account.deleteSessions();
      } catch (e) {
        print("no sessions");
      }
      await account.createAnonymousSession();
      await account.updateName(name: nickname);
      Jwt jwt = await account.createJWT();

      // Post request to check if the room exists
      try {
        var checkRoomResponse = await http.post(
          Uri.parse('$apiUrl/api/checkRoom'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, String>{
            'roomCode': roomCode,
          }),
        );

        if (checkRoomResponse.statusCode == 200) {
          print('Check Room Response: ${checkRoomResponse.body}');
        } else {
          if (mounted) {
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text(
                    'Error checking room: ${checkRoomResponse.statusCode}'),
              ),
            );
          }
          return;
        }
      } catch (e) {
        // Handle error
        print('Error checking room: $e');
        if (mounted) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text('Error checking room: $e'),
            ),
          );
        }
        return;
      }

      // Post request to join the room
      try {
        var joinRoomResponse = await http.patch(
          Uri.parse('$apiUrl/api/joinRoom'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, dynamic>{
            'roomCode': roomCode,
            'name': nickname,
            'avatar': "defaultAvatar", // assuming you have avatarValue defined
            'jwt': jwt.jwt,
          }),
        );

        if (joinRoomResponse.statusCode == 200) {
          // Room has been successfully joined
        } else {
          if (mounted) {
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content:
                    Text('Error joining room: ${joinRoomResponse.statusCode}'),
              ),
            );
          }
        }
      } catch (e) {
        // Handle error
        print('Error joining room: $e');
        if (mounted) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text('Error joining room: $e'),
            ),
          );
        }
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/nexly.png', width: 200, height: 200),
                const Text("Join a room", style: TextStyle(fontSize: 30)),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _nicknameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nickname',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your nickname';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _roomCodeController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Room\'s code',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the room\'s code';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => handleSubmit(context),
                  child: const Text("Join the room"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
