import 'package:flour_mill/Screens/OrderHistory.dart';
import 'package:flour_mill/Screens/ProfileScreen.dart';
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
      child: InkWell(splashColor: Colors.blue,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text('Shizuka'),
              accountEmail: const Text("Nobitanobi88@gmail.com"),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.network(
                    'https://d2qp0siotla746.cloudfront.net/img/use-cases/profile-picture/template_3.jpg',
                    width: 90,
                    height: 90,
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('lib/assets/categories/back.jpg'),fit: BoxFit.cover),),
            ),
             ListTile(
              leading:const Icon(Icons.favorite),
              title: const Text('Favorites'),
              onTap: () => null,
            ),
            Divider(),
            ListTile(
              leading:const Icon(Icons.line_style),
              title: const Text('Order History'),
              onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context)=> const OrderScreen()));},
            ),
            ListTile(
              leading:const Icon(Icons.person),
              title: const Text('Account'),
              onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>  ProfileScreen()));},
            ),
            Divider(),
            ListTile(
              leading:const Icon(Icons.question_mark),
              title: const Text('Query Status'),
              onTap: () => null,
            ),
            ListTile(
              leading:const Icon(Icons.feedback_outlined),
              title: const Text('Feedback'),
              onTap: () => null,
            ),
        
          ],
        ),
      ),
    );
  }
}
