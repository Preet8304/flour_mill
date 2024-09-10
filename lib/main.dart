import 'package:flutter/material.dart';
import 'Screens/HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: " Mill to Door",
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(10, 174, 56, 200),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        "/":(context)=> HomePage()},
    );
  }
}
