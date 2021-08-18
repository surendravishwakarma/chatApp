import 'package:chatapphesta/UTIL/constans.dart';
import 'package:chatapphesta/services/dataBase.dart';
import 'package:chatapphesta/services/helperfun.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String? name;
  final String? chatroomId;
  ConversationScreen({this.name, this.chatroomId});
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController inputMessage = new TextEditingController();
  DataBaseMethod db = new DataBaseMethod();
  Stream? chatMessageStream;

  @override
  void initState() {
    super.initState();
    getUserNameFromPref();
    db.getConversationMessage(widget.chatroomId.toString()).then((val) {
      setState(() {
        chatMessageStream = val;
      });
    });
  }

  Widget chatMessageList() {
    return StreamBuilder(
        stream: chatMessageStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data != null) {
            return Padding(
              padding:  EdgeInsets.only(bottom: 60),
              child: ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, i) {
                    print(">>>>>>>>>message conversation page>>>>>>>>>>>>>>>${snapshot.data.docs[i]["message"]}");
                    print(">>>>>>>>>sendBY conversation page>>>>>>>>>>>>>>>${snapshot.data.docs[i]["sendBy"]}");
                    print(">>>>>>>>>ConstantMyName conversation page>>>>>>>>>>>>>>>${Constants.myName}");
                    return MessageTile(
                      snapshot.data.docs[i]["message"],
                      snapshot.data.docs[i]["sendBy"] == Constants.myName,
                    );
                  }),
            );
          } else {
            return Container(child: Center(child:Text("NO Message"))
            );
          }
        });
  }

  getUserNameFromPref() async {
    String? val = await HeplShare.getUserSharePrefUserName();
    setState(() {
      Constants.myName = val;
    });
  }

  sendMessage() {
    if (inputMessage.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": inputMessage.text,
        "sendBy": Constants.myName.toString(),
        "time": DateTime.now().microsecondsSinceEpoch,
      };
      db.addConversationMessage(widget.chatroomId.toString(), messageMap);
    }
    setState(() {
       setState(() {
        inputMessage.text = "";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: (widget.name != null)
              ? Text(widget.name.toString())
              : Text("NO User")),
      body: Container(
          child: Stack(
        children: [
          chatMessageList(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.blue[300],
              ),
              
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        controller: inputMessage,
                        style: TextStyle(fontSize: 20.0, color: Colors.black),
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          hintText: 'Type a Message...',
                          hintStyle:
                              TextStyle(color: Colors.white54, fontSize: 20.0),
                          border: InputBorder.none,
                        )),
                  ),
                  Container(
                    height: 40,
                    width: 40.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      color: Colors.white,
                    ),
                    child: IconButton(
                      alignment:Alignment.center,
                        onPressed: () {
                          print("pressed search button");
                          sendMessage();
                        },
                        icon: Icon(
                          Icons.send,
                          size: 30,
                        )),
                  ),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}

class MessageTile extends StatefulWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);
  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0,right: 8.0),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            width: MediaQuery.of(context).size.width,
            alignment:
                widget.isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: widget.isSendByMe ? Colors.blue : Colors.blue[100],
                borderRadius: widget.isSendByMe? BorderRadius.only(
                  topRight:Radius.circular(23.0),
                  topLeft:Radius.circular(23.0),
                  bottomLeft:Radius.circular(23.0)
                  ):BorderRadius.only(
                  topRight:Radius.circular(23.0),
                  topLeft:Radius.circular(23.0),
                  bottomRight:Radius.circular(23.0)
                  ),              
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                widget.message,
                style: TextStyle(
                    fontSize: 17,
                    fontFamily: "SourceSansPro",
                    color: widget.isSendByMe?Colors.white:Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SizedBox(height: 15.0,) 
        ],
      ),
    );
  }
}
