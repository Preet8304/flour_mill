import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this import
import 'dart:convert'; // Add this import

class CheckoutSummary extends StatefulWidget {
  final Map<String, int> cart;
  final Function(String) onRemove; // Callback to remove item from cart
  final Function() refreshHomePage; // Add this line

  const CheckoutSummary(
      {super.key,
      required this.cart,
      required this.onRemove,
      required this.refreshHomePage,
      required List orderHistory}); // Add this line

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutSummary> {
  late Map<String, int> _cart;
  late Map<String, double> _prices;
  double _totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _cart = Map.from(widget.cart); // Create a copy of the cart
    _prices = {
      'Wheat Flour': 0.50,
      'Rice Flour': 0.60,
      'Corn Flour': 0.70,
      'Plain Flour': 0.80,
      'Barley Flour': 0.90,
    };
    _calculateTotalPrice();
  }

  void _calculateTotalPrice() {
    setState(() {
      _totalPrice = _cart.entries.fold(0.0, (sum, entry) {
        final price = _prices[entry.key] ?? 0.0;
        return sum + (price * entry.value);
      });
    });
  }

  void _updateQuantity(String itemName, int delta) {
    setState(() {
      if (_cart.containsKey(itemName)) {
        _cart[itemName] =
            (_cart[itemName]! + delta).clamp(1, double.infinity).toInt();
        if (_cart[itemName] == 0) {
          _cart.remove(itemName);
          widget.onRemove(itemName); // Notify removal to parent
        }
      }
      _calculateTotalPrice();
    });
  }

  void _removeItem(String itemName) {
    setState(() {
      _cart.remove(itemName);
      widget.onRemove(itemName); // Notify removal to parent
      _calculateTotalPrice();
    });
  }

  void _showConfirmationAndNavigateToOrderHistory() {
    _saveOrder().then((_) {
      // Show a dialog instead of a banner
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Order Confirmed!',
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 64),
                const SizedBox(height: 16),
                const Text(
                  'Your order has been placed successfully.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Total: \$${_totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Explore More...'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  _navigateToHomePage();
                },
              ),
            ],
          );
        },
      );
    });
  }

  Future<void> _saveOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final newOrder = {
      'orderId': 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      'orderDate': DateTime.now().toIso8601String(),
      'totalPrice': _totalPrice,
      'items': _cart.map((key, value) => MapEntry(key, value.toString())),
    };

    List<String> orderHistory = prefs.getStringList('orderHistory') ?? [];
    orderHistory.add(jsonEncode(newOrder));
    await prefs.setStringList('orderHistory', orderHistory);
  }

  void _navigateToHomePage() {
    widget.refreshHomePage(); // Call the refresh function
    Navigator.of(context).popUntil(
        (route) => route.isFirst); // Navigate to the first route (HomePage)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Return the updated cart when navigating back
            Navigator.pop(context, _cart);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _cart.isEmpty
            ? Center(
                child: Text(
                  'Your cart is empty',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Items in your Cart:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _cart.length,
                      itemBuilder: (context, index) {
                        final itemName = _cart.keys.elementAt(index);
                        final itemQuantity = _cart[itemName]!;
                        final itemPrice = _prices[itemName]!;
                        final itemTotal = itemQuantity * itemPrice;
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            leading: ClipOval(
                              child: Image.network(
                                _getImageUrlForItem(itemName),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(itemName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                'Price: \$${itemPrice.toStringAsFixed(2)}/kg'),
                            trailing: SizedBox(
                              width: 150,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () => _removeItem(itemName),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.remove),
                                                onPressed: () =>
                                                    _updateQuantity(
                                                        itemName, -1),
                                              ),
                                              Text(
                                                itemQuantity.toString(),
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                              Expanded(
                                                child: IconButton(
                                                  icon: const Icon(Icons.add),
                                                  onPressed: () =>
                                                      _updateQuantity(
                                                          itemName, 1),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      'Total Price: \$${_totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _showConfirmationAndNavigateToOrderHistory,
                    child: const Text('Confirm Order'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // Helper function to get the image URL for an item
  String _getImageUrlForItem(String itemName) {
    switch (itemName) {
      case 'Wheat Flour':
        return 'https://pics.craiyon.com/2023-09-11/de956556ea004e0cb90831c6c8997bcb.webp';
      case 'Rice Flour':
        return 'https://pics.craiyon.com/2023-10-05/a34a301c25e544c89d9f315dd0665256.webp';
      case 'Corn Flour':
        return 'https://pics.craiyon.com/2023-10-15/032a2f1739de4b4b9930e4f731cc4849.webp';
      case 'Plain Flour':
        return 'https://pics.craiyon.com/2023-10-15/7756a4de78a649948f9a30e8598338a3.webp';
      case 'Barley Flour':
        return 'https://pics.craiyon.com/2023-11-06/51770d6668434a35b69b4c58f40d1d32.webp';
      default:
        return 'https://via.placeholder.com/80';
    }
  }
}
