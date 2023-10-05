// import 'package:app/api/firebase_api.dart';
import 'package:app/models/chat_user.dart';
import 'package:app/screens/auth/splashscreen.dart';
import 'package:app/screens/home_screen.dart';
import 'package:flutter/material.dart';
// import 'package:app/screens/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app/firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:app/screens/home_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:firebase_auth/firebase_auth.dart';


// global object for accessing device screen size
late Size mq;

void main() async{
  
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // await FirebaseApi().initNotifications();

  //enter full screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  
  //for setting orientation to portrait only
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown ]).then((value) { 
   
    // _initializeFirebase();
  runApp(const MyApp());
  
  // Check the user's authentication status
 User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    print('User is authenticated: ${user.uid}');
  } else {
    print('User is not authenticated');
  }
  
  }
  
  );
  
  //integrating firebase
  _initializeFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skill x Network',
      theme: ThemeData(
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal, fontSize: 19), 
        backgroundColor: Colors.white,),
        ),
        home: const SplashScreen(),
     //home: SplashScreen(), //home: const MyHomePage(title: 'chat'),
    // home: MyHomePage(),
    );
  }
}

_initializeFirebase() async{
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform);
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _selectedImage;
  String? _downloadURL;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _selectedImage = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) {
      print('No image selected.');
      return;
    }

    try {
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('images/')
          .child(DateTime.now().toString());

      final UploadTask uploadTask = storageRef.putFile(_selectedImage!);

      final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      final String downloadURL = await taskSnapshot.ref.getDownloadURL();

      setState(() {
        _downloadURL = downloadURL;
      });

      print('Image uploaded and download URL: $_downloadURL');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_selectedImage != null)
              Image.file(
                _selectedImage!,
                height: 200,
              ),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick an Image'),
            ),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Upload Image'),
            ),
            if (_downloadURL != null)
              Text('Download URL: $_downloadURL'),
          ],
        ),
      ),
    );
  }
}