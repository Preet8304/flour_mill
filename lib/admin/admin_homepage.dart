// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flour_mill/admin/settings_page.dart';
// import 'package:flour_mill/admin/userDetail/user_list_view.dart';
// import 'package:flour_mill/admin/vendorDetail/vendor_list_view.dart';
// import 'package:flour_mill/firebase%20auth%20service/firebase_getuser.dart';
// import 'package:flour_mill/admin/userDetail/userdetailspage.dart';
// import 'package:flour_mill/vendor/vendor_settingpage.dart';
// import 'package:flutter/material.dart';

// class AdminHomepage extends StatefulWidget {
//   const AdminHomepage({Key? key}) : super(key: key);

//   @override
//   _AdminHomepageState createState() => _AdminHomepageState();
// }

// class _AdminHomepageState extends State<AdminHomepage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final FirestoreService _firestoreService = FirestoreService();
//   int _currentIndex = 0; // track the current bottom navigation index

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Admin'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () {
//               // TODO: Implement search functionality
//             },
//           ),
//         ],
//       bottom: _currentIndex == 0 ? TabBar(
//           controller: _tabController,
//           tabs: const [
//             Tab(text: 'Users'),
//             Tab(text: 'Vendors'),
//           ],
//         ) : null,
//       ),
//       body: _currentIndex == 0 
//        ? TabBarView(
//         controller: _tabController,
//         children: [
//           UserListView(),
//           VendorListView(),
//           // _buildUsersListView(),
//           // _buildVendorListView(),
//           //_buildListView('Requests'),
//         ],
//       ):const SettingsPage(),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             label: 'Settings',
//           ),
//         ],
//         onTap: (index) {
//             setState(() {
//             _currentIndex = index;
//           });
//         },
//       ),
//     );
//   }

//   Widget _buildUsersListView() {
//     return UserListView();
//   }

//   Widget _buildVendorListView() {
//     return VendorListView();
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flour_mill/admin/settings_page.dart';
import 'package:flour_mill/admin/userDetail/user_list_view.dart';
import 'package:flour_mill/admin/vendorDetail/vendor_list_view.dart';
import 'package:flour_mill/firebase%20auth%20service/firebase_getuser.dart';
import 'package:flutter/material.dart';

class AdminHomepage extends StatefulWidget {
  const AdminHomepage({Key? key}) : super(key: key);

  @override
  _AdminHomepageState createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirestoreService _firestoreService = FirestoreService();
  int _currentIndex = 0;
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_isSearching) {
      setState(() {
        _searchQuery = '';
        _isSearching = false;
      });
    }
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchQuery = '';
    });
  }

  void _updateSearchQuery(String newQuery) {
    setState(() {
      _searchQuery = newQuery;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search ${_tabController.index == 0 ? 'Users' : 'Vendors'}...',
                  border: InputBorder.none,
                ),
                style: TextStyle(color: const Color.fromARGB(255, 14, 13, 13)),
                onChanged: _updateSearchQuery,
              )
            : Text('Admin'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _isSearching ? _stopSearch : _startSearch,
          ),
        ],
        bottom: _currentIndex == 0
            ? TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Users'),
                  Tab(text: 'Vendors'),
                ],
              )
            : null,
      ),
      body: _currentIndex == 0
          ? TabBarView(
              controller: _tabController,
              children: [
                UserListView(searchQuery: _searchQuery),
                VendorListView(searchQuery: _searchQuery),
              ],
            )
          : const SettingsPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
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
          setState(() {
            _currentIndex = index;
            if (_isSearching) {
              _stopSearch();
            }
          });
        },
      ),
    );
  }
}