import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:nexly/room/room.dart';

import 'appwrite.dart';
import 'home/createRoom.dart';
import 'home/joinRoom.dart';

class AppwriteProvider extends InheritedWidget {
  final Client client;
  final Account account;

  const AppwriteProvider({
    Key? key,
    required this.client,
    required this.account,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return (oldWidget as AppwriteProvider) != this;
  }

  static AppwriteProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppwriteProvider>();
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AppwriteProvider(
    client: client,
    account: account,
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

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
      home: const MyHomePage(
        title: 'Nexly',
      ),
      routes: {
        '/room': (context) => Room(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

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
      CreateRoom(),
      JoinRoom(),
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
            selectedIcon: Badge(child: Icon(Icons.add_circle_outlined)),
            icon: Badge(child: Icon(Icons.add_circle)),
            label: 'Create a room',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.login_outlined),
            icon: Icon(Icons.login),
            label: 'Join a room',
          ),
        ],
      ),
    );
  }
}
