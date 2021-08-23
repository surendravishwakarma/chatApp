import 'package:chatapphesta/UI/conversationScreen.dart';
import 'package:chatapphesta/UI/searchPage.dart';
import 'package:chatapphesta/UTIL/constans.dart';
import 'package:chatapphesta/UTIL/methods.dart';
import 'package:chatapphesta/services/dataBase.dart';
import 'package:chatapphesta/services/helperfun.dart';
import 'package:chatapphesta/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream? chatroomStream;
  DataBaseMethod db = new DataBaseMethod();
  
  Widget chatRoomList(BuildContext context){
    return StreamBuilder(
        stream: chatroomStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data != null && snapshot.data.docs.length > 0) {
            print(">>>>chek length chatapge>>>length>>>>>>>>>>${snapshot.data.docs.length}");
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context,int i) {
                  return ChatLitTile(
                    snapshot.data.docs[i]["chatroomId"].toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName.toString(),""),
                    snapshot.data.docs[i]["chatroomId"],
                  );
                });
          } else {
            return Container();
          }
        });
  }

 // String? username;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    Constants.myName = await HeplShare.getUserSharePrefUserName();
        // Constants.myName = username;
    setState(() {
      db.getChatRoom(Constants.myName.toString()).then((value) {
        chatroomStream = value;
      });
    });
  }

  getLogedInState() async {
    bool? satus;
    bool? val = await HeplShare.getUserSharePrefLogin();
    setState(() {
      satus = val;
    });
    if (satus != null && satus == false) {
      Fluttertoast.showToast(
          msg: "Logout Successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orangeAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          "ChatApp",
          style: TextStyle(
            fontSize: 20.0,
            fontFamily: "SourceSansPro",
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
                onPressed: () {
                  HeplShare.saveUserSharePrefLogin(false);
                  logOut(context);
                  getLogedInState();
                },
                icon: Icon(
                  Icons.logout_outlined,
                  size: 30,
                )),
          )
        ],
      ),
      body: chatRoomList(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.search,
          size: 30.0,
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => SearchPage()));
        },
      ),
    ));
  }
}

class ChatLitTile extends StatefulWidget {
  final String username;
  final String chatroomId;
  ChatLitTile(this.username, this.chatroomId);

  @override
  _ChatLitTileState createState() => _ChatLitTileState();
}

class _ChatLitTileState extends State<ChatLitTile> {
  @override
  Widget build(BuildContext context) {
    print(">>>>>>>>>>>>1username chatLIstTime chatpage>>>>>>>>>>>>>${widget.username}");
    print(">>>>>>>>>>>>2chatroomid>chatListTile>>>>>>>>>>>>${widget.chatroomId}");
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationScreen(
                    name: widget.username, chatroomId: widget.chatroomId)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                "${widget.username.substring(0, 1).toUpperCase()}",style: TextStyle(color: Colors.white,fontSize: 20.0),
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Container(
              child: Text(
                '${widget.username[0].toUpperCase()}${widget.username.substring(1)}',
                style: mediumStyle(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
