import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quickchat/help/helperfunctions.dart';

import 'package:quickchat/model/user.dart';

import 'package:quickchat/screens/home.dart';
import 'package:quickchat/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthMethods{

  final FirebaseAuth _auth=FirebaseAuth.instance;

  getCurrentUser() async {
    return await _auth.currentUser;
    }

  signInWithGoogle(BuildContext context)async{
    final FirebaseAuth _firebaseAuth= FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn= GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication= await googleSignInAccount.authentication;
    final AuthCredential credential= GoogleAuthProvider.credential(idToken: googleSignInAuthentication.idToken,accessToken:googleSignInAuthentication.accessToken);

    UserCredential result= await _firebaseAuth.signInWithCredential(credential); 
    User userDetails =result.user;

    if(result!=null){
      HelperFunctions().saveUserEmail(userDetails.email);
      HelperFunctions().saveUserId(userDetails.uid);
      HelperFunctions().saveUserName(userDetails.email.replaceAll("@gmail.com", ""));
      HelperFunctions().saveDisplayName(userDetails.displayName);
      HelperFunctions().saveUserProfile(userDetails.photoURL);

      Map<String,dynamic> userInfoMap={
        "email":userDetails.email,
        "username": userDetails.email.replaceAll("@gmail.com",""),
        "name":userDetails.displayName,
        "imgUrl": userDetails.photoURL
      };


      DatabaseMethods().addUserInfo(userDetails.uid, userInfoMap).then((value){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
      });
    }
  }
  Future signOut()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    await _auth.signOut();
  }
 
}