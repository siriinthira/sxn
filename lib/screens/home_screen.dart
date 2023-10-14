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
import 'package:app/widgets/filter_user_card.dart';
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
    });
  }


 // show all users from database
  // Future<void> readData() async {
  //   await Firebase.initializeApp().then((value) async {
  //     print("Initialize Success");
  //     var x = await FirebaseFirestore.instance
  //         .collection('users')
  //         .orderBy('skills')
  //         .get();
  //     x.docs.forEach((element) {
  //       print(element.data());
  //       ChatUser model = ChatUser.fromJson(element.data());
  //       chatUserData.add(model);
  //     });

  //     Future.delayed(Duration(seconds: 2));
  //     itemListOnSearch = chatUserData;
  //     setState(() {}); //rebuild line 42 after readData();
  //   });
  // }

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

// Create a variable to store the selected filter values
  FilterOptions _filterOptions = FilterOptions();



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

                // Filtered results
                if (_filterOptions.hasFilters)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Filtered Results:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade800,
                        fontSize: 23,
                      ),
                    ),
                  ),

                if (_filterOptions.hasFilters)
                  FutureBuilder<List<ChatUser>>(
                    // Implement a method to fetch filtered users based on filter options
                    future: fetchFilteredUsers(_filterOptions),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        final filteredUsers = snapshot.data;
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemBuilder: (context, index) {
                            return Card(
                                // Build your card for filtered users
                                );
                          },
                          itemCount: filteredUsers?.length,
                        );
                      } else {
                        return const Text('No Connections Found');
                      }
                    },
                  ),
              ],
            ),
          ),
        ], //children
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return FilterDialog(
          filterOptions: _filterOptions,
          onFilterChanged: (filterOptions) {
            // Update filter options
            setState(() {
              _filterOptions = filterOptions;
            });
            // Close the dialog
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  // Implement a method to fetch filtered users based on filter options
  Future<List<ChatUser>> fetchFilteredUsers(FilterOptions filterOptions) async {
    // Query Firestore to fetch filtered users based on filterOptions
    // Build your Firestore query based on the selected filters
    // Return a list of filtered ChatUser objects
    // You can use the `where` clause for filtering in Firestore

    Query query = usersCollection;

    if (filterOptions.selectedSkills.isNotEmpty) {
      query = query.where('skills',
          arrayContainsAny: filterOptions.selectedSkills.split(', '));
    }

    if (filterOptions.selectedOccupation.isNotEmpty) {
      query = query.where('occupation',
          isEqualTo: filterOptions.selectedOccupation);
    }

    if (filterOptions.selectedHobbies.isNotEmpty) {
      query = query.where('hobbies', isEqualTo: filterOptions.selectedHobbies);
    }

    if (filterOptions.selectedUniversities.isNotEmpty) {
      query = query.where('universities',
          isEqualTo: filterOptions.selectedUniversities);
    }

    if (filterOptions.selectedSchools.isNotEmpty) {
      query = query.where('schools', isEqualTo: filterOptions.selectedSchools);
    }

    final QuerySnapshot querySnapshot = await query.get();

    final List<ChatUser> filteredUsers = querySnapshot.docs
        .map((document) =>
            ChatUser.fromJson(document.data() as Map<String, dynamic>))
        .toList();

    return filteredUsers;
  }
}

class FilterOptions {
  String selectedSkills = "";
  String selectedOccupation = "";
  String selectedHobbies = "";
  String selectedUniversities = "";
  String selectedSchools = "";

  bool get hasFilters {
    return selectedSkills.isNotEmpty ||
        selectedOccupation.isNotEmpty ||
        selectedHobbies.isNotEmpty ||
        selectedUniversities.isNotEmpty ||
        selectedSchools.isNotEmpty;
  }
}

class FilterDialog extends StatefulWidget {
  final FilterOptions filterOptions;
  final ValueChanged<FilterOptions> onFilterChanged;

  FilterDialog({required this.filterOptions, required this.onFilterChanged});

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  // ... Implement the UI for your FilterDialog with dropdowns for filters ...

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Users'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ... Implement your filter dropdowns ...

          // Find Match button to apply filters
          ElevatedButton(
            onPressed: () {
              // Pass the updated filter options back to the HomeScreen
              widget.onFilterChanged(widget.filterOptions);
            },
            child: const Text('Find Match'),
          ),
        ],
      ),
    );
  }
}
