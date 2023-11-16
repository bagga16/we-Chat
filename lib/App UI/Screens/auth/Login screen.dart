import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat/App%20UI/Screens/Home.dart';
import 'package:we_chat/Utils/Dialoges.dart';
import 'package:we_chat/components/Apis.dart';
import 'package:we_chat/components/text/app_text.dart';
import 'package:we_chat/main.dart';

class Login_Screen1 extends StatefulWidget {
  const Login_Screen1({super.key});

  @override
  State<Login_Screen1> createState() => _Login_Screen1State();
}

class _Login_Screen1State extends State<Login_Screen1>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
  }

  _handleGoogleBtnClick() {
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async {
      Navigator.pop(context);
      if (user != null) {
        log('\nUser: ${user.user} ');
        log('UserAdditionalInfo: ${user.additionalUserInfo} ');
        if ((await APIs.userExists())) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => Home_0()),
          );
        } else {
          await APIs.createUser().then((value) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => Home_0()),
            );
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle: $e');
      Dialogs.showSnackbar(context,
          'Something Went Wrong Please check your Internet Connection');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 61, 199, 132),
        centerTitle: true,
        title: Text('Welcome to We Chat'),
      ),
      body: Container(
        height: mq.height,
        width: mq.width,
        color: Colors.white,
        child: Column(
          children: [
            SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0, 2), // Start from bottom
                end: Offset.zero,
              ).animate(_animation),
              child: FadeTransition(
                opacity: _animation,
                child: Image(
                  image: AssetImage('assets/images/chat.png'),
                  height: mq.height / 4,
                  width: mq.width / 2.5,
                ),
              ),
            ),
            SizedBox(
              height: 400,
            ),
            Container(
              height: 45,
              width: mq.width - 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.transparent,
              ),
              child: InkWell(
                onTap: () {
                  _handleGoogleBtnClick();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(image: AssetImage('assets/images/google.png')),
                    CustomText(
                      title: '   Login with ',
                      fontWeight: FontWeight.w500,
                    ),
                    CustomText(
                      title: 'Google',
                      fontSize: 24,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
