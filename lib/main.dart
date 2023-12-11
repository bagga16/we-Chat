import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:we_chat/App%20UI/Screens/Home.dart';
import 'package:we_chat/App%20UI/Screens/auth/Login%20screen.dart';
import 'package:we_chat/App%20UI/Splash%20Screen.dart';

late Size mq;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: FirebaseOptions(
              apiKey: "AIzaSyDBYL8VZmGRLitJU4kA1n3lSLIobDVzm_Q",
              appId: "1:269110250249:android:93a9cc1c81d7372a88e1d8",
              messagingSenderId: "269110250249",
              projectId: "we-chat-34cc7"))
      : await Firebase.initializeApp();

  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  runApp(MaterialApp(
    title: "We Chat",
    theme: ThemeData(primaryColor: Colors.greenAccent),
    debugShowCheckedModeBanner: false,
    initialRoute: 'Splash_Screen',
    routes: {
      'Splash_Screen': (context) => Splash_Screen(),
      'Home_0': (context) => Home_0(),
      'Login_Screen1': (context) => Login_Screen1()

      // 'MyHomePage': (context) => MyHomePage(),
    },
  ));

  var result = await FlutterNotificationChannel.registerNotificationChannel(
    description: 'For Showing Message Notification',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Chats',
  );
  print('\nNotifiaction Channel Result: $result');
}
