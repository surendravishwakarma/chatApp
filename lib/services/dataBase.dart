import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethod {
  getUserByUsername(username) {
    return FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserByEmail(userEmail) {
    return FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  uploadUserInfo(userSignUpMap) {
    print(">>>>>>>>>>>>>>>>>>>>>>>map>>>>>>>>>>>>${userSignUpMap.toString()}");
    FirebaseFirestore.instance
        .collection("users")
        .add(userSignUpMap)
        .catchError((e) {
      print(e.toString());
    });
  }
//create chat room
  chatRoom(String chatRoomId, chatroomMap) {
    FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatRoomId)
        .set(chatroomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessage(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessage(String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRoom(String userName) async {
    return await FirebaseFirestore.instance
        .collection("chatroom")
        .where("users", arrayContains: userName)
        .snapshots();
  }
}
