import 'package:chatapphesta/UI/loginPage.dart';
import 'package:chatapphesta/services/helperfun.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<User?> logIn(String email,String password)async{
  FirebaseAuth _auth=FirebaseAuth.instance;
   try{
     User? user=(await _auth.signInWithEmailAndPassword(email: email, password: password)).user;
         String? uidValue=_auth.currentUser!.uid;
     print(">>>>>>>>>>>>>uid value after usee login methods>>>>>>>>>>>>>>>>>>>>>>>$uidValue");
     if(user!=null){
       return user;
     }else{
       return user;
     }
   }
 catch(e){
   print(">>>>>>>>>>>>>>>>>>>error show >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    print(e);
    return null;
  }
}

Future<User?> signUp(String email,String password)async{
  FirebaseAuth _auth=FirebaseAuth.instance;
   try{
     User? user=(await _auth.createUserWithEmailAndPassword(email: email, password: password)).user;
     String? uidValue=_auth.currentUser!.uid;
     print(">>>>>>>>>>>>>uid value after create user or signup>>>>>>>>>>>>>>>>>>>>>>>$uidValue");
     HeplShare.uidValueSaveSharePref(uidValue);
     if(user!=null){
       return user;
     }else{
       print("SignUp failed");
       return user;
     }
   }
 catch(e){
    print(e);
    return null;
  }
}

Future<User?> logOut(BuildContext context)async{
  FirebaseAuth _auth=FirebaseAuth.instance;
   try{
      _auth.signOut();
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>LoginPage()));
   }
 catch(e){
    print(e);
    return null;
  }
}

