import 'package:flutter/material.dart';

class Chat_User_Card extends StatefulWidget {
  const Chat_User_Card({super.key});

  @override
  State<Chat_User_Card> createState() => _Chat_User_CardState();
}

class _Chat_User_CardState extends State<Chat_User_Card> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
          onTap: () {},
          child: ListTile(
            tileColor: const Color.fromARGB(221, 196, 179, 179),
            title: Text('User Name'),
            subtitle: Text('Last Message'),
            trailing: Text("12:00pm"),
          )),
    );
  }
}
