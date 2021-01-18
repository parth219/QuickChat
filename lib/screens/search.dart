import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickchat/help/Constants.dart';
import 'package:quickchat/help/helperfunctions.dart';
import 'package:quickchat/screens/conversation.dart';
import 'package:quickchat/services/database.dart';
import 'package:quickchat/widgets/widget.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}
String _myName;

class _SearchState extends State<Search> {
  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController searchinfo = new TextEditingController();
  bool isSearching = false;
  Stream usersStream;
  QuerySnapshot snapshot;
  String a = "";

  initiatesearch() {
    databaseMethods.getUserByUsername(searchinfo.text).then((val) {
      setState(() {
        snapshot = val;
      });
    });
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  createChatRoomAndStartConversation(
    String userName,
  ) {
    //if (userName != Constants.myName) {
      String chatRoomId = getChatRoomId(userName, Constants.myName);
      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "ChatRoomId": chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Container()));
    //}
  }

  Widget searchTile(String username, String useremail) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(username, style: textfieldstyle()),
              Text(
                useremail,
                style: textfieldstyle(),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndStartConversation(username);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(25)),
              child: Text(
                "Message",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchList() {
    return snapshot != null
        ? ListView.builder(
            itemCount: snapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return searchTile(snapshot.docs[index].data()['name'],
                  snapshot.docs[index].data()["email"]);
            })
        : Container();
  }

  @override
  void initState() {
    super.initState();
  }

  getuserinfo()async{
    _myName= await HelperFunctions.getuserNameSharedPreference();
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: appbar(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.grey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchinfo,
                        style: textfieldstyle(),
                        decoration: InputDecoration(
                            hintText: 'Enter Username',
                            hintStyle: TextStyle(color: Colors.white54),
                            border: InputBorder.none),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (searchinfo.text != "") {
                          initiatesearch();
                        }
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.black54),
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 30,
                          )),
                    )
                  ],
                ),
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}
