import '../main.dart';
import '../api/apis.dart';
import '../models/message.dart';
import '../models/chat_user.dart';
import '../screens/chat_screen.dart';
import 'dialogs/profile_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:app/helper/my_date_until.dart';
import 'package:cached_network_image/cached_network_image.dart';


//card to represent a single user in home screen
class HomeUserCard extends StatefulWidget {
  final ChatUser user;

  const HomeUserCard({super.key, required this.user});

  @override
  State<HomeUserCard> createState() => _HomeUserCardState();
}

class _HomeUserCardState extends State<HomeUserCard> {
  //last message info (if null --> no message)
  Message? _message;

  @override
  Widget build(BuildContext context) {
    
    return 
    
    ListView(
      children: 
      [

          Card(
        margin: EdgeInsets.symmetric(horizontal: mq.width * .10, vertical: 4),
        // color: Colors.blue.shade100,
        elevation: 0.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: InkWell(
            onTap: () {
              //for navigating to chat screen
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ChatScreen(user: widget.user),
                      ),
                      );
            },
            child: StreamBuilder(
              stream: APIs.getLastMessage(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final list =
                    data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
                if (list.isNotEmpty) _message = list[0];
    
                return ListTile(
                  //user profile picture
                  leading: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => ProfileDialog(user: widget.user));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(mq.height * .03),
                      child: CachedNetworkImage(
                        width: mq.height * .055,
                        height: mq.height * .055,
                        imageUrl: widget.user.image,
                        errorWidget: (context, url, error) => const CircleAvatar(
                            child: Icon(CupertinoIcons.person)),
                      ),
                    ),
                  ),
    
                  //user name
                  title: Text(widget.user.username),
    
                  //last message
                  subtitle: Text(
                      _message != null
                          ? _message!.type == Type.image
                              ? 'image'
                              : _message!.msg
                          : widget.user.selfIntro,
                      maxLines: 1),
    
                  //last message time
                  trailing: _message == null
                      ? null //show nothing when no message is sent
                      : _message!.read.isEmpty &&
                              _message!.fromId != APIs.user.uid
                          ?
                          //show for unread message
                          Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                  color: Colors.greenAccent.shade400,
                                  borderRadius: BorderRadius.circular(10)),
                            )
                          :
                          //message sent time
                          Text(
                              MyDateUtil.getLastMessageTime(
                                  context: context, time: _message!.sent),
                              style: const TextStyle(color: Colors.black54),
                            ),
                );
              },
            ),
            ),
      ),
      ],

    );
  }
}