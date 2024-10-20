import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flour_mill/admin/userDetail/user_list_view.dart';
import 'package:flour_mill/admin/vendorDetail/vendor_list_view.dart';
import 'package:flour_mill/firebase%20auth%20service/firebase_getuser.dart';
import 'package:flour_mill/admin/userDetail/userdetailspage.dart';
import 'package:flutter/material.dart';

class AdminHomepage extends StatefulWidget {
  const AdminHomepage({Key? key}) : super(key: key);

  @override
  _AdminHomepageState createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
            // Tab(text: 'Requests'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          UserListView(),
          VendorListView(),
          // _buildUsersListView(),
          // _buildVendorListView(),
          //_buildListView('Requests'),
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
    return UserListView();
  }

  Widget _buildVendorListView() {
    return VendorListView();
  }
}
