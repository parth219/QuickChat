import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickchat/help/helperfunctions.dart';
import 'package:quickchat/screens/conversation.dart';
import 'package:quickchat/screens/signin.dart';
import 'package:quickchat/services/auth.dart';
import 'package:quickchat/services/database.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSearching = false;
  TextEditingController search = new TextEditingController();
  Stream usersStream,chatRoomStream;
  String myName, myProfile, myUserName, myEmail;

   getMyInfoFromSharedPreference() async {
    myName = await HelperFunctions().getDisplayName();
    myProfile = await HelperFunctions().getUserProfile();
    myUserName = await HelperFunctions().getuserName();
    myEmail = await HelperFunctions().getUserEmail();

  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  initiateSearch()async{
    usersStream= await DatabaseMethods().getUserByUsername(search.text);
  }

  Widget searchUserTile(String imgUrl,name,email,username){
    return GestureDetector(
      onTap: (){
        
        var chatRoomId=getChatRoomId(username,myUserName);
        Map<String,dynamic> chatRoomInfoMap={
          "users":[myUserName,username]
        };
        DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Conversations(userName: username,name: name,imgUrl: imgUrl,)));
      },
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [
              Colors.white12,
              Colors.white54,
              Colors.white60,
              Colors.white70,
              Colors.white
            ]
          )
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
                      child: Center(
                        child: Image.network(
                imgUrl,
                height: 50,
                width: 50,
                ),
                      ),
            ),
            SizedBox(width: 15,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name),
                Text(email)
              ],
            ),
          ],
        ),
      ),
    );

  }

  Widget searchUserList(){
    return StreamBuilder(
      stream: usersStream,
      builder: (context,snapshot){
        return snapshot.hasData ? ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context,index){
            DocumentSnapshot ds=snapshot.data.docs[index];
            return searchUserTile(ds["imgUrl"],ds["name"],ds["email"],ds["username"]);
          }
          ):Center(child: CircularProgressIndicator(),);
      }
      );
  }

  Widget chatRoomList(){
    //print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context,snapshot){
        return snapshot.hasData ? ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context,index){
            DocumentSnapshot ds= snapshot.data.docs[index];
            return ChatRoomListTile(lastMessage: ds["lastMessage"],myUserName: myUserName,chatRoomId: ds.id,) ;
          },
        ): Center(child: CircularProgressIndicator(),);
      },
    );
  }

   getChatRoom()async{
   chatRoomStream= await DatabaseMethods().getChatRooms();
  }

  loadScreen()async{
    await getMyInfoFromSharedPreference();
    getChatRoom();
    setState(() {
      
    });
  }
  @override
  void initState() {
    // TODO: implement initState
     loadScreen();
    super.initState();
  }
  

  @override
 Widget build(BuildContext context)  {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        title: Text("QuickChat"),
        actions: [
          GestureDetector(
            onTap: () {
              AuthMethods().signOut().then((s) {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => SignIn()));
              });
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.logout)),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(

                  child: Column(
            children: [
              Row(
                children: [
                  isSearching
                      ? GestureDetector(
                        onTap: (){
                          setState(() {
                            isSearching=false;
                            search.text="";
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Icon(Icons.arrow_back),
                        ))
                      : Container(),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(8)),
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              style: TextStyle(color: Colors.white),
                              controller: search,
                              decoration: InputDecoration(
                                  hintText: 'Enter Username',
                                  hintStyle: TextStyle(color: Colors.white54),
                                  border: InputBorder.none),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if(search.text!=""){
                                setState(() {
                                
                                isSearching = true;
                                initiateSearch();
                              });
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
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              isSearching ? searchUserList(): chatRoomList(),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatRoomListTile extends StatefulWidget {
  final String chatRoomId,lastMessage,myUserName;
  ChatRoomListTile({this.chatRoomId,this.lastMessage,this.myUserName});
  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  
  String profileUrl="",name="",username="";
  getThisUserInfo()async{
    username= widget.chatRoomId.replaceAll(widget.myUserName, "").replaceAll("_", "");
    QuerySnapshot querySnapshot=await DatabaseMethods().getUserInfo(username);
    name=querySnapshot.docs[0]["name"];
    profileUrl=querySnapshot.docs[0]["imgUrl"];
    setState(() {});
  }
  @override
  void initState() {
    getThisUserInfo();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return profileUrl!="" ? GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Conversations(userName: username,name: name,imgUrl: profileUrl,)));
      },
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(15)
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(profileUrl,width: 50,height: 50,)),
            SizedBox(width: 8,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name),
                SizedBox(height: 5,),
                Text(widget.lastMessage)
              ],
            ),
          ],
        ),
      ),
    ): Container();
  }
}