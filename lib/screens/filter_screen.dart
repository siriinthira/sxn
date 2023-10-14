import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  List<String> skills = [];
  String? selectedSkill;
  late Stream<QuerySnapshot> userStream;

  @override
  void initState() {
    super.initState();
    userStream = FirebaseFirestore.instance.collection('users').snapshots();
    fetchSkills();
  }

  Future<void> fetchSkills() async {
    final skillsSnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    final allSkills = <String>{};

    for (final userDoc in skillsSnapshot.docs) {
      final userSkills = userDoc['skills'] as List<dynamic>?;
      if (userSkills != null) {
        allSkills.addAll(userSkills.map((skill) => skill.toString()));
      }
    }

    setState(() {
      skills = allSkills.toList();
      if (skills.isNotEmpty) {
        selectedSkill = skills[0]; // Initialize with the first skill
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Record'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedSkill,
              hint: const Text('Select a skill'),
              items: skills.map((skill) {
                return DropdownMenuItem<String>(
                  value: skill,
                  child: Text(skill),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedSkill = newValue;
                });
              },
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: userStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              final users = snapshot.data!.docs;
              final filteredUsers = users.where((user) {
                if (selectedSkill != null) {
                  final userSkills = user['skills'] as List?;
                  if (userSkills != null && userSkills.contains(selectedSkill)) {
                    return true;
                  }
                }
                return false;
              }).toList();

              return Expanded(
                child: ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index].data() as Map<String, dynamic>;
                    return Card(
                      elevation: 8.0,
                      margin: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.indigoAccent),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          title: Text(
                            user['username'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Occupation: ${user['occupation'].join(', ')}\nSkills: ${user['skills'].join(', ')}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
