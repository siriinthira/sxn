// import '../main.dart';
// import 'dart:developer';
// import '../api/apis.dart';
// import 'profile_screen.dart';
// import '../helper/dialogs.dart';
// import '../models/chat_user.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:card_swiper/card_swiper.dart';
// import 'package:app/widgets/chat_user_card.dart';
// import 'package:app/screens/contact_screen.dart';
// import 'package:app/widgets/home_user_card.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:app/widgets/search_filter_user_card.dart';





// //home screen -- where all available contacts are shown
// class NewHomeScreen extends StatefulWidget {
//   const NewHomeScreen({super.key});

//   @override
//   State<NewHomeScreen> createState() => _NewHomeScreenState();
// }

// class _NewHomeScreenState extends State<NewHomeScreen> {
  
//   // for storing all users : Your list of ChatUser data
//   List<ChatUser> _list = [];

//   // for storing searched items
//   // List<ChatUser> _searchList = [];

//   // for storing search status
//   // bool _isSearching = false;

//   // search and filter
   
//     //SearchBar
//   TextEditingController? _valueContains = TextEditingController();
//   //SearchList
//   List<ChatUser> itemListOnSearch = [];

//   List<ChatUser> chatUserData = [];


//   @override
//   void initState() {
//     super.initState();
//     APIs.getSelfInfo();
//     readData();
//     //for updating user active status according to lifecycle events
//     //resume -- active or online
//     //pause  -- inactive or offline


//     SystemChannels.lifecycle.setMessageHandler((message) {
//       log('Message: $message');

//       if (APIs.auth.currentUser != null) {
//         if (message.toString().contains('resume')) {
//           APIs.updateActiveStatus(true);
//         }
//         if (message.toString().contains('pause')) {
//           APIs.updateActiveStatus(false);
//         }
//       }

//       return Future.value(message);
//     }
//     );
//   }

// Future<void> readData() async {
//     await Firebase.initializeApp().then((value) async {
//       print("Initialize Success");
//       var x = await FirebaseFirestore.instance
//           .collection('users')
//           .orderBy('skills')
//           .get();
//       x.docs.forEach((element) {
//         print(element.data());
//         ChatUser model = ChatUser.fromJson(element.data());
//         chatUserData.add(model);
//       });

//       Future.delayed(Duration(seconds: 2));
//       itemListOnSearch = chatUserData;
//       setState(() {}); //rebuild line 42 after readData();
//     });
//   }




//   @override
//   Widget build(BuildContext context) {
//     return 
    
//     Scaffold(
//   appBar: AppBar(
//     // app bar color
//     backgroundColor: Colors.greenAccent,
//     // back arrow to contact screen
//     leading: 
//          IconButton(
//               onPressed: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (_) => ContactScreen()));
//               },
//               icon: const Icon(Icons.arrow_back),),
//     // app bar title   
//         title: 
//         const Text('Home'),
//     // profile button
//       actions: [
//           IconButton(
//               onPressed: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (_) => ProfileScreen(user: APIs.me)));
//               },
//               icon: const Icon(Icons.person_2_outlined),),
//         ],
           
//   ),
//   body: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [

//       Text(
//         'Recommend users',
//         textAlign: TextAlign.left,
//         style: TextStyle(
//           fontWeight: FontWeight.w600,
//           color: Colors.blue.shade800,
//           fontSize: 23,
//         ),
//       ),

//       SizedBox(height: 8),

//       Text(
//         'Swipe left and right to see other users',
//         textAlign: TextAlign.left,
//         style: TextStyle(
//           fontWeight: FontWeight.w600,
//           color: Colors.grey.shade600,
//           fontSize: 17,
//         ),
//       ),

//       Expanded(
//         child: Column(
//           children: [

//             StreamBuilder(
//               stream: APIs.getMyUsersId(),
//               builder: (context, snapshot) {
//                 switch (snapshot.connectionState) {
//                   //if data is loading
//                   case ConnectionState.waiting:
//                   case ConnectionState.none:
//                     return const Center(child: CircularProgressIndicator());
          
//                   //if some or all data is loaded then show it
//                   case ConnectionState.active:
//                   case ConnectionState.done:
//                     return StreamBuilder(
//                       stream: APIs.getAllUsers(
//                           snapshot.data?.docs.map((e) => e.id).toList() ?? []),
          
//                       //get only those user, who's ids are provided
//                       builder: (context, snapshot) {
//                         switch (snapshot.connectionState) {
//                           //if data is loading
//                           case ConnectionState.waiting:
//                           case ConnectionState.none:
//                           // return const Center(child: CircularProgressIndicator());
          
//                           //if some or all data is loaded then show it
//                           case ConnectionState.active:
//                           case ConnectionState.done:
//                             final data = snapshot.data?.docs;
//                             _list = data
//                                     ?.map((e) => ChatUser.fromJson(e.data()))
//                                     .toList() ?? [];
          
          
          
