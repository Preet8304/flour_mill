import 'package:flour_mill/Screens/OrderHistory.dart';
import 'package:flour_mill/model/flour_mills.dart';
import 'package:flutter/material.dart';
import 'package:flour_mill/Screens/ProfileScreen.dart';
import 'package:flour_mill/Widgets/FlourMillCard.dart';
import 'package:flour_mill/model/flour_mill_data.dart';
import 'package:flour_mill/Widgets/SideBar.dart';
// Add this import if FlourMill is defined here

class OrderHistoryItem {
  // Define properties and constructor here
  final String itemName; // Example property

  OrderHistoryItem(this.itemName);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int myIndex = 0;
  List<OrderHistoryItem> orderHistory = []; // Add this line

  // Add this method to fetch order history
  List<OrderHistoryItem> fetchOrderHistory() {
    // Implement your logic to fetch order history here
    return []; // Return an empty list or your fetched data
  }

  @override
  void initState() {
    super.initState();
    // Fetch real order history from the checkout summary page
    orderHistory =
        fetchOrderHistory(); // Replace with your method to get order history
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [
      const HomeScreen(),
      OrderHistoryPage(), // Pass the real order history
      ProfileScreen(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mill To Door',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber[700],
        elevation: 0,
        actions: const [
          // Add CartStack widget in the AppBar's actions

          SizedBox(width: 20), // Add some spacing after the CartStack
        ],
      ),
      drawer: const SideBar(
        orderHistory: [],
      ),
      body: widgetList[myIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: myIndex,
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<FlourMill> flourMills =
      FlourMillData.getFlourMills(); // Assuming this is your data source
  List<FlourMill> filteredFlourMills = []; // List to hold filtered results

  @override
  void initState() {
    super.initState();
    filteredFlourMills = flourMills; // Initialize with all flour mills
    _searchController
        .addListener(_filterFlourMills); // Add listener to search controller
  }

  void _filterFlourMills() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredFlourMills = flourMills.where((flourMill) {
        return flourMill.name
            .toLowerCase()
            .contains(query); // Use null-aware access
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber[700],
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome back!',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 16),
              Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _searchController, // Set the controller
                    decoration: InputDecoration(
                      hintText: "Search for flour mills...",
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      suffixIcon: Icon(Icons.filter_list, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      hintStyle: TextStyle(
                          color: Colors.black), // Set hint text color to white
                    ),
                    style: TextStyle(
                        color: Colors.black), // Set text color to white
                  )),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            "Popular Mills",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredFlourMills.length, // Use filtered list
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: FlourMillCard(
                  flourMill: filteredFlourMills[index]), // Use filtered list
            );
          },
        ),
      ],
    );
  }
}
