import 'dart:developer';
import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../models/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:app/screens/profile_screen.dart';
import 'package:app/screens/contact_screen.dart';
import 'package:app/widgets/home_user_card.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app/widgets/filter_user_card.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:app/screens/auth/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/screens/filter_screens/multi_filter.dart';










//home screen -- where all available contacts are shown
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


//-------------------           Bottom Navigation Bar          ------------------------------------------------//

// Function to handle the logout process
Future<void> _handleLogout() async {
  // Show a progress dialog
  Dialogs.showProgressBar(context);

  try {
    // Sign out from Firebase and Google
    await APIs.auth.signOut();
    await GoogleSignIn().signOut();

    // Hide the progress dialog
    Navigator.pop(context);

    // Navigate to the login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  } catch (e) {
    // Handle any errors that occurred during sign-out, e.g., show an error dialog
    Dialogs.showSnackbar(context, 'Error signing out: $e');
  }
}

 int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

    switch (index){

      case 1 :
      Navigator.push(context, MaterialPageRoute(builder: (context) => ContactScreen()));
      break;

      case 2 :
      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(user: APIs.me)));
      break;

      case 3 :
      _handleLogout();
      break;
    }

    });
  }

  //-------------------           Bottom Navigation Bar          ------------------------------------------------//



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

    // SystemChannels.lifecycle.setMessageHandler((message) {
    //   log('Message: $message');

    //   // if (APIs.auth.currentUser != null) {
    //   //   if (message.toString().contains('resume')) {
    //   //     APIs.updateActiveStatus(true);
    //   //   }
    //   //   if (message.toString().contains('pause')) {
    //   //     APIs.updateActiveStatus(false);
    //   //   }
    //   // }

    //   return Future.value(message);
    // }
    // );

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

      // Check if the user is not the logged-in user before adding them to the list
      if (model.id != APIs.user.uid) {
        chatUserData.add(model);
      }
    });

    Future.delayed(Duration(seconds: 2));
    itemListOnSearch = chatUserData;
    setState(() {});
  });
}


  // Define your Firestore collection reference
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

// // Create a variable to store the selected filter values
//   FilterOptions _filterOptions = FilterOptions();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      //app bar
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,

        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => ContactScreen()));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        //const Icon(CupertinoIcons.home),

        title: const Text('Home'),

        actions: [
          //profile button
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ProfileScreen(user: APIs.me)));
            },
            icon: const Icon(Icons.person_2_outlined),
          ),
          
        ],
      ),

      body: Column(
        children: [
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 35,
                ),

                Center(
                  child: Text(
                    'User Result from Search n Filter',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade800,
                        fontSize: 23),
                  ),
                ),


               // original search bar using textfield to search by skills w/o filter icon
              //  TextField(
              //   onChanged: (value) {
              //     setState(() {
              //       itemListOnSearch = chatUserData.where((element) {
              //         final skills = element.skills;
              //         final query = value.toLowerCase();
              //         return skills.any((skill) => skill.toLowerCase().contains(query));
              //       }).toList();
              //     });
              //   },
              //   controller: _valueContains,
              //   decoration: InputDecoration(
              //     border: InputBorder.none,
              //     errorBorder: InputBorder.none,
              //     enabledBorder: InputBorder.none,
              //     focusedBorder: InputBorder.none,
              //     contentPadding: EdgeInsets.all(15),
              //     hintText: 'Search',
              //   ),
              // ),

              //new search bar with filter icon
              TextField(
  onChanged: (value) {
    setState(() {
      itemListOnSearch = chatUserData.where((element) {
        final skills = element.skills;
        final query = value.toLowerCase();
        return skills.any((skill) => skill.toLowerCase().contains(query));
      }).toList();
    });
  },
  controller: _valueContains,
  decoration: InputDecoration(
    border: InputBorder.none,
    errorBorder: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    contentPadding: EdgeInsets.all(15),
    hintText: 'Search',

    //filter icon
    suffixIcon: IconButton(
      icon: Icon(Icons.filter_alt), // Icon for your 'Filter' button
      onPressed: () {
        // Navigate to the 'MultiFilterScreen'
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MultiFilterScreen(user:  APIs.me)),
        );
      },
    ),
  ),
),



               if (itemListOnSearch.isNotEmpty)
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) {
                        return FilterUserCard(user: itemListOnSearch[index]);
                        //return HomeUserCard(user: itemListOnSearch[index]);
                      },
                      itemCount: itemListOnSearch.length,
                    ),
                  ),

      


                SizedBox(height: 55),

                Padding(
                  padding: const EdgeInsets.only(left: 55.0),
                  child: Text(
                    'Recommend users',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade800,
                        fontSize: 23),
                  ),
                ),

                SizedBox(height: 8), // Adjust the spacing here as needed

                Padding(
                  padding: const EdgeInsets.only(left: 55.0),
                  child: Text(
                    'swipe left or right to see other user',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                        fontSize: 17),
                  ),
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
                          return const Center(
                              child: CircularProgressIndicator());

                        //if some or all data is loaded then show it
                        case ConnectionState.active:
                        case ConnectionState.done:
                          return StreamBuilder(
                            stream: APIs.getAllUsers(
                                snapshot.data?.docs.map((e) => e.id).toList() ??
                                    []),

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
                                          ?.map((e) =>
                                              ChatUser.fromJson(e.data()))
                                          .toList() ??
                                      [];

                                  if (_list.isNotEmpty) {
                                    return Swiper(
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return HomeUserCard(
                                          user: _list[index],
                                        );
                                      },
                                      itemCount: _list.length,
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.greenAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Contact',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
            backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }



 }
