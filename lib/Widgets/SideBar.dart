import 'package:cached_network_image/cached_network_image.dart';
import 'package:flour_mill/Screens/OrderHistory.dart';
import 'package:flour_mill/Screens/ProfileScreen.dart';
import 'package:flour_mill/model/OrderHistoryItem.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  String _userName = 'Loading...';
  String _userEmail = 'Loading...';
  String? _profileImageUrl;

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
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Customers')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            _userName = userDoc['name'] ?? 'Unknown';
            _userEmail = userDoc['email'] ?? user.email ?? 'Unknown';
             _profileImageUrl = userDoc['profilePic'];

          });
        } else {
          setState(() {
            _userName = user.displayName ?? 'Unknown';
            _userEmail = user.email ?? 'Unknown';
            _profileImageUrl = user.photoURL;

          });
        }
      } catch (e) {
        print('Error loading user data: $e');
        setState(() {
          _userName = 'Error loading';
          _userEmail = 'Error loading';
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
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
                accountName: Text(
                  _userName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(_userEmail),
                currentAccountPicture: Hero(
                  tag: 'profilePic',
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: _buildProfileImage(),
                //     backgroundColor: Colors.grey[200],
                // backgroundImage: _profileImageUrl != null
                //     ? CachedNetworkImageProvider(_profileImageUrl!)
                //     : null,
                // child: _profileImageUrl == null
                //     ? Image.asset('lib/assets/profile_image.jpg')
                //     : null, 
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


Widget _buildProfileImage() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _profileImageUrl != null
          ? CachedNetworkImage(
              key: ValueKey(_profileImageUrl),
              imageUrl: _profileImageUrl!,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            )
          : Image.asset('lib/assets/profile_image.jpg', fit: BoxFit.cover),
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
      trailing:
          Icon(Icons.arrow_forward_ios, size: 14, color: Colors.blue[600]),
    );
  }
}
