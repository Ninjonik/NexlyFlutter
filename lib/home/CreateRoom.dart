import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class CreateRoom extends StatefulWidget {
  CreateRoom({Key? key}) : super(key: key);

  @override
  State<CreateRoom> createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _roomNameController = TextEditingController();
  final TextEditingController _roomDescriptionController =
      TextEditingController();

  @override
  void dispose() {
    _nicknameController.dispose();
    _roomNameController.dispose();
    _roomDescriptionController.dispose();
    super.dispose();
  }

  Future<void> handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Creating a room...')),
      );

      final account = AppwriteProvider.of(context)?.account;
      if (account == null) return;

      String nickname = _nicknameController.text;
      String roomName = _roomNameController.text;
      String roomDescription = _roomDescriptionController.text;

      print("Form submitted");
      try {
        await account.deleteSessions();
      } catch (e) {
        print("no sessions");
      }
      await account.createAnonymousSession();
      await account.updateName(name: nickname);
      Jwt jwt = await account.createJWT();
      print(jwt.jwt);
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
                const Text("Create a room", style: TextStyle(fontSize: 30)),
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
                  controller: _roomNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Room\'s name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the room\'s name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _roomDescriptionController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Room\'s description',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description for the room';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: handleSubmit,
                  child: const Text("Create a new room"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
