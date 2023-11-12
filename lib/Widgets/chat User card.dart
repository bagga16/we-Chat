import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/Models/chat%20User.dart';
import 'package:we_chat/components/text/app_text.dart';
import 'package:we_chat/main.dart';

class Chat_User_Card extends StatefulWidget {
  final ChatUser user;
  const Chat_User_Card({super.key, required this.user});

  @override
  State<Chat_User_Card> createState() => _Chat_User_CardState();
}

class _Chat_User_CardState extends State<Chat_User_Card> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      // color: Colors.greenAccent.shade100,
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
      child: InkWell(
          onTap: () {},
          child: ListTile(
              // tileColor: const Color.fromARGB(221, 196, 179, 179),
              leading: CircleAvatar(child: Icon(CupertinoIcons.person)),
              title: CustomText(
                title: widget.user.name,
                //fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
              subtitle: CustomText(
                title: widget.user.about,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              trailing: CustomText(
                title: '12:00pm',
                color: Colors.black54,
                fontSize: 14,
              ))),
    );
  }
}
