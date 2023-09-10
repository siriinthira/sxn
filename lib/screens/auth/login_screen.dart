import 'dart:async';
import 'package:app/main.dart';
import 'package:app/screens/chat_home.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly', // Add other scopes if needed
  ],
);

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });

    // Check if the user is already signed in when the app starts
    _checkGoogleSignInStatus();
  }

  _checkGoogleSignInStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isUserLoggedIn = prefs.getBool('isUserLoggedIn') ?? false;

    if (isUserLoggedIn) {
      // The user is already logged in, navigate to ChatHome
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ChatHome()));
    } else {
      // User is not logged in, stay on the LoginScreen
    }
  }

  

  _handleSignIn(GoogleSignInAccount googleSignInAccount) async {
    try {
      // You can access user information like this:
      print('Display Name: ${googleSignInAccount.displayName}');
      print('Email: ${googleSignInAccount.email}');
      print('ID: ${googleSignInAccount.id}');
      print('Profile Picture: ${googleSignInAccount.photoUrl}');

      // You can also obtain an authentication token (obtain the auth details from request)
      // final GoogleSignInAuthentication googleSignInAuthentication =
      //     await googleSignInAccount.authentication;
          
      // Create a new credential
      // final AuthCredential credential = GoogleAuthProvider.credential(
      //   accessToken: googleSignInAuthentication.accessToken,
      //   idToken: googleSignInAuthentication.idToken,
      // );

      // Now, you can use the credential to sign in with Firebase or your authentication system
      // Example: FirebaseAuth.instance.signInWithCredential(credential);
      //Once signed in, return the UserCredential
      // return await FirebaseAuth.instance.signInWithCredential(credential);
      //return await APIs.auth.signInWithCredential(credential);

      // Save the user's login state
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isUserLoggedIn', true);

      // Navigate to the ChatHome screen after successful login
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ChatHome()));
    } catch (error) {
      // Handle errors
      print('Error: $error');
    }

    
  }

_handleGoogleBtnClick() async {
  try {
    final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

    if (googleSignInAccount != null) {
      _handleSignIn(googleSignInAccount);
    } else {
      // Handle if the user cancels the sign-in process
      print('Sign-In canceled');
    }
  } catch (error) {
    // Handle errors
    print('Error: $error');
  }
}

  @override
  Widget build(BuildContext context) {
    // initializing media query for getting device screen size
    //pause comment mq while splash screen is using
    // mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
       title: const Text('Welcome to Chat'),
       ),
       body: Stack(
        children: [

        // app logo
        AnimatedPositioned(
          top: mq.height * .15,
          right: _isAnimate ? mq.width * .25 : -mq.width * .5, // left: mq.width * .25,
          width: mq.width * .5,
          duration: const Duration(seconds: 1),
          child: Image.asset('images/chat1.png'),
          ),
          
        // google login button  
        Positioned(
          top: mq.height * .7,
          left:  (mq.width - (mq.width * 0.8)) / 2, // Center the button horizontally
          width: mq.width * .8,
          height: mq.height * .06,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent.shade400,
              shape: StadiumBorder(),
              elevation: 1),

            onPressed: () {
              // Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatHome(),),);
              _handleGoogleBtnClick();
              // _handleSignIn();
            }, 
            icon: Container(
            width: 49, // Adjust the width to your desired size
            height: mq.height * .03, // Adjust the height to your desired size
            child: Image.asset('images/google_icon.png'),
    ), 
            label: RichText(
              text: const TextSpan(
                style:  TextStyle(color:  Colors.black, fontSize: 19),
                children: [
                  TextSpan(text: 'Sign In with'),
                  TextSpan(text: ' Google', style: TextStyle(fontWeight: FontWeight.w500)),
                ]
              ),
            ),)
           ,),
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