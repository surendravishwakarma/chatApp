import 'package:chatapphesta/UI/chatPage.dart';
import 'package:chatapphesta/UI/loginPage.dart';
import 'package:chatapphesta/services/helperfun.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//foreground
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print(message.notification!.title);
  print(message.notification!.body);
   flutterLocalNotificationsPlugin.show(
            message.notification.hashCode,
            message.notification!.title,
            message.notification!.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: 'launch_background',
              ),
            ));

}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
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
    var initializationSettingsAndroid=AndroidInitializationSettings('@mipmap/ic_launcher');
       var initializationSettingsIos=IOSInitializationSettings(requestAlertPermission:true);
    var initalizationSettings=InitializationSettings(android:initializationSettingsAndroid,iOS:initializationSettingsIos);
    flutterLocalNotificationsPlugin.initialize(initalizationSettings);


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: 'launch_background',
              ),
            ));
      }
    });
    getLogedInState();
    getToken();
  }

  getLogedInState() async {
    bool? val = await HeplShare.getUserSharePrefLogin();
    String? uid = await HeplShare.getUIDValue();
    setState(() {
      print(">>>>>>>>>>>>>>>loginvalue>>>>>>>>>>>>>>>>>>>$val");
      print(">>>>>>>uid value get from shared pref>>>>>>>>>>>>>>>>>>>$uid");
      isLogin = val;
    });
  }

  getToken() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    print(">>>>>>>>>>>>>>fcm toekn>>>>>>>>>>>$fcmToken");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: (isLogin != null && isLogin == true) ? ChatPage() : LoginPage(),
    );
  }
}
