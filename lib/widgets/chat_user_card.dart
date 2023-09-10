import 'package:app/main.dart';
import 'package:app/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {

  final ChatUser user;
  
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return  Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * 0.04, vertical: 4),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {},
        child: ListTile(
          // User profile picture
          leading: CircleAvatar(child: Icon(CupertinoIcons.person)),
          // User name
          title: Text(widget.user.username),
          // User id
          subtitle: Text(widget.user.id),
          // User email
          trailing: Text(widget.user.email, style: TextStyle(color: Colors.black54)),
        ),
      ),
    );
  }
}


 //Text(widget.user.username),