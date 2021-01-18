import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickchat/help/helperfunctions.dart';
import 'package:quickchat/screens/chatroom.dart';
import 'package:quickchat/services/auth.dart';
import 'package:quickchat/services/database.dart';
import 'package:quickchat/widgets/widget.dart';

class SignIn extends StatefulWidget {
  final Function toggle;

  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  AuthMethods authMethods = new AuthMethods();
  QuerySnapshot snapshot;
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool isloading = false;

  signin() async {
    if (formKey.currentState.validate()) {
      
      databaseMethods.getUserByUserEmail(emailController.text).then((val) {
        snapshot = val;
        HelperFunctions.saveuserNameSharedPreference(
            snapshot.docs[0].data()["name"].toString());
        HelperFunctions.saveuserEmailSharedPreference(snapshot.docs[0].data()["email"]);
      });

      setState(() {
        isloading = true;
      });

      await authMethods
          .signInWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((val) {
        if (val != null) {
          HelperFunctions.saveuserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: appbar(context),
      body: Container(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                        controller: emailController,
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val)
                              ? null
                              : 'Provide valid Email';
                        },
                        style: textfieldstyle(),
                        decoration: textfieldinputdecoration('email')),
                    TextFormField(
                        validator: (val) {
                          if (val.length > 6) {
                            return null;
                          }
                          return 'Password should have more than ^ characters';
                        },
                        obscureText: true,
                        controller: passwordController,
                        style: textfieldstyle(),
                        decoration: textfieldinputdecoration('Password')),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.all(4),
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot Password?',
                    style: textfieldstyle(),
                  )),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  signin();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                          colors: [Colors.blueAccent, Colors.blueAccent[700]])),
                  child: Text(
                    'Sign In',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white),
                child: Text(
                  'Sign In with Google',
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an Account? ",
                      style: TextStyle(color: Colors.white)),
                  GestureDetector(
                      onTap: () {
                        widget.toggle();
                      },
                      child: Container(
                          child: Text(
                        "Register Now",
                        style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline),
                      )))
                ],
              ),
              SizedBox(height: 40)
            ],
          ),
        ),
      ),
    );
  }
}
