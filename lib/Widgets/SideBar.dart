import 'package:flour_mill/Screens/OrderHistory.dart';
import 'package:flour_mill/Screens/ProfileScreen.dart';
import 'package:flour_mill/model/OrderHistoryItem.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/LoginPage.dart';

class SideBar extends StatefulWidget {
  final List<OrderHistoryItem> orderHistory;

  const SideBar({super.key, required this.orderHistory});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _logout()async {
      {
      // Clear the Firebase session
      await FirebaseAuth.instance.signOut();

      // Clear the 'isLoggedIn' flag from SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);

      // Navigate the user back to the LoginPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[50]!, Colors.blue[100]!],
          ),
        ),
        child: FadeTransition(
          opacity: _animation,
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Shizuka',
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      speed: const Duration(milliseconds: 100),
                    ),
                  ],
                  totalRepeatCount: 1,
                  displayFullTextOnTap: true,
                ),
                accountEmail: const Text("Nobitanobi88@gmail.com"),
                currentAccountPicture: Hero(
                  tag: 'profilePic',
                  child: CircleAvatar(
                    child: ClipOval(
                      child: Image.network(
                        'https://d2qp0siotla746.cloudfront.net/img/use-cases/profile-picture/template_3.jpg',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('lib/assets/categories/back.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black26,
                      BlendMode.darken,
                    ),
                  ),
                ),
              ),
              _buildAnimatedListTile(
                icon: Icons.favorite,
                title: 'Favorites',
                onTap: () => null,
              ),
              const Divider(),
              _buildAnimatedListTile(
                icon: Icons.line_style,
                title: 'Order History',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderHistoryPage(),
                    ),
                  );
                },
              ),
              _buildAnimatedListTile(
                icon: Icons.person,
                title: 'Account',
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
              ),
              const Divider(),
              _buildAnimatedListTile(
                icon: Icons.question_mark,
                title: 'Query Status',
                onTap: () => null,
              ),
              _buildAnimatedListTile(
                icon: Icons.feedback_outlined,
                title: 'Feedback',
                onTap: () => null,
              ),
              const Divider(),
              _buildAnimatedListTile(
                icon: Icons.logout,
                title: 'Logout',
                onTap: _logout,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue[700]),
      title: Text(
        title,
        style: TextStyle(color: Colors.blue[800]),
      ),
      onTap: onTap,
      hoverColor: Colors.blue[200],
      splashColor: Colors.blue[300],
      trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.blue[600]),
    );
  }
}
