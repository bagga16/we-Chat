import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat/App%20UI/Screens/auth/Login%20screen.dart';
import 'package:we_chat/Widgets/chat%20User%20card.dart';

class Home_0 extends StatefulWidget {
  const Home_0({super.key});

  @override
  State<Home_0> createState() => _Home_0State();
}

class _Home_0State extends State<Home_0> {
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
              onPressed: () {},
              icon: Icon(Icons.more_vert),
            )
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 61, 199, 132),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn().signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => Login_Screen1()),
              );
            },
            child: Icon(Icons.message_rounded),
          ),
        ),
        body: ListView.builder(
            itemCount: 3,
            itemBuilder: (context, index) {
              return Chat_User_Card();
            }));
  }
}
