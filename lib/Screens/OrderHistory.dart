import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  List<Map<String, dynamic>> _orderHistory = [];
  List<bool> _isExpandedList = []; // Track expansion state for each order

  @override
  void initState() {
    super.initState();
    _loadOrderHistory();
  }

  Future<void> _loadOrderHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> orderHistory = prefs.getStringList('orderHistory') ?? [];
    setState(() {
      _orderHistory = orderHistory
          .map((order) => jsonDecode(order) as Map<String, dynamic>)
          .toList();
      _isExpandedList = List<bool>.filled(
          _orderHistory.length, false); // Initialize expansion states
    });
  }

  void _trackOrder(int index) {
    setState(() {
      _isExpandedList[index] =
      !_isExpandedList[index]; // Toggle expansion state for specific order
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 20), // Adjust padding
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple, // Change to a more vibrant color
                  Colors.purpleAccent,
                ], // Gradient colors
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: const Column(
              children: [
                Text(
                  'Order History',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24, // Increase font size for better visibility
                    color: Colors.white, // Text color
                  ),
                ),
                SizedBox(height: 5), // Reduced space
                Text(
                  'Track your orders easily',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white, // Text color
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _orderHistory.isEmpty
                ? const Center(child: Text('No orders found.'))
                : ListView.builder(
              itemCount: _orderHistory.length,
              itemBuilder: (context, index) {
                final order = _orderHistory[index];
                return Card(
                  elevation:
                  8, // Increased elevation for a more pronounced shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                  color: Colors.white, // Card background color
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            'Order ID: ${order['orderId']}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent),
                          ),
                          subtitle: Text(
                              'Total Price: \$${order['totalPrice']}',
                              style:
                              const TextStyle(color: Colors.black54)),
                          trailing: TextButton(
                            onPressed: () => _trackOrder(
                                index), // Pass index to track order
                            child: const Text('Track',
                                style: TextStyle(color: Colors.blue)),
                          ),
                        ),
                        if (_isExpandedList[
                        index]) // Show details if expanded
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              const Text('Order Status:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildStatusCircle('Order Created',
                                      Colors.green, true),
                                  _buildConnectingLine(Colors
                                      .green), // Change color to green
                                  _buildStatusCircle(
                                      'Ready', Colors.orange, false),
                                  _buildConnectingLine(Colors
                                      .grey), // Change color to grey
                                  _buildStatusCircle('Out for Delivery',
                                      Colors.blue, false),
                                  _buildConnectingLine(Colors
                                      .grey), // Change color to grey
                                  _buildStatusCircle(
                                      'Delivered', Colors.grey, false),
                                ],
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCircle(String label, Color color, bool isActive) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? color : Colors.grey[300],
            border:
            Border.all(color: color, width: 2), // Add border to the circle
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: isActive ? color : Colors.grey)),
      ],
    );
  }

  Widget _buildConnectingLine(Color color) {
    return Expanded(
      child: Container(
        height: 2,
        color: color, // Use the passed color for the line
        margin:
        const EdgeInsets.only(top: 8), // Adjust margin to center the line
      ),
    );
  }
}