//                             if (_list.isNotEmpty) {
//                               return 
//                               Swiper(
//                                 itemBuilder: (BuildContext context, int index) {
//                                   return 

//                                   HomeUserCard(
//                                     user: _list[index], 
//                                     );
//                                   },
//                                 itemCount:  _list.length,
                                  
//                                 //   HomeUserCard(
//                                 //     user: _isSearching ? _searchList[index] : _list[index],
//                                 //   );
//                                 // },
//                                 // itemCount: _isSearching ? _searchList.length : _list.length,


//                               );
//                               // ListView.builder(
//                               //     itemCount: _isSearching
//                               //         ? _searchList.length
//                               //         : _list.length,
//                               //     padding: EdgeInsets.only(top: mq.height * .01),
//                               //     physics: const BouncingScrollPhysics(),
//                               //     itemBuilder: (context, index) {
//                               //       return HomeUserCard(
//                               //           user: _isSearching
//                               //               ? _searchList[index]
//                               //               : _list[index]);
//                               //     });
//                             } else {
//                               return const Center(
//                                 child: Text('No Connections Found!',
//                                     style: TextStyle(fontSize: 20)),
//                               );
//                             }
//                         }
//                       },
//                     );
//                 }
//               },
//             ),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Users Result from Search Filter'),
//                   TextField(
//                     onChanged: (value) {
//                       setState(() {
//                         itemListOnSearch = chatUserData
//                             .where((element) =>
//                                 element.skills.contains(value.toLowerCase()))
//                             .toList();
//                       });
//                     },
//                     controller: _valueContains,
//                     decoration: InputDecoration(
//                     border: InputBorder.none,
//                     errorBorder: InputBorder.none,
//                     enabledBorder: InputBorder.none,
//                     focusedBorder: InputBorder.none,
//                     contentPadding: EdgeInsets.all(15),
//                     hintText: 'Search',
//                     ),
//                   ),
//                   itemListOnSearch.length == 0
//                       ? Center(child: CircularProgressIndicator())
//                       : Expanded(
//                           child: GridView.builder(
//                             gridDelegate:
//                                 SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 2,
//                             ),
//                             itemBuilder: (context, index) {
//                   return Card(
//                     child: Center(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Container(
//                             width: 100,
//                             child:
//                                 Image.network(itemListOnSearch[index].image),
//                           ),
//                           SizedBox(
//                             height: 5,
//                           ),
//                           Text(
//                             itemListOnSearch[index].occupation[index],
//                             style: TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(
//                             height: 2,
//                           ),
//                           Text(
//                             itemListOnSearch[index].username,
//                             style: TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(
//                             height: 2,
//                           ),
//                           Text(
//                             itemListOnSearch[index].skills[index],
//                             style: TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold),
//                           ),
//                            SizedBox(
//                             height: 2,
//                           ),
//                             Text(
//                             itemListOnSearch[index].occupation[index],
//                             style: TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ),
//                     //child: Text(sponsorsData[index].company),
//                   );
//                 },
//                             itemCount: itemListOnSearch.length,
//                           ),
//                         ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     ],
//   ),
// );

   
//   }







//   // for adding new chat user
//   void _addChatUserDialog() {
//     String email = '';

//     showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//               contentPadding: const EdgeInsets.only(
//                   left: 24, right: 24, top: 20, bottom: 10),

//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20)),

//               //title
//               title: Row(
//                 children: const [
//                   Icon(
//                     Icons.person_add,
//                     color: Colors.blue,
//                     size: 28,
//                   ),
//                   Text('  Add User')
//                 ],
//               ),

//               //content
//               content: TextFormField(
//                 maxLines: null,
//                 onChanged: (value) => email = value,
//                 decoration: InputDecoration(
//                     hintText: 'Email Id',
//                     prefixIcon: const Icon(Icons.email, color: Colors.blue),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15))),
//               ),

//               //actions
//               actions: [
//                 //cancel button
//                 MaterialButton(
//                     onPressed: () {
//                       //hide alert dialog
//                       Navigator.pop(context);
//                     },
//                     child: const Text('Cancel',
//                         style: TextStyle(color: Colors.blue, fontSize: 16))),

//                 //add button
//                 MaterialButton(
//                     onPressed: () async {
//                       //hide alert dialog
//                       Navigator.pop(context);
//                       if (email.isNotEmpty) {
//                         await APIs.addChatUser(email).then((value) {
//                           if (!value) {
//                             Dialogs.showSnackbar(
//                                 context, 'User does not Exists!');
//                           }
//                         });
//                       }
//                     },
//                     child: const Text(
//                       'Add',
//                       style: TextStyle(color: Colors.blue, fontSize: 16),
//                     ))
//               ],
//             ));
//   }
// }