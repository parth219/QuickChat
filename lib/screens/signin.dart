import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickchat/help/helperfunctions.dart';
import 'package:quickchat/services/auth.dart';
import 'package:quickchat/services/database.dart';
import 'package:quickchat/widgets/widget.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: appbar(context),
      body: Center(
        child: GestureDetector(
          
          onTap: (){
            AuthMethods().signInWithGoogle(context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30), color: Colors.red),
            child: Text(
              'Sign In with Google',
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
          ),
        ),
      ),
    );
  }
}
