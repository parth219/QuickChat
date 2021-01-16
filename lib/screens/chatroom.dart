import 'package:flutter/material.dart';
import 'package:quickchat/help/authenticate.dart';
import 'package:quickchat/screens/search.dart';
import 'package:quickchat/screens/signin.dart';
import 'package:quickchat/services/auth.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        title: Text('QuickChat'),
        actions: [
          GestureDetector(
              onTap: () {
                authMethods.signout();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Authenticate()));
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.exit_to_app)))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context)=>Search()));
            },
        ),
    );
  }
}
