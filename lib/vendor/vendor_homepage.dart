 import 'package:flour_mill/vendor/vendor_settingpage.dart';
import 'package:flutter/material.dart';

class VendorHomepage extends StatefulWidget {
  final Map<String, dynamic> shopData ;

  VendorHomepage({required this.shopData});

  @override
  State<VendorHomepage> createState() => _VendorHomepageState();
}

class _VendorHomepageState extends State<VendorHomepage> {
    int _selectedIndex = 1;
  
  @override
  void initState() {
    super.initState();
    print("Received shopData in VendorHomepage: ${widget.shopData}"); // Add this line for debugging
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'All  Orders' : 'Settings'),
        centerTitle: true,
      ),
      body: _getPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Settings'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.brown,
        onTap: _onItemTapped,
      ),
    );
  }
  Widget _getPage() {
    switch (_selectedIndex) {
      case 0:
        return Center(child: Text('Orders Page'));
      case 1:
        return  VendorSettingPage(shopData: widget.shopData);
      default:
        return Center(child: Text('Page not found'));
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

}



