import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logintask/features/Auth/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logintask/features/Home/Home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAu4hjMHBbfjMTs75Ah0ZrLBTfcfGqEFqU",
      appId: "1:962860263191:android:27cb12604cd3d6c6e3f952",
      messagingSenderId: "962860263191",
      projectId: "logintask-ea49e")
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  
  @override
  State<MyApp> createState() => _MyAppState();
  
}

class _MyAppState extends State<MyApp>{

  @override
  void initState() {
    FirebaseAuth.instance
  .authStateChanges()
  .listen((User? user) {
    if (user == null) {
      print('*************User is currently signed out!');
    } else {
      print('*************User is signed in!');
    }
  });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: (FirebaseAuth.instance.currentUser != null &&
                FirebaseAuth.instance.currentUser!.emailVerified)
            ?  const Home()
            : const Login(),
    );
  }

}

