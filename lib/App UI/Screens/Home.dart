import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat/App%20UI/Screens/Profile%20Screen.dart';
import 'package:we_chat/App%20UI/Screens/auth/Login%20screen.dart';
import 'package:we_chat/Models/chat%20User.dart';
import 'package:we_chat/Widgets/chat%20User%20card.dart';
import 'package:we_chat/components/Apis.dart';
import 'package:we_chat/components/text/app_text.dart';

class Home_0 extends StatefulWidget {
  const Home_0({super.key});

  @override
  State<Home_0> createState() => _Home_0State();
}

class _Home_0State extends State<Home_0> {
  List<ChatUser> list = [];
  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 61, 199, 132),
          centerTitle: true,
          leading: Icon(CupertinoIcons.home),
          title: Text('We Chat'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => Profile_Screen(user: APIs.me)));
              },
              icon: Icon(Icons.more_vert),
            )
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 61, 199, 132),
            onPressed: () async {
              await APIs.auth.signOut();
              await GoogleSignIn().signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => Login_Screen1()),
              );
            },
            child: Icon(Icons.message_rounded),
          ),
        ),
        body: StreamBuilder(
            stream: APIs.getAllUsers(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                //if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                //if some or all data is loded then
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];
                  if (list.isNotEmpty) {
                    return ListView.builder(
                        itemCount: list.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Chat_User_Card(
                            user: list[index],
                          );
                        });
                  } else {
                    return Center(
                      child: CustomText(
                        title: "Start a Chat",
                        fontSize: 30,
                        color: Colors.greenAccent.shade400,
                      ),
                    );
                  }
              }
            }));
  }
}
