import 'package:appwrite/appwrite.dart';

const String apiUrl = "https://nexly.igportals.eu";
const String database = "nexly";
Client client = Client()
    .setEndpoint("https://appwrite.igportals.eu/v1")
    .setProject("nexlyv2");
Account account = Account(client);
Databases databases = Databases(client);
Storage storage = Storage(client);
