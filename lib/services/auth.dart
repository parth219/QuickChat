import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:quickchat/model/user.dart';


class AuthMethods{

  final FirebaseAuth _auth=FirebaseAuth.instance;

  UserClass _userFromFirebaseUser(User user){
    return user !=null ? UserClass(userId:user.uid) : null;
  }

  Future SignInWithEmailAndPassword(String email,String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User firebaseUser=result.user;
      return _userFromFirebaseUser(firebaseUser);
    }catch(e){
      print(e.toString());
    }
  }

  Future SignUpWithEmailAndPassword(String email,String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User firebaseUser=result.user;
      return _userFromFirebaseUser(firebaseUser);
    }
    catch(e){
      print(e.toString());
    }
  }

  Future resetPassword(String email){
    try{
      return _auth.sendPasswordResetEmail(email: email);
    }
    catch(e){
      print(e.toString());
    }
  }

  Future signout() async{
    try{
      return await _auth.signOut();
    }
    catch(e){
      print(e.toString());
    }
  }
}