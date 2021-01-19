import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickchat/help/helperfunctions.dart';

class DatabaseMethods {
  addUserInfo(String userId, Map<String, dynamic> userInfoMap) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getUserByUsername(String userName) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: userName)
        .snapshots();
  }

  Future addMessage(String chatRoomId, String messageId, Map messageMap) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageMap);
  }

  updateLastMessageSend(String chatRoomId, Map lastMessageMap) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(lastMessageMap);
  }

  createChatRoom(String chatRoomId, Map chatRoomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();

    if (snapShot.exists) {
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection('chats')
        .orderBy("ts", descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getChatRooms() async {
    String myName = await HelperFunctions().getuserName();

    return FirebaseFirestore.instance
        .collection("chatrooms")
        .orderBy("lastMessageSentTs", descending: true)
        .where("users", arrayContains: myName)
        .snapshots();
  }

  Future<QuerySnapshot>getUserInfo(String userName) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: userName)
        .get();
  }
}
