import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Client client = Client()
      .setEndpoint("https://appwrite.igportals.eu/v1")
      .setProject("nexlyv2");
  Account account = Account(client); // Ensure account is not nullable
  runApp(MyApp(account: account));
}

class MyApp extends StatefulWidget {
  final Account account; // Ensure account is not nullable

  const MyApp({Key? key, required this.account}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nexly',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade700),
        useMaterial3: true,
      ),
      home: MyHomePage(
        title: 'Nexly',
        account: widget.account, // Ensure account is not nullable
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final Account account; // Ensure account is not nullable

  const MyHomePage({Key? key, required this.title, required this.account})
      : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;
  List<Widget> _widgetOptions = [];

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      CreateRoom(account: widget.account),
      const Text("Join a room"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _widgetOptions[
                  currentPageIndex], // Ensure account is not nullable
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Badge(child: Icon(Icons.add_circle)),
            label: 'Create a room',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.login),
            label: 'Join a room',
          ),
        ],
      ),
    );
  }
}

class CreateRoom extends StatefulWidget {
  final Account account; // Ensure account is not nullable

  const CreateRoom({Key? key, required this.account}) : super(key: key);

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
        const SnackBar(content: Text('Submitting...')),
      );

      String nickname = _nicknameController.text;
      String roomName = _roomNameController.text;
      String roomDescription = _roomDescriptionController.text;

      print("Form submitted");
      try {
        await widget.account.deleteSessions();
      } catch (e) {
        print("no sessions");
      }
      print("a");
      await widget.account.createAnonymousSession();
      print("b");
      await widget.account.updateName(name: nickname);
      print("c");
      Jwt jwt = await widget.account.createJWT();
      print(jwt);
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
