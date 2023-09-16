import 'package:app/screens/auth/splashscreen.dart';
import 'package:flutter/material.dart';
// import 'package:app/screens/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app/firebase_options.dart';
import 'package:flutter/services.dart';


// global object for accessing device screen size
late Size mq;

void main() {
  
  WidgetsFlutterBinding.ensureInitialized();

  //enter full screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  
  //for setting orientation to portrait only
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown ]).then((value) { 
   
    _initializeFirebase();
  runApp(const MyApp());});
  
  //integrating firebase
  // _initializeFirebase();
  // runApp(const MyApp());
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
      home: SplashScreen(), //home: const MyHomePage(title: 'chat'),
    );
  }
}

_initializeFirebase() async{
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform);
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
    
//     return Scaffold(
//       appBar: AppBar(
       
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
       
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
