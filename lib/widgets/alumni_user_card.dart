import 'package:app/main.dart';
import 'package:app/api/apis.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:app/models/message.dart';
import 'package:app/models/chat_user.dart';
import 'package:app/screens/chat_screen.dart';
import 'package:app/helper/my_date_until.dart';
import 'package:app/widgets/dialogs/profile_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';


// version 4

class AlumniUserCard extends StatefulWidget {
  final ChatUser user;
  final bool isCurrentUser;

  const AlumniUserCard({
    Key? key,
    required this.user,
    this.isCurrentUser = false,
  }) : super(key: key);

  @override
  _AlumniUserCardState createState() => _AlumniUserCardState();
}

class _AlumniUserCardState extends State<AlumniUserCard> {
  // Last message info (if null, there is no message)
  Message? _message;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.all(8.0),
        elevation: 0.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(user: widget.user),
              ),
            );
          },
          child: Column(
            children: [
              StreamBuilder(
                stream: APIs.getLastMessage(widget.user),
                builder: (context, snapshot) {
                  final data = snapshot.data?.docs;
                  final list = data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
                  if (list.isNotEmpty) _message = list[0];
      
                  return Row(
                    children: [
                      InkWell(
                          onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProfileDialog(user: widget.user),
                          ),
                        );
                      },
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(widget.user.image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user.username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${widget.user.universities.join(', ')}',
                            maxLines: 1,
                          ),
                          Text(
                            '${widget.user.schools.join(', ')}',
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

