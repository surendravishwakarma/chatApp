import 'package:chatapphesta/UI/loginPage.dart';
import 'package:chatapphesta/services/dataBase.dart';
import 'package:chatapphesta/services/helperfun.dart';
import 'package:flutter/material.dart';
import 'package:chatapphesta/UTIL/methods.dart';
import 'package:chatapphesta/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupPage extends StatefulWidget {
  final Function? toggle;
  SignupPage({this.toggle});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController _username = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _phoneNumber = new TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  DataBaseMethod updateValueInDB = new DataBaseMethod();
  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Register Account", style: boldStyle()),
        elevation: 0.0,
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
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: Container(
                  height: 50.0,
                  decoration: commonBoxdecoration(),
                  child: Row(
                    children: [
                      Padding(
                        padding: padingEdge(),
                        child: Container(
                            child: Center(
                                child: Icon(
                          Icons.account_box,
                          color: Colors.grey[400],
                        ))),
                      ),
                      Expanded(
                        child: Container(
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            cursorColor: Colors.black,
                            decoration: textFieldInputDecoration("User Name"),
                            controller: _username,
                            onSaved: (input) => _password.text != input,
                            validator: (input) {
                              if (input!.isEmpty) {
                                return "user name";
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
                        child: Container(
                            child: Center(
                                child: Icon(
                          Icons.email,
                          color: Colors.grey[400],
                        ))),
                      ),
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
                        child: Container(
                            child: Center(
                                child: Icon(
                          Icons.lock,
                          color: Colors.grey[400],
                        ))),
                      ),
                      Expanded(
                        child: Container(
                          child: TextFormField(
                            obscureText: _obscureText,
                            cursorColor: Colors.black,
                            decoration: textFieldInputDecoration("password"),
                            controller: _password,
                            onSaved: (input) => _password.text != input,
                            validator: (input) {
                              if (input!.isEmpty) {
                                return "user password";
                              } else if (input.length < 6) {
                                return 'Password should be 6 digit.';
                              }
                              return null;
                            },
                          ),
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
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: Container(
                  height: 50.0,
                  decoration: commonBoxdecoration(),
                  child: Row(
                    children: [
                      Padding(
                        padding: padingEdge(),
                        child: Container(
                            child: Center(
                                child: Icon(
                          Icons.phone,
                          color: Colors.grey[400],
                        ))),
                      ),
                      Expanded(
                        child: Container(
                          child: TextFormField(
                            maxLength: 10,
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.black,
                            decoration:
                                textFieldInputDecoration("Phone Number"),
                            controller: _phoneNumber,
                            onSaved: (input) => _password.text != input,
                            validator: (input) {
                              if (input!.isEmpty) {
                                return "Required field";
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
                height: 50.0,
              ),
              Container(
                height: 40,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: BorderSide(
                                          color: Colors.blue, width: 2.0)))),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => LoginPage()));
                          },
                          child: Text(
                            "SignIn",
                            style: boldStyle(),
                          )),
                      ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: BorderSide(
                                          color: Colors.blue, width: 2.0)))),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Map<String, String> userSignUpMap = {
                                "name": _username.text,
                                "email": _email.text,
                                "password": _password.text,
                                "phone": _phoneNumber.text,
                              };

                              HeplShare.saveUserSharePrefUserName(
                                  _username.text);
                              HeplShare.saveUserSharePrefEmail(_email.text);
                              updateValueInDB.uploadUserInfo(userSignUpMap);
                              
                              signUp(_email.text, _password.text).then((user) {
                                if (user != null) {
                                  Fluttertoast.showToast(
                                      msg: "SignUp Successful",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.orangeAccent,
                                      textColor: Colors.white,
                                      fontSize: 16.0);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => LoginPage()));
                                }else{
                                   Fluttertoast.showToast(
                                      msg: "AlreadyEmail Registered",
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
                            "SignUp",
                            style: boldStyle(),
                          )),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              SizedBox(
                height: 30.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
