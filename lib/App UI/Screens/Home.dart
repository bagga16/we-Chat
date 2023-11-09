import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          onPressed: () {},
          child: Icon(Icons.message_rounded),
        ),
      ),
    );
  }
}
