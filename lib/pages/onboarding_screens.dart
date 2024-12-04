import 'package:flour_mill/pages/introscreen_pages/intro_page1.dart';
import 'package:flour_mill/pages/introscreen_pages/intro_page2.dart';
import 'package:flour_mill/pages/introscreen_pages/intro_page3.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void main() {
  runApp(const MyPageViewer());
}

class MyPageViewer extends StatefulWidget {
  const MyPageViewer({super.key});

  @override
  State<MyPageViewer> createState() => _MyPageViewerState();
}

class _MyPageViewerState extends State<MyPageViewer> {
  PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Stack(children: [
      PageView(controller: _controller, children: [
        IntroPage1(),
        IntroPage2(),
        IntroPage3(),
      ]),
      Container(
        alignment: const Alignment(0, 0.85),
        child: SmoothPageIndicator(
          controller: _controller,
          count: 3,
          effect: const WormEffect(),
        ),
      ),
    ]));
  }
}
