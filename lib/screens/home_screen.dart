import '../main.dart';
import 'dart:developer';
import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../models/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:app/screens/profile_screen.dart';
import 'package:app/widgets/chat_user_card.dart';
import 'package:app/screens/contact_screen.dart';
import 'package:app/widgets/home_user_card.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/widgets/search_filter_user_card.dart';




//home screen -- where all available contacts are shown
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  // for storing all users : Your list of ChatUser data
  List<ChatUser> _list = [];


 //SearchBar
  TextEditingController? _valueContains = TextEditingController();
  //SearchList
  List<ChatUser> itemListOnSearch = [];

  List<ChatUser> chatUserData = [];


  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
    readData();


 SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');

      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    }
    );
  }

Future<void> readData() async {
    await Firebase.initializeApp().then((value) async {
      print("Initialize Success");
      var x = await FirebaseFirestore.instance
          .collection('users')
          .orderBy('skills')
          .get();
      x.docs.forEach((element) {
        print(element.data());
        ChatUser model = ChatUser.fromJson(element.data());
        chatUserData.add(model);
      });

      Future.delayed(Duration(seconds: 2));
      itemListOnSearch = chatUserData;
      setState(() {}); //rebuild line 42 after readData();
    });
  }



  @override
  Widget build(BuildContext context) {
    return 
    
    Scaffold(
      //app bar

      appBar: AppBar(
        backgroundColor: Colors.greenAccent,

        leading: 
         IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ContactScreen()));
              },
              icon: const Icon(Icons.arrow_back),),
        //const Icon(CupertinoIcons.home),

        title: 
        const Text('Home'),

  actions: [
  //profile button
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ProfileScreen(user: APIs.me)));
              },
              icon: const Icon(Icons.person_2_outlined),),
        ],
        
      ),

body: 
      
      Column(
        children: [
Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 35,),

              Center(
                child: Text('User Result from Search n Filter', textAlign: TextAlign.left, style: TextStyle(
                fontWeight: FontWeight.w600, color: Colors.blue.shade800, fontSize: 23
                ),),
              ),
                TextField(
            onChanged: (value) {
              setState(() {
                itemListOnSearch = chatUserData
                    .where((element) => element.skills
                        // .toLowerCase()
                        .contains(value.toLowerCase()))
                    .toList();
              });
            },
            controller: _valueContains,
            decoration: InputDecoration(
              border: InputBorder.none,
              errorBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.all(15),
              hintText: '       Search',
              //
            ),
          ),
          itemListOnSearch.length == 0
          ? Center(child: CircularProgressIndicator())
          : Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,),
                itemBuilder: (context, index) {
                  return Card(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 100,
                            child:
                                Image.network(itemListOnSearch[index].image),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            itemListOnSearch[index].occupation.join(' '),
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            itemListOnSearch[index].username,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            itemListOnSearch[index].skills.join(' ,'),
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                           SizedBox(
                            height: 2,
                          ),

  ],
                      ),
                    ),
                    //child: Text(sponsorsData[index].company),
                  );
                },
                itemCount: itemListOnSearch.length,
              ),
          ),

               SizedBox(height: 55), 

            Padding(
              padding: const EdgeInsets.only(left:55.0),
              child: Text('Recommend users', textAlign: TextAlign.left, style: TextStyle(
                fontWeight: FontWeight.w600, color: Colors.blue.shade800, fontSize: 23
              ),),
            ),
          
          SizedBox(height: 8), // Adjust the spacing here as needed

            Padding(
              padding: const EdgeInsets.only(left:55.0),
              child: Text('swipe left or right to see other user', textAlign: TextAlign.left, style: TextStyle(
                fontWeight: FontWeight.w600, color: Colors.grey.shade600, fontSize: 17
              ),),
            ),
          
          SizedBox(height: 8), 

               Flexible(

            child: StreamBuilder(
              
              stream: APIs.getMyUsersId(),
          
              //get id of only known users
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  //if data is loading
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(child: CircularProgressIndicator());
          
                  //if some or all data is loaded then show it
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return StreamBuilder(
                      stream: APIs.getAllUsers(
                          snapshot.data?.docs.map((e) => e.id).toList() ?? []),
          
                      //get only those user, who's ids are provided
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          //if data is loading
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                          // return const Center(child: CircularProgressIndicator());
          
                          //if some or all data is loaded then show it
                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;
                            _list = data
                                    ?.map((e) => ChatUser.fromJson(e.data()))
                                    .toList() ?? [];
          
          
          
                            if (_list.isNotEmpty) {
                              return 
                              Swiper(
                                itemBuilder: (BuildContext context, int index) {
                                  return 

                                  HomeUserCard(
                                    user: _list[index], 
                                    );
                                  },
                                itemCount:  _list.length,

                              );

 } else {
                              return const Center(
                                child: Text('No Connections Found!',
                                    style: TextStyle(fontSize: 20)),
                              );
                            }
                        }
                      },
                    );
                }
              },
            ),
          ),

            ],
          ),
          ),  



        ], //children
        
      ),


    );
  }



}