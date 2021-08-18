

import 'package:shared_preferences/shared_preferences.dart';
class HeplShare{

static String sharePrefLogedinKey="LOGEDIN";
static String sharePrefUserNameKey="USERNAMEKEY";
static String sharePrefUserEmailKey="USEREMAILKEY";
static String uidKey="uid";


// save in shared pref
static Future<bool> saveUserSharePrefLogin(bool isUserLogedIn)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setBool(sharePrefLogedinKey, isUserLogedIn);
}  

static Future<bool> saveUserSharePrefUserName(String username)async{
  print(">>>>>>>>>>>>>>>>>>>>save user name$username");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setString(sharePrefUserNameKey, username);
}  

static Future<bool> saveUserSharePrefEmail(String useremail)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setString(sharePrefUserEmailKey, useremail);
}  

static Future<bool> uidValueSaveSharePref(String uidValue)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setString(uidKey, uidValue);
} 

// fetch from shared pref

static Future<bool?> getUserSharePrefLogin()async{
  SharedPreferences fetch = await SharedPreferences.getInstance();
  return  fetch.getBool(sharePrefLogedinKey);
} 

static Future<String?> getUserSharePrefUserName()async{
  SharedPreferences fetch = await SharedPreferences.getInstance();
  return  fetch.getString(sharePrefUserNameKey);
} 


static Future<String?> getUserEmail()async{
  SharedPreferences fetch = await SharedPreferences.getInstance();
  return  fetch.getString(sharePrefUserEmailKey);
}

static Future<String?> getUIDValue()async{
  SharedPreferences fetch = await SharedPreferences.getInstance();
  return  fetch.getString(uidKey);
}


}