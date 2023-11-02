import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:app/screens/filter_screens/alumni_filter.dart';
import 'package:app/screens/filter_screens/alumni_filter.dart';
 
 
 
 
 
 
class MultiFilterScreen extends StatefulWidget {
  final ChatUser user;
 
  const MultiFilterScreen({Key? key, required this.user, }) : super(key: key);
 
  @override
  _MultiFilterScreenState createState() => _MultiFilterScreenState();
}
 
class _MultiFilterScreenState extends State<MultiFilterScreen> {
 
 
  final GlobalKey<DropdownSearchState<String>> _skillsDropdownKey =
      GlobalKey();
  final GlobalKey<DropdownSearchState<String>> _occupationDropdownKey =
      GlobalKey();
  final GlobalKey<DropdownSearchState<String>> _hobbiesDropdownKey =
      GlobalKey();
 
  // List<String> selectedSkills = [];
  // List<String> selectedOccupations = [];
  // List<String> selectedHobbies = [];
  List<String> selectedOptions =[];
 
  List<String> skills = [];
  List<String> occupations = [];
  List<String> hobbies = [];
 
  // สร้าง StreamController สำหรับผู้ใช้ที่เลือกผ่านตัวกรอง เพื่อใช้ส่งข้อมูลผู้ใช้ไปยัง SteamBuilder ในภายหลัง
  StreamController<List<QueryDocumentSnapshot>> _usersStreamController =
    StreamController<List<QueryDocumentSnapshot>>();
 
    @override
  void dispose() {
    _usersStreamController.close();
    super.dispose();
  }
 
