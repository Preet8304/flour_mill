import 'package:flour_mill/Screens/orderdetailspage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    final prefs = await SharedPreferences.getInstance();
    List<String> orderHistory = prefs.getStringList('orderHistory') ?? [];
    setState(() {
      _orderHistory = orderHistory.map((orderString) {
        try {
          Map<String, dynamic> order = json.decode(orderString);
          order['orderId'] ??= 'Unknown';
          order['totalPrice'] ??= 0.0;
          order['date'] ??= DateTime.now().toIso8601String();
          // Remove this line: order['items'] ??= [];
          return order;
        } catch (e) {
          print('Error decoding order: $e');
          return {
            'orderId': 'Error',
            'totalPrice': 0.0,
            'date': DateTime.now().toIso8601String(),
            'items': {} // or [] if you prefer
          };
        }
      }).toList();
      _orderHistory.sort((a, b) {
        DateTime dateA = DateTime.parse(a['date'].toString());
        DateTime dateB = DateTime.parse(b['date'].toString());
        return dateB.compareTo(dateA);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        backgroundColor: Colors.deepPurple,
      ),
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
                'Order ID: ${order['orderId'] ?? 'Unknown'}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                  'Total: \$${(order['totalPrice'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
                  style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 4),
              Text('Date: ${_formatDate(order['date'])}',
                  style: const TextStyle(fontSize: 12)),
              const Spacer(),
              ElevatedButton(
                onPressed: () => _openOrderDetails(order),
                child:
                    const Text('Track Order', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openOrderDetails(Map<String, dynamic> order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsPage(order: order),
      ),
    );
  }

  String _formatDate(dynamic dateValue) {
    if (dateValue == null) return 'No date';
    try {
      DateTime date = DateTime.parse(dateValue.toString());
      return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    } catch (e) {
      print('Error parsing date: $e');
      return 'Invalid date';
    }
  }
}
