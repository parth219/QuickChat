import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickchat/help/helperfunctions.dart';
import 'package:quickchat/services/database.dart';
import 'package:random_string/random_string.dart';

class Conversations extends StatefulWidget {
  final String userName;
  final String name;
  final String imgUrl;
  Conversations({this.name, this.userName, this.imgUrl});
  @override
  _ConversationsState createState() => _ConversationsState();
}

class _ConversationsState extends State<Conversations> {
  String chatRoomId, messageId = "";
  String myName, myProfile, myUserName, myEmail;
  TextEditingController messageController =new TextEditingController();
  Stream messageStream;

  getMyInfoFromSharedPreference() async {
     myName = await HelperFunctions().getDisplayName();
    myProfile = await HelperFunctions().getUserProfile();
    myUserName = await HelperFunctions().getuserName();
    myEmail = await HelperFunctions().getUserEmail();

    chatRoomId = getChatRoomId(myUserName, widget.userName);
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  Widget chatMessageTile(String message,bool isSendByMe){
    return Row(
      mainAxisAlignment: isSendByMe ? MainAxisAlignment.end : MainAxisAlignment.start ,
      children: [
        
        Container(
          
          margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
          decoration: isSendByMe ? BoxDecoration(

            color: Colors.blue,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            )
          ): BoxDecoration(
            color: Colors.black,
            border: Border.all(),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(24),
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24)
            ) 
            ),
          
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: Text(message,style: TextStyle(color: Colors.white,fontSize: 15,),),
        )],
    );
  }

  Widget chatMessages(){
    return StreamBuilder(
      
      stream: messageStream,
      builder: (context,snapshot){
        
        return snapshot.hasData ? ListView.builder(
          //shrinkWrap: true,
          itemCount: snapshot.data.docs.length,
          reverse: true,
          itemBuilder: (context,index){
          
            DocumentSnapshot ds= snapshot.data.docs[index];
            
            return chatMessageTile(ds["message"],myUserName== ds["sendBy"]) ;
          }): Center(child: CircularProgressIndicator(),);
  }
    );
  }

  getAndSetMessages() async{
    messageStream=await DatabaseMethods().getChatRoomMessages(chatRoomId);
    setState(() {
      
    });
  }
 

  doThisAtLaunch() async {
    await getMyInfoFromSharedPreference();
    getAndSetMessages();
  }

  addMessage(bool sendClicked){
    if(messageController.text!=""){
      String message=messageController.text;
      var lastMsgTS=DateTime.now();

      Map<String,dynamic> messageMap={
        "message":message,
        "sendBy":myUserName,
        "ts":lastMsgTS,
      };


      //messageId
      if(messageId==""){
        messageId=randomAlphaNumeric(12);
      }
      DatabaseMethods().addMessage(chatRoomId, messageId, messageMap).then((value){
        Map<String,dynamic> lastMessageMap={
          "lastMessage":message,
          "lastMessageSentTs":lastMsgTS,
          "lastMessageSentBy":myUserName
        };
        DatabaseMethods().updateLastMessageSend(chatRoomId, lastMessageMap);

        if(sendClicked){
          messageController.text="";
          messageId="";
        }
      });
      
    }
  }

  @override
  void initState() {
    doThisAtLaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 60),
              child: chatMessages()),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.black87
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        onChanged: (value){
                          addMessage(false);
                        },
                        controller: messageController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.white70),
                          hintText: "Message...",
                        ),
                      )
                      ), 
                    GestureDetector(
                      onTap: (){
                        addMessage(true);
                      },
                      child: Icon(Icons.send,color: Colors.white70))],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
