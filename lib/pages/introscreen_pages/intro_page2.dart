import 'package:flutter/material.dart';

void main() {
  runApp(const IntroPage2());
}

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Container(color: Color(0xFF3498DB)));
  }
}
