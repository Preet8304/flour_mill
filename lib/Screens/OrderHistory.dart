import 'package:flutter/material.dart';

class OrderHistoryItem {
  final String orderId;
  final DateTime orderDate;
  final double totalPrice;

  OrderHistoryItem({
    required this.orderId,
    required this.orderDate,
    required this.totalPrice,
  });
}

class OrderScreen extends StatelessWidget {
  final List<OrderHistoryItem> orderHistory;

  const OrderScreen({Key? key, required this.orderHistory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
      ),
      body: orderHistory.isEmpty
          ? const Center(
              child: Text(
                'No orders yet',
              ),
            )
          : ListView.builder(
              itemCount: orderHistory.length,
              itemBuilder: (context, index) {
                final order = orderHistory[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text('Order ID: ${order.orderId}'),
                    subtitle: Text(
                      'Date: ${order.orderDate.toString()}\n'
                      'Total: \$${order.totalPrice.toStringAsFixed(2)}',
                    ),
                    onTap: () {
                      // Show more details about the order
                      _showOrderDetails(context, order);
                    },
                  ),
                );
              },
            ),
    );
  }

  void _showOrderDetails(BuildContext context, OrderHistoryItem order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Order ID: ${order.orderId}'),
              Text('Date: ${order.orderDate.toString()}'),
              Text('Total: \$${order.totalPrice.toStringAsFixed(2)}'),
              // You can add more details here, such as items in the order
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
