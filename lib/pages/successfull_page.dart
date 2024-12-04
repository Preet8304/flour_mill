import 'package:flour_mill/pages/honmepage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const AnimatedAcknowledge());
}

class AnimatedAcknowledge extends StatelessWidget {
  const AnimatedAcknowledge({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: SplashPage());
  }
}

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Delay for 1 second
    Future.delayed(const Duration(seconds: 2), () {
      // Push a new route after the delay
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MyHomePage(),
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Splash Page"),
      ),
      body: Center(
        child: Container(
          child: Lottie.asset(
            'animations/successfull.json',
            width: 250,
            height: 250,
            repeat: true,
            reverse:true,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
