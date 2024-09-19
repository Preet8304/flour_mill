import 'package:flutter/material.dart';

void main() {
  runApp(const IntroPage1());
}

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Container(color: Color(0xFF2ECC71)));
  }
}
