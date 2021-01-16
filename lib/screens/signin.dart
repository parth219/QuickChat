import 'package:flutter/material.dart';
import 'package:quickchat/widgets/widget.dart';

class SignIn extends StatefulWidget {
  final Function toggle;

  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
              TextField(
                  style: textfieldstyle(),
                  decoration: textfieldinputdecoration('email')),
              TextField(
                  style: textfieldstyle(),
                  decoration: textfieldinputdecoration('Password')),
              SizedBox(
                height: 8,
              ),
              Container(
                  padding: EdgeInsets.all(4),
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot Password?',
                    style: textfieldstyle(),
                  )),
              SizedBox(height: 8),
              Container(
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
                      onTap: (){
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
