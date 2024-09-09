import 'package:flutter/material.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('Shizuka'),
            accountEmail: const Text("Nobitanobi88@gmail.com"),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network('https://d2qp0siotla746.cloudfront.net/img/use-cases/profile-picture/template_3.jpg'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
