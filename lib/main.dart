import 'package:flutter/material.dart';
import 'package:quickchat/help/authenticate.dart';
import 'package:quickchat/help/helperfunctions.dart';
import 'package:quickchat/screens/chatroom.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quickchat/screens/conversation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 
  bool isLoggedIn = false;
  getLoggedInState() async {
    await HelperFunctions.getuserLoggedInSharedPreference().then((value) {
      setState(() {
        if (value != null) {
          isLoggedIn = value;
        }
      });
    });
  }

  @override
  void initState() {
    getLoggedInState();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Authenticate(),
    );
  }
}
