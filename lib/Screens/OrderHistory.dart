import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flour_mill/Screens/orderdetailspage.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  List<Map<String, dynamic>> _orderHistory = [];

  @override
  void initState() {
    super.initState();
    _loadOrderHistory();
  }


  Future<void> _loadOrderHistory() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Customers')
        .doc(user.uid)
        .collection('Orders')
        .orderBy('orderDate', descending: true)
        .get();

    setState(() {
      _orderHistory = querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });

    print('Number of orders fetched: ${_orderHistory.length}');  // Add this line for debugging
  } catch (e) {
    print('Error loading order history: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
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
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Track your orders easily',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _orderHistory.isEmpty
                ? const Center(child: Text('No orders found.'))
                : RefreshIndicator(
                    onRefresh: _loadOrderHistory,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _orderHistory.length,
                      itemBuilder: (context, index) {
                        final order = _orderHistory[index];
                        return _buildOrderCard(order);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }


    Widget _buildOrderCard(Map<String, dynamic> order) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () => _openOrderDetails(order),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order ID: ${order['id'] ?? 'Unknown'}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Total: \$${(order['totalPrice'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                'Date: ${_formatDate(order['orderDate'])}',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                'Status: ${order['status'] ?? 'Unknown'}',
                style: const TextStyle(fontSize: 12),
              ),
               const SizedBox(height: 4),
             Text('Shop: ${order['shop']?['name'] ?? 'Unknown Shop'}',
                style: TextStyle(fontSize: 12)),
              const Spacer(),
              ElevatedButton(
                onPressed: () => _openOrderDetails(order),
                child: const Text('View Details', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  
  String _formatDate(dynamic dateValue) {
    if (dateValue == null) return 'No date';
    if (dateValue is Timestamp) {
      final date = dateValue.toDate();
      return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    }
    return 'Invalid date';
  }


  // void _openOrderDetails(Map<String, dynamic> order) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => OrderDetailsPage(order: order),
  //     ),
  //   );
  // }
  void _openOrderDetails(Map<String, dynamic> order) {
  print('Opening order details for order: ${order['id']}');
  print('Order data: $order');
  
  try {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsPage(order: order),
      ),
    );
  } catch (e) {
    print('Error opening order details: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error opening order details: $e')),
    );
  }
}

  
}