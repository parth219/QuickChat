import 'package:flutter/material.dart';
import 'package:quickchat/screens/chatroom.dart';
import 'package:quickchat/services/auth.dart';
import 'package:quickchat/services/database.dart';
import 'package:quickchat/widgets/widget.dart';
import 'package:firebase_core/firebase_core.dart';

class SignUp extends StatefulWidget {

  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods=new DatabaseMethods();

  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool isloading = false;

  signup() {
    if (formKey.currentState.validate()) {
       Map<String,String> userMap={
        "name":usernameController.text,
        "email":emailController.text
      };
      setState(() {
        isloading = true;
      });

      authMethods.SignUpWithEmailAndPassword(emailController.text, passwordController.text)
          .then((value) => print("$value"));
     
      databaseMethods.uploadUserInfo(userMap);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ChatRoom()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: appbar(context),
      body: isloading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 40,
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
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return 'Please Enter Detail ';
                                  }
                                  return null;
                                },
                                controller: usernameController,
                                style: textfieldstyle(),
                                decoration:
                                    textfieldinputdecoration('username')),
                            TextFormField(
                                validator: (val) {
                                  return RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(val)
                                      ? null
                                      : 'Provide valid Email';
                                },
                                controller: emailController,
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
                                decoration:
                                    textfieldinputdecoration('Password')),
                          ],
                        ),
                      ),
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
                      GestureDetector(
                        onTap: () {
                          signup();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(colors: [
                                Colors.blueAccent,
                                Colors.blueAccent[700]
                              ])),
                          child: Text(
                            'Sign Up',
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
                          'Sign Up with Google',
                          style: TextStyle(color: Colors.black, fontSize: 17),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an Account? ",
                              style: TextStyle(color: Colors.white)),
                          GestureDetector(
                            onTap: (){
                              widget.toggle();
                            },
                                                      child: Container(
                              child: Text(
                                "Sign In Now",
                                style: TextStyle(
                                    color: Colors.white,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 40)
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
