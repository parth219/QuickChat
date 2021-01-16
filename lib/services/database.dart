import 'package:cloud_firestore/cloud_firestore.dart';

  class DatabaseMethods{
    uploadUserInfo(userMap){
      FirebaseFirestore.instance.collection("users").add(userMap);
    }

    Future<Stream<QuerySnapshot>>getUserByUsername(String username) async{
      return  FirebaseFirestore.instance.collection("users").where("name", isEqualTo:username).snapshots();
    }

  }