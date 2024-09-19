import 'package:flour_mill/pages/SignUpPage.dart';
import 'package:flutter/material.dart';
import 'Screens/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBK5nVt7zlLtHIyafew6CfeZckEybVBYBk",
        authDomain: "flour-mill-5b3f1.firebaseapp.com",
        projectId: "flour-mill-5b3f1",
        storageBucket: "flour-mill-5b3f1.appspot.com",
        messagingSenderId: "239267139744",
        appId: "1:239267139744:android:8cc03c3e9a9651eeebb9c5",
        databaseURL: 'https://flour-mill-5b3f1-default-rtdb.firebaseio.com'),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: " Mill to Door",
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      routes: {"/": (context) => const SignUpPage()},
    );
  }
}
