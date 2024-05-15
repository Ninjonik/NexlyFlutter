import 'package:appwrite/appwrite.dart';

const String apiUrl = "https://nexly.igportals.eu";
Client client = Client()
    .setEndpoint("https://appwrite.igportals.eu/v1")
    .setProject("nexlyv2");
Account account = Account(client);
