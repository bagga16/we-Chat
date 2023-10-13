import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
    debugShowCheckedModeBanner: false,
    initialRoute: 'SplashScreen',
    routes: {
      // 'MyHomePage': (context) => MyHomePage(),
    },
  ));
}
