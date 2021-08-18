import 'package:chatapphesta/UI/conversationScreen.dart';
import 'package:chatapphesta/UTIL/constans.dart';
import 'package:chatapphesta/services/dataBase.dart';
import 'package:chatapphesta/services/helperfun.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchCont = new TextEditingController();
  String? searchUser = "";
  DataBaseMethod db = new DataBaseMethod();
  QuerySnapshot? searchSnapShot;
  

  initiateSearch() {
    db.getUserByUsername(_searchCont.text).then((val) {
      print(val.toString());
      searchSnapShot = val;
      setState(() {});
    });
  }



  Widget searchList() {
    return searchSnapShot != null
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: searchSnapShot!.docs.map((data1) {
                print(">>>>>>>>>>>>>>>fetched user from firestore");
                print(data1["name"]);
                print(data1['email']);
                return Container(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 18.0),
                    child: Row(
                      children: [
                        Container(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                child: Text(
                              data1["name"],
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: "SourceSansPro",
                                  fontWeight: FontWeight.w600),
                            )),
                            Container(
                                child: Text(
                              data1["email"],
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: "SourceSansPro",
                                  fontWeight: FontWeight.w600),
                            )),
                          ],
                        )),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            print("pressed button");
                            print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>${data1["name"]}");
                            createChatroomAndStartConversation(useranme:data1["name"]);
                          },
                          child: Container(
                              height: 40.0,
                              width: 100.0,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 19, vertical: 12),
                              child: Text("Message")),
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        : Container();
  }
 
 @override
  void initState() {
    super.initState();
//fetchMyName();
  }

  fetchMyName()async{
      Constants.myName=await HeplShare.getUserSharePrefUserName();
      setState(() {
        
      });
  }
  //create chatroom, send user to conversation screen 
  createChatroomAndStartConversation({useranme}) {
  print(">>>>>>>>>>>>>>cratechatt by >>>>>>>>>>>>>>>>>>$useranme");
  print(">>>>>createchat Constant myName to>>>>>>${Constants.myName}");  

String chatroomId= getChatRoomId(useranme,Constants.myName);
      print(">>>>>>>>>myName>>>>>>>>>>>>>>>>>>>${Constants.myName}");
      print(">>>>>>>>>chatroomId>>>>>>>>>>>>>>>>>>>$chatroomId");
     List<String?> usersList=[useranme,Constants.myName];
    Map<String,dynamic> dataMap={
      "users":usersList,
      "chatroomId":chatroomId
    };
     DataBaseMethod().chatRoom(chatroomId, dataMap);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ConversationScreen(name: useranme,chatroomId:chatroomId)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Container(
        decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Colors.amberAccent, Colors.blue])),
        child: Text(
          "Search",
          style: TextStyle(fontSize: 20.0),
        ),
      )),
      body: Container(
        child: ListView(
          children: [
            Container(
              color: Colors.blueGrey,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        controller: _searchCont,
                        onChanged: (value) {
                          searchUser = value;
                        },
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          hintText: 'Search Username...',
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
                        onPressed: () {
                          print("pressed search button");
                          initiateSearch();
                        },
                        icon: Icon(
                          Icons.search,
                          size: 30,
                        )),
                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}




getChatRoomId(String? a, String? b) {
  if (a!.substring(0, 1).codeUnitAt(0) > b!.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
