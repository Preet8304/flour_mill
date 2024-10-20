import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flour_mill/firebase%20auth%20service/firebase_getuser.dart';
import 'package:flour_mill/admin/userdetailpage.dart';
import 'package:flutter/material.dart';


class AdminHomepage extends StatefulWidget {
  const AdminHomepage({Key? key}) : super(key: key);

  @override
  _AdminHomepageState createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Users'),
            Tab(text: 'Vendors'),
            Tab(text: 'Requests'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUsersListView(),
          _buildListView('Vendors'),
          _buildListView('Requests'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (index) {
          // TODO: Implement navigation
        },
      ),
    );
  }

Widget _buildUsersListView() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestoreService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final users = snapshot.data!.docs;

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final userData = users[index].data() as Map<String, dynamic>;
            final userName = userData['name'] ?? 'No Name';
            final userEmail = userData['email'] ?? 'No Email';

            return ListTile(
              leading: CircleAvatar(
                child: Text(userName[0]),
              ),
              title: Text(userName),
              subtitle: Text(userEmail),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserDetailsPage(userId: users[index].id),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildListView(String title) {
    // TODO: Implement Vendors and Requests lists
    return Center(child: Text('$title list not implemented yet'));
  }
}
