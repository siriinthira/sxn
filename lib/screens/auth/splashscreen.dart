import 'package:app/api/apis.dart';
import 'package:app/main.dart';
import 'package:app/screens/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:app/screens/chat_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState(){
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      //Exit full screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    if(APIs.auth.currentUser != null){
      print('\nUser: ${FirebaseAuth.instance.currentUser}');
    }
     //Navigate to other page
    Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (_) => const LoginScreen() ));
    },);
  }

  @override
  Widget build(BuildContext context) {
    // initializing media query for getting device screen size
    mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
       title: const Text('Welcome to Chat'),
       ),
       body: Stack(
        children: [

        // app logo
        Positioned(
          top: mq.height * .25,
          right:  mq.width * .25 ,
          width: mq.width * .5,
          child: Image.asset('images/myapp_icon1.png'),
          ),
          
        // google login button  
        Positioned(
          bottom: mq.height * .15,
          width: mq.width,
          child: const Text('Skills X Network 🦉', 
          textAlign: TextAlign.center,
          style: TextStyle(
          fontSize: 16, 
          color: Colors.black87,
          letterSpacing: 5),)
           ),
       ],),
    );
  }
}

/*  Image.asset(
    'assets/images/file-name.jpg',
    height: 100,
    width: 100,
    ) 
*/