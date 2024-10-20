import 'package:flour_mill/Screens/OrderHistory.dart';
import 'package:flour_mill/Screens/OrderingScreen.dart';
import 'package:flour_mill/Screens/ProfileScreen.dart';
import 'package:flour_mill/model/flour_mills.dart';
import 'package:flutter/material.dart';
import 'package:flour_mill/Widgets/AppbarWidget.dart';
import 'package:flour_mill/Widgets/FlourMillCard.dart';
import 'package:flour_mill/model/flour_mill_data.dart';
import 'package:flour_mill/Widgets/SideBar.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int myIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [
      HomeScreen(),
      OrderHistoryPage(),
      ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Mill To Door'),),
      drawer: const SideBar(orderHistory: [],),
      body: widgetList[myIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: myIndex,
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.line_style), label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  @override
  Widget build(BuildContext context) {
    print("Building HomeScreen");
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: _buildFlourMillList(),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search flour mills...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
          });
        },
      ),
    );
  }

  Widget _buildFlourMillList() {
    return FutureBuilder<List<FlourMill>>(
      future: FlourMillData.getFlourMills(),
      builder: (context, snapshot) {
        print("FutureBuilder state: ${snapshot.connectionState}");
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print("Error in FutureBuilder: ${snapshot.error}");
          print("Error stack trace: ${snapshot.stackTrace}");
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final flourMills = snapshot.data!;
          print("Number of flour mills: ${flourMills.length}");
          
          final filteredMills = flourMills.where((mill) =>
            mill.shopname.toLowerCase().contains(_searchQuery) ||
            mill.address.toLowerCase().contains(_searchQuery)
          ).toList();

          if (filteredMills.isEmpty) {
            return Center(child: Text('No matching flour mills found'));
          }

          return ListView.builder(
            itemCount: filteredMills.length,
            itemBuilder: (context, index) {
              final flourMill = filteredMills[index];
              print("Building card for mill ${index + 1}: ${flourMill.shopname}");
              return GestureDetector(
                onTap: () => _selectShop(context, flourMill),
                child: FlourMillCard(flourMill: flourMill),
              );
            },
          );
        } else {
          print("No data received from FutureBuilder");
          return Center(child: Text('No data received'));
        }
      },
    );
  }

  void _selectShop(BuildContext context, FlourMill flourMill) {
    print("Debug - Selected shop: ${flourMill.shopname}");
    print("Debug - Shop ID: ${flourMill.id}");
   
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderingScreen(mills: flourMill),
      ),
    );
  }
}