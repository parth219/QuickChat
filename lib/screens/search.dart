import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickchat/services/database.dart';
import 'package:quickchat/widgets/widget.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
   DatabaseMethods databaseMethods=new DatabaseMethods();

  TextEditingController searchinfo=new TextEditingController();
  bool isSearching=false;
  Stream usersStream;
  QuerySnapshot snapshot;
  initiatesearch() async {
    isSearching=true;
    usersStream= await databaseMethods.getUserByUsername(searchinfo.text);
                        
  }

 

  /*
  Widget searchTile(){
    return ListView.builder(
      itemCount: snapshot.docs.length,
      shrinkWrap: true,
      itemBuilder: (context,index){
      return SearchTile(
        username=snapshot.docs[index].data()["name"],
        useremail=snapshot.docs[index].data()["email"]
      );
    });
  }
  */
  Widget searchUsersList(){
    return StreamBuilder(
      stream: usersStream,
      builder: (context,snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context,index){
            DocumentSnapshot ds= snapshot.data.docs[index];
            print(ds["name"]);
            return Text(ds["name"]);
          }
          ): Container(child: Text('Nothing'),);
      });
  }
  @override
  

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
                      onTap: (){
                        if(searchinfo!=""){
                        initiatesearch();}
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
            searchUsersList()
          ],
        ),
      ),
    );
  }
}

class SearchTile extends StatelessWidget {
  final String username;
  final String useremail;
  SearchTile({this.username,this.useremail});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Column(
            children: [
              Text(username,style: textfieldstyle()),
              Text(useremail,style: textfieldstyle(),)
            ],
          ),
          Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(25)
            ),
            child: Text("Message"),
          ),
        ],
      ),
    );
  }
}