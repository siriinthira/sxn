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

// import '../main.dart';
// import '../api/apis.dart';
// import '../models/message.dart';
// import '../screens/chat_screen.dart';
// import 'dialogs/profile_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:app/models/chat_user.dart';
// import 'package:app/helper/my_date_until.dart';
// import 'package:cached_network_image/cached_network_image.dart';



// card to represent a single user in home screen

// class FilterUserCard extends StatefulWidget {
//     final ChatUser user;


//   const FilterUserCard({super.key, required this.user});

//   @override
//   State<FilterUserCard> createState() => _FilterUserCardState();
// }

// class _FilterUserCardState extends State<FilterUserCard> {
//   //last message info (if null --> no message)
//   Message? _message;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Card(
//         margin: EdgeInsets.symmetric(horizontal: mq.width * .00005, vertical: 8),
//         // color: Colors.blue.shade100,
//         elevation: 0.5,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         child: InkWell(
//             onTap: () {
//               //for navigating to chat screen
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (_) => ChatScreen(user: widget.user),
//                       ),
//                       );
//             },
//             child: StreamBuilder(
//               stream: APIs.getLastMessage(widget.user),
//               builder: (context, snapshot) {
//                 final data = snapshot.data?.docs;
//                 final list =
//                     data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
//                 if (list.isNotEmpty) _message = list[0];
    
//                 return ListTile(
//                   //user profile picture
//                   leading: InkWell(
//                     onTap: () {
//                       showDialog(
//                           context: context,
//                           builder: (_) => ProfileDialog(user: widget.user));
//                     },
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(mq.height * .03),
//                       child: CachedNetworkImage(
//                         width: mq.height * .055,
//                         height: mq.height * .055,
//                         imageUrl: widget.user.image,
//                         errorWidget: (context, url, error) => const CircleAvatar(
//                             child: Icon(CupertinoIcons.person)),
//                       ),
//                     ),
//                   ),
    
//                   //user name
//                   title: Text(widget.user.username),
    
//                   //last message
//                   subtitle: Text(widget.user.occupation.join(',\n '),),
                  
//                   // Text(
//                   //     _message != null
//                   //         ? _message!.type == Type.image
//                   //             ? 'image'
//                   //             : _message!.msg
//                   //         : widget.user.selfIntro,
//                   //     // maxLines: 1
//                   //     ),
    
//                   //last message time
//                   trailing:  
//                   Text(widget.user.skills.join(',\n '),),
//                   //Text(widget.user.skills as String),
                  
//                   // _message == null
//                   //     ? null //show nothing when no message is sent
//                   //     : _message!.read.isEmpty &&
//                   //             _message!.fromId != APIs.user.uid
//                   //         ?
//                   //         //show for unread message
//                   //         Container(
//                   //             width: 15,
//                   //             height: 15,
//                   //             decoration: BoxDecoration(
//                   //                 color: Colors.greenAccent.shade400,
//                   //                 borderRadius: BorderRadius.circular(10)),
//                   //           )
//                   //         :
//                   //         //message sent time
//                   //         Text(
//                   //             MyDateUtil.getLastMessageTime(
//                   //                 context: context, time: _message!.sent),
//                   //             style: const TextStyle(color: Colors.black54),
//                   //           ),
    
    
    
//                 );
//               },
//             ),
//             ),
//       ),
//     );
//   }
// }




// version 2 

// class FilterUserCard extends StatefulWidget {
//   final ChatUser user;

//   const FilterUserCard({Key? key, required this.user}) : super(key: key);

//   @override
//   _FilterUserCardState createState() => _FilterUserCardState();
// }

// class _FilterUserCardState extends State<FilterUserCard> {
//   // Last message info (if null, there is no message)
//   Message? _message;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.all(8), // Adjust the margin as needed
//       elevation: 0.5,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: InkWell(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => ChatScreen(user: widget.user)),
//           );
//         },
//         child: ListTile(
//           contentPadding: const EdgeInsets.all(16),
//           leading: Container(
//             width: 56,
//             height: 56,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               image: DecorationImage(
//                 image: CachedNetworkImageProvider(widget.user.image),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           title: Text(
//             widget.user.username,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//             ),
//           ),
//           subtitle: Text(
//             _message != null
//                 ? _message!.type == Type.image ? 'Image' : _message!.msg
//                 : widget.user.selfIntro,
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//           trailing: _message == null
//               ? null
//               : _message!.read.isEmpty && _message!.fromId != APIs.user.uid
//               ? Container(
//             width: 15,
//             height: 15,
//             decoration: BoxDecoration(
//               color: Colors.greenAccent.shade400,
//               shape: BoxShape.circle,
//             ),
//           )
//               : Text(
//             MyDateUtil.getLastMessageTime(
//               context: context,
//               time: _message!.sent,
//             ),
//             style: TextStyle(color: Colors.black54),
//           ),
//         ),
//       ),
//     );
//   }
// }



// version 3

// class FilterUserCard extends StatefulWidget {
//   final ChatUser user;
//   final bool isCurrentUser;

//   const FilterUserCard({
//     Key? key,
//     required this.user,
//     this.isCurrentUser = false,
//   }) : super(key: key);

//   @override
//   _FilterUserCardState createState() => _FilterUserCardState();
// }

// class _FilterUserCardState extends State<FilterUserCard> {
//   // Last message info (if null, there is no message)
//   Message? _message;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.all(8),
//       elevation: 0.5,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: InkWell(



//         onTap: () {

//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => ChatScreen(user: widget.user),
//               ),
//             );
//           // if (widget.isCurrentUser) {
//           //   showDialog(
//           //     context: context,
//           //     builder: (_) => ProfileDialog(user: widget.user),
//           //   );
//           // } else {
//           //   Navigator.push(
//           //     context,
//           //     MaterialPageRoute(
//           //       builder: (_) => ChatScreen(user: widget.user),
//           //     ),
//           //   );
//           // }
//         },
//         child: ListTile(
//           contentPadding: const EdgeInsets.all(16),
//           leading: Container(
//             width: 56,
//             height: 56,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               image: DecorationImage(
//                 image: CachedNetworkImageProvider(widget.user.image),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           title: Text(
//             widget.user.username,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//             ), textAlign: TextAlign.center,
//           ),
//           subtitle: 
//            Text(widget.user.occupation.join(' ,') , maxLines: 1,),
//           trailing: 
//           Text(widget.user.skills.join(' ,') , maxLines: 1,),
//         ),
//       ),
//     );
//   }
// }





// version 4

class FilterUserCard extends StatefulWidget {
  final ChatUser user;
  final bool isCurrentUser;

  const FilterUserCard({
    Key? key,
    required this.user,
    this.isCurrentUser = false,
  }) : super(key: key);

  @override
  _FilterUserCardState createState() => _FilterUserCardState();
}

class _FilterUserCardState extends State<FilterUserCard> {
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
                            '${widget.user.occupation.join(', ')}',
                            maxLines: 1,
                          ),
                          Text(
                            '${widget.user.skills.join(', ')}',
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


//version 5