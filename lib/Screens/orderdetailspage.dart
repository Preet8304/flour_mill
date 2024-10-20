import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderDetailsPage extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailsPage({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        backgroundColor: Colors.deepPurple,
      ),
      // body: Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Text('Order ID: ${order['orderId'] ?? 'Unknown'}',
      //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      //       SizedBox(height: 8),
      //       Text('Date: ${_formatDate(order['date'])}',
      //           style: TextStyle(fontSize: 16)),
      //       SizedBox(height: 8),
      //       Text(
      //           'Total: \$${(order['totalPrice'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
      //           style: TextStyle(fontSize: 16)),
      //       SizedBox(height: 16),
      //       Text('Items:',
      //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      //       Expanded(
      //         child: _buildItemsList(),
      //       ),
      //       SizedBox(height: 16),
      //       _buildOrderStatus(),
      //     ],
      //   ),
      // ),
       body:Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${order['id'] ?? 'Unknown'}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Date: ${_formatDate(order['orderDate'])}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text(
                'Total: \$${(order['totalPrice'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
             Text('Shop: ${order['shop']?['name'] ?? 'Unknown Shop'}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Items:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: _buildItemsList(),
            ),
            SizedBox(height: 16),
            _buildOrderStatus(),
          ],
        ),
      ),
    );
  }

  // Widget _buildItemsList() {
  //   final items = order['items'];
  //   if (items == null) {
  //     return Center(child: Text('No items found'));
  //   }

  //   List<Widget> itemWidgets = [];

  //   if (items is List) {
  //     itemWidgets = items.map((item) => _buildItemTile(item)).toList();
  //   } else if (items is Map) {
  //     itemWidgets = items.entries
  //         .map((entry) => _buildItemTile(entry.value, name: entry.key))
  //         .toList();
  //   } else if (items is String) {
  //     itemWidgets = [
  //       ListTile(title: Text(items), subtitle: Text('Quantity: N/A KG'))
  //     ];
  //   }

  //   return ListView(children: itemWidgets);
  // }
  //   Widget _buildItemsList() {
  //   final items = order['items'] as Map<String, dynamic>?;
  //   if (items == null || items.isEmpty) {
  //     return Center(child: Text('No items found'));
  //   }

  //   return ListView.builder(
  //     itemCount: items.length,
  //     itemBuilder: (context, index) {
  //       final entry = items.entries.elementAt(index);
  //       return ListTile(
  //         title: Text(entry.key),
  //         subtitle: Text('Quantity: ${entry.value['quantity']} KG'),
  //         //add this 
  //         trailing: Text('\$${entry.value['price'].toStringAsFixed(2)}'),

  //       );
  //     },
  //   );
  // }
  Widget _buildItemsList() {
  final items = order['items'] as Map<String, dynamic>?;
  if (items == null || items.isEmpty) {
    return Center(child: Text('No items found'));
  }

  return ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) {
      final entry = items.entries.elementAt(index);
      final price = entry.value['price'];
      final quantity = entry.value['quantity'];
      
      return ListTile(
        title: Text(entry.key),
        subtitle: Text('Quantity: ${quantity ?? 'N/A'} KG'),
        trailing: Text('\$${price != null ? price.toStringAsFixed(2) : 'N/A'}'),
      );
    },
  );
}


  Widget _buildItemTile(dynamic item, {String? name}) {
    String itemName = 'Unknown Item';
    String quantity = 'N/A';
    String? price;

    if (item is Map<String, dynamic>) {
      itemName = item['name']?.toString() ?? name ?? 'Unknown Item';
      quantity = item['quantity']?.toString() ?? 'N/A';
      price = (item['price'] as num?)?.toStringAsFixed(2) ?? 'N/A';
    } else if (item is String) {
      itemName = name ?? 'Item';
      quantity = item;
    }

    return ListTile(
      title: Text(itemName),
      subtitle: Text('Quantity: $quantity KG'),
      // trailing: Text('\$$price'),
    );
  }

  // String _formatDate(dynamic dateValue) {
  //   if (dateValue == null) return 'No date';
  //   try {
  //     DateTime date = DateTime.parse(dateValue.toString());
  //     return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  //   } catch (e) {
  //     print('Error parsing date: $e');
  //     return 'Invalid date';
  //   }
  // }
  String _formatDate(dynamic dateValue) {
  if (dateValue == null) return 'No date';
  
  try {
    if (dateValue is Timestamp) {
      final date = dateValue.toDate();
      return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    } else if (dateValue is String) {
      final date = DateTime.parse(dateValue);
      return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    } else {
      return 'Invalid date format';
    }
  } catch (e) {
    print('Error parsing date: $e');
    return 'Invalid date';
  }
}

  // Widget _buildOrderStatus() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text('Order Status:',
  //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
  //       SizedBox(height: 8),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           _buildStatusCircle('Created', Colors.green, true),
  //           _buildStatusCircle('Ready', Colors.orange, false),
  //           _buildStatusCircle('Delivering', Colors.blue, false),
  //           _buildStatusCircle('Delivered', Colors.grey, false),
  //         ],
  //       ),
  //     ],
  //   );
  // }
   Widget _buildOrderStatus() {
    final status = order['status'] as String? ?? 'Created';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order Status:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatusCircle('Created', Colors.green, status == 'Created'),
            _buildStatusCircle('Ready', Colors.orange, status == 'Ready'),
            _buildStatusCircle('Delivering', Colors.blue, status == 'Delivering'),
            _buildStatusCircle('Delivered', Colors.grey, status == 'Delivered'),
          ],
        ),
      ],
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
            border: Border.all(color: color, width: 2),
          ),
          child: isActive
              ? Icon(Icons.check, size: 16, color: Colors.white)
              : null,
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? color : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