  // Fetch data from Firestore
  void fetchData(String collection, String field, List<String> listToUpdate) {
    FirebaseFirestore.instance.collection(collection).get().then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        listToUpdate.clear();
        querySnapshot.docs.forEach((doc) {
          if (doc.data().containsKey(field)) {
            List<dynamic> data = doc[field];
            for (var item in data) {
              if (!listToUpdate.contains(item)) {
                listToUpdate.add(item);
              }
            }
          }
        });
        print(listToUpdate);
        setState(() {});
      }
    });
  }
 
  void _queryUsersBySkills() {
    final usersQuery = FirebaseFirestore.instance
        .collection('users')
        .where('skills', arrayContainsAny: selectedOptions);
 
        usersQuery.snapshots().listen((snapshot) {
          _usersStreamController.add(snapshot.docs);
         });
 
    // Use StreamBuilder to listen to changes in the query results and update the UI.
    // Example:
    // StreamBuilder<QuerySnapshot>(
    //   stream: usersQuery.snapshots(),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return CircularProgressIndicator(); // Show a loading indicator.
    //     }
    //     if (snapshot.hasError) {
    //       return Text('Error: ${snapshot.error}');
    //     }
    //     if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
    //       return Text('No users found.');
    //     }
 
    //     // Extract users from snapshot and update the UI.
    //     // You can display user cards here.
    //   },
    // );
  }
 
  void _queryUsersByOccupation() {
    final usersQuery = FirebaseFirestore.instance
        .collection('users')
        .where('occupation', arrayContainsAny: selectedOptions);
 
     
        usersQuery.snapshots().listen((snapshot) {
          _usersStreamController.add(snapshot.docs);
         });
   
  }
 
  void _queryUsersByHobbies() {
    final usersQuery = FirebaseFirestore.instance
        .collection('users')
        .where('hobbies', arrayContainsAny: selectedOptions);
 
     
        usersQuery.snapshots().listen((snapshot) {
          _usersStreamController.add(snapshot.docs);
         });
   
  }
 
  @override
  void initState() {
    super.initState();
 
    // Fetch data for skills, occupations, and hobbies
    fetchData('users', 'skills', skills);
    fetchData('users', 'occupation', occupations);
   
    fetchData('users', 'hobbies', hobbies);
   
  }
 
  void _searchUsers() {
  // สร้างคิวรี่ Firestore เพื่อกรองผู้ใช้ตามตัวเลือกที่เลือก  
  // Create a Firestore query for filtering users based on selected options
  final usersQuery = FirebaseFirestore.instance.collection('users');
 
   // ใช้ตัวกรองตามค่าที่เลือกจาก DropdownSearch
  // Apply filters based on selected dropdown values
  // if (selectedSkills.isNotEmpty) {
  //   usersQuery.where('skills', arrayContainsAny: selectedSkills);
  // }
  // if (selectedOccupations.isNotEmpty) {
  //   usersQuery.where('occupation', arrayContainsAny: selectedOccupations);
  // }
  // if (selectedHobbies.isNotEmpty) {
  //   usersQuery.where('hobbies', arrayContainsAny: selectedHobbies);
  // }
 
   // ใช้ตัวกรองตามค่าที่เลือกจาก DropdownSearch
  if (selectedOptions.isNotEmpty) {
    usersQuery.where('your_field_name', arrayContainsAny: selectedOptions);
  }
 
 
   // ฟังก์ชันฟังคิวรี่ผู้ใช้
  // Listen to the query results using StreamBuilder
  usersQuery.snapshots().listen((snapshot) {
    _usersStreamController.add(snapshot.docs);
  });
}
 
 
  @override
  Widget build(BuildContext context) {
 
      // เพิ่ม StreamBuilder เพื่อแสดงผลผู้ใช้จาก Firestore โดยใช้ StreamController ที่เราสร้างไว้:
   
    return Scaffold(
      appBar: AppBar(title: Text("Filter Jobs & Skills")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Filter Jobs & Skills'),
            SizedBox(height: 30),
            Text('Find whom you want to contact', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Colors.grey.shade800),),
            SizedBox(height: 30),
            Row(
              children: [
                SizedBox(width: 30),
                 ElevatedButton(
                        onPressed: () {
                        //  Navigator.push(context,
                        //  MaterialPageRoute(builder: (context) => MultiFilterScreen(user: widget.user)),
                        // );
                        },
                        child: Text("Filter Jobs & Skills"),
                      ),
                      SizedBox(width: 30),
                       ElevatedButton(
                        onPressed: () {
                         Navigator.push(context,
                         MaterialPageRoute(builder: (context) => AlumniFilterScreen(user: widget.user)),
                         );
                        },
                        child: Text("Filter Alumni"),
                      ),
              ],
            ),
            SizedBox(height: 30,),
            Text('Pick Skills'),
            //Skills Dropdown
            DropdownSearch<String>.multiSelection(
              key: _skillsDropdownKey,
              items: skills,
              onChanged: (selectedItems) {
                setState(() {
                  selectedOptions = selectedItems;
                  _queryUsersBySkills();
                });
              },
            ),
           
           Divider(),
            SizedBox(height: 30,),
            Text('Pick Occupation'),
           // Occupation Dropdown
            DropdownSearch<String>.multiSelection(
              key: _occupationDropdownKey,
              items: occupations,
              onChanged: (selectedItems) {
                setState(() {
                  selectedOptions = selectedItems;
                  _queryUsersByOccupation();
                });
              },
            ),
 
           Divider(),
            SizedBox(height: 30,),
            Text('Pick Hobbies'),
          //  Hobbies Dropdown
            DropdownSearch<String>.multiSelection(
              key: _hobbiesDropdownKey,
              items: hobbies,
              onChanged: (selectedItems) {
                setState(() {
                  selectedOptions = selectedItems;
                  _queryUsersByHobbies();
                });
              },
            ),
 
           Divider(),
                         ElevatedButton(
                        onPressed: () {
                          // Call the search function here
                          _searchUsers();
                        },
                        child: Text("Find Match"),
                      ),
 
 
                 // แสดงผู้ใช้จาก Firestore โดยใช้ StreamBuilder
          StreamBuilder<List<QueryDocumentSnapshot>>(
            stream: _usersStreamController.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // แสดงตัวแสดงการโหลด
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No users found.');
              }
 
 
 
              // แสดงผู้ใช้ที่พบ
                    return Column(
                children: snapshot.data!.map((doc) {
                  final user = doc.data() as Map<String, dynamic>; // Cast to Map<String, dynamic>
   
                  final username = user['username'] as String? ?? 'user found';
                  final occupation = (user['occupation'] is List<String>)
                      ? (user['occupation'] as List<String>).join(', ')
                      : 'matched result';
                  final skills = (user['skills'] is List<String>)
                      ? (user['skills'] as List<String>).join(', ')
                      : 'user found';
 
                  return ListTile(
                    title: Text(username),
                    subtitle: Text(occupation, maxLines: 1),
                    trailing: Text(skills, maxLines: 1),
                  );
                }).toList(),
              );
 
            },
          ),
          ],
        ),
      ),
    );
 
  }
}
 
 
 
 
 