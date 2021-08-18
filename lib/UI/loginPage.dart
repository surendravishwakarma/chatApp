import 'package:chatapphesta/UI/chatPage.dart';
import 'package:chatapphesta/UI/signupPage.dart';
import 'package:chatapphesta/UTIL/constans.dart';
import 'package:chatapphesta/UTIL/methods.dart';
import 'package:chatapphesta/services/dataBase.dart';
import 'package:chatapphesta/services/helperfun.dart';
import 'package:chatapphesta/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<LoginPage> {
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  DataBaseMethod db = new DataBaseMethod();
  bool _obscureText = true;
  QuerySnapshot? searchSnapShot;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<bool?> showWarning(BuildContext context) async => showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Do you want to exit app ?"),
            actions: [
              ElevatedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text("No")),
              ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text("Yes")),
            ],
          ));

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shoupldPop = await showWarning(context);
        return shoupldPop ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          title: Text(
            "LogIn",
            style: boldStyle(),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(
                  height: 100,
                ),
                Container(
                  child: Center(
                    child: Text(
                      "Chat",
                      style: TextStyle(
                          fontSize: 38.0,
                          fontFamily: "SourceSansPro",
                          fontWeight: FontWeight.w400,
                          color: Colors.blue),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: Container(
                    height: 50.0,
                    decoration: commonBoxdecoration(),
                    child: Row(
                      children: [
                        Padding(
                            padding: padingEdge(),
                            child: Icon(
                              Icons.email,
                              color: Colors.grey[400],
                            )),
                        Expanded(
                          child: Container(
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              cursorColor: Colors.black,
                              decoration:
                                  textFieldInputDecoration("andrea@app.com"),
                              controller: _email,
                              onSaved: (input) => _email.text != input,
                              validator: (val) {
                                RegExp regExp = new RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                                if (val!.length == 0) {
                                  return 'Please enter email';
                                } else if (!regExp.hasMatch(val)) {
                                  return 'Please enter valid email';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: Container(
                    height: 50.0,
                    decoration: commonBoxdecoration(),
                    child: Row(
                      children: [
                        Padding(
                            padding: padingEdge(),
                            child: Icon(
                              Icons.lock,
                              color: Colors.grey[400],
                            )),
                        Expanded(
                          child: TextFormField(
                            obscureText: _obscureText,
                            cursorColor: Colors.black,
                            decoration: textFieldInputDecoration("password"),
                            controller: _password,
                            onSaved: (input) => _password.text != input,
                            validator: (input) {
                              if (input!.isEmpty) {
                                return "Please enter password";
                              }
                              return null;
                            },
                          ),
                        ),
                        TextButton(
                            onPressed: _toggle,
                            child: new Text(_obscureText ? "Show" : "Hide"))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Container(
                  height: 45,
                  child: Padding(
                    padding: EdgeInsets.only(left: 80, right: 80.0),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    side: BorderSide(
                                        color: Colors.blue, width: 2.0)))),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            logIn(_email.text, _password.text).then((user) {
                              if (user != null) {
                                db.getUserByEmail(_email.text).then((val) {
                                  print(val.toString());
//get from tha database username name and email

                                  searchSnapShot = val;
                                  String dataname =
                                      searchSnapShot!.docs[0].get("name");
                                  String dataEmail =
                                      searchSnapShot!.docs[0].get("email");

                                  print(">dataname>>>>>>>>>>>>>>>>>$dataname");
                                  print(">>>>>>>>>>>dataEmail>>>$dataEmail");
                                  Constants.myName =
                                      searchSnapShot!.docs[0].get("name");
                                  print(
                                      ">>>>mayName>>>>>>>>>>>>>>>>${Constants.myName}");
//save name to sharePref ,fetch from db

                                  HeplShare.saveUserSharePrefUserName(
                                      searchSnapShot!.docs[0].get("name"));
                                  setState(() {});
                                });

                                //email save
                                HeplShare.saveUserSharePrefEmail(_email.text);
                                HeplShare.saveUserSharePrefLogin(true);

                                Fluttertoast.showToast(
                                    msg: "Login Successful",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.orangeAccent,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatPage()));
                              } else if (user == null) {
                                Fluttertoast.showToast(
                                    msg: "User not found",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.orangeAccent,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            });
                          }
                        },
                        child: Text(
                          "Get Start",
                          style: boldStyle(),
                        )),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Container(
                        child: Icon(
                          Icons.facebook,
                          color: Colors.blue,
                          size: 30.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Container(
                        child: Icon(
                          FontAwesomeIcons.linkedin,
                          color: Colors.blue,
                          size: 23.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        child:Icon(FontAwesomeIcons.twitter,size: 28.0,color: Colors.blue,)
                      ),
                    ),
                    Expanded(
                        child: Container(
                            height: 45.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30.0),
                                        bottomLeft: Radius.circular(30.0),
                                      )),
                                      primary: Colors.blue.shade200,
                                      textStyle: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignupPage()));
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "or",
                                        style: boldStyle(),
                                      ),
                                      Text("SignUp", style: boldStyle())
                                    ],
                                  )),
                            ))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
