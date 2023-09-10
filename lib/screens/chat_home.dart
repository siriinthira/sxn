import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatUser {
  final String id;
  final String username;
  final String email;

  ChatUser({
    required this.id,
    required this.username,
    required this.email,
  });
}

class Fruit {
  final String title;

  Fruit({
    required this.title,
  });
}

class ChatHome extends StatefulWidget {
  const ChatHome({Key? key}) : super(key: key);

  @override
  State<ChatHome> createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.home),
        title: const Text('Chat'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, userSnapshot) {


          return StreamBuilder(
            stream: FirebaseFirestore.instance.collection('fruit').snapshots(),

        builder: (context, fruitSnapshot) {
                
                if (fruitSnapshot.hasError) {

                print('Fruit Snapshot Error: ${fruitSnapshot.error}');
              
                return Text('Error: ${fruitSnapshot.error}');
                }
                // ...
              if (userSnapshot.connectionState == ConnectionState.waiting ||
                  fruitSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (userSnapshot.hasError || fruitSnapshot.hasError) {
                return Text('Error: ${userSnapshot.error}');
              }

              final List<ChatUser> userList = userSnapshot.data!.docs
                  .map((document) {
                    final userData = document.data() as Map<String, dynamic>;
                    return ChatUser(
                      id: userData['id'],
                      username: userData['username'],
                      email: userData['email'],
                    );
                  })
                  .toList();

              final List<Fruit> fruitList = fruitSnapshot.data!.docs
                  .map((document) {
                    final fruitData = document.data() as Map<String, dynamic>;
                    return Fruit(
                      title: fruitData['title'],
                    );
                  })
                  .toList();

              return ListView.builder(
                itemCount: userList.length,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemBuilder: (context, index) {
                  final ChatUser chatUser = userList[index];
                  final Fruit fruit = index < fruitList.length ? fruitList[index] : Fruit(title: '');

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    elevation: 0.5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: InkWell(
                      onTap: () {},
                      child: ListTile(
                        leading: CircleAvatar(child: Icon(Icons.person)),
                        title: Text(chatUser.username),
                        subtitle: Text(chatUser.email),
                        // Display the 'title' from the 'fruit' collection in the card
                        trailing: Text(fruit.title, style: const TextStyle(color: Colors.black54)),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
