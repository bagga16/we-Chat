import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/App%20UI/Screens/chat%20Scree.dart';
import 'package:we_chat/Models/chat%20User.dart';
import 'package:we_chat/Models/messgae.dart';
import 'package:we_chat/Utils/my%20date_util.dart';
import 'package:we_chat/components/Apis.dart';
import 'package:we_chat/components/text/app_text.dart';
import 'package:we_chat/main.dart';

class Chat_User_Card extends StatefulWidget {
  final ChatUser user;
  const Chat_User_Card({super.key, required this.user});

  @override
  State<Chat_User_Card> createState() => _Chat_User_CardState();
}

class _Chat_User_CardState extends State<Chat_User_Card> {
  Message? _message;
  late Size mq;
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        // color: Colors.greenAccent.shade100,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
        child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ChatScreen(user: widget.user)));
            },
            child: StreamBuilder(
                stream: APIs.getLastMessage(widget.user),
                builder: (context, snapshots) {
                  final data = snapshots.data?.docs;
                  final list =
                      data?.map((e) => Message.fromJson(e.data())).toList() ??
                          [];
                  if (list.isNotEmpty) _message = list[0];

                  return ListTile(
                      // tileColor: const Color.fromARGB(221, 196, 179, 179),
                      //leading: CircleAvatar(child: Icon(CupertinoIcons.person)),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          height: MediaQuery.of(context).size.height * .06,
                          width: MediaQuery.of(context).size.height * .06,

                          imageUrl: widget.user.image,
                          // progressIndicatorBuilder: (context, url, downloadProgress) =>
                          //     CircularProgressIndicator(value: downloadProgress.progress),
                          errorWidget: (context, url, error) =>
                              CircleAvatar(child: Icon(CupertinoIcons.person)),
                        ),
                      ),
                      title: CustomText(
                        title: widget.user.name,
                        //fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                      subtitle: Text(
                          _message != null ? _message!.msg : widget.user.about,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          )),
                      trailing: _message == null
                          ? null
                          : _message!.read.isEmpty &&
                                  _message!.fromId != APIs.user.uid
                              ? Container(
                                  height: 12,
                                  width: 12,
                                  decoration: BoxDecoration(
                                      color: Colors.greenAccent,
                                      borderRadius: BorderRadius.circular(10)),
                                )
                              : Text(
                                  MyDateUtil.getLastMessageTime(
                                      context: context, time: _message!.sent),
                                  style: TextStyle(color: Colors.black54),
                                ));
                })));
  }
}
