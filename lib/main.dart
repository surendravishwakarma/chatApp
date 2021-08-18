import 'package:chatapphesta/UI/chatPage.dart';
import 'package:chatapphesta/UI/loginPage.dart';
import 'package:chatapphesta/services/helperfun.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? isLogin = false;
  
  @override
  void initState() {
    super.initState();
    getLogedInState();
  }

  getLogedInState() async {
    bool? val = await HeplShare.getUserSharePrefLogin();
    String? uid=await HeplShare.getUIDValue();
    setState(() {
      print(">>>>>>>>>>>>>>>loginvalue>>>>>>>>>>>>>>>>>>>$val");
       print(">>>>>>>>>>>>>>>uid value get from shared pref>>>>>>>>>>>>>>>>>>>$uid");
      isLogin = val;
    });

//or  both functios are give same output 

// await HeplShare.getUserSharePrefLogin().then((value){
//   isLogin=value;
// });


  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:(isLogin != null && isLogin == true) ? ChatPage():LoginPage(),
    );
  }
}
