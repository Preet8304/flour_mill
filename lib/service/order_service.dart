import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createOrder(String customerId, List<Map<String, dynamic>> items, double totalAmount) async {
    try {
      // Generate a unique orderId
      String orderId = _firestore.collection('Customers').doc(customerId).collection('Orders').doc().id;

      await _firestore.collection('Customers').doc(customerId).collection('Orders').doc(orderId).set({
        'orderId': orderId,
        'dateOfOrder': Timestamp.now(),
        'totalAmount': totalAmount,
        'items': items,
        'status': 'Pending'
      });

      print('Order created successfully');
    } catch (e) {
      print('Error creating order: $e');
    }
  }
}