import 'package:flutter/material.dart';

class CheckoutSummary extends StatefulWidget {
  final Map<String, int> cart;
  final Function(String) onRemove; // Callback to remove item from cart

  const CheckoutSummary(
      {super.key, required this.cart, required this.onRemove});

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
                                                    _updateQuantity(itemName, -1),
                                              ),
                                              Text(
                                                itemQuantity.toString(),
                                                style:
                                                    const TextStyle(fontSize: 16),
                                              ),
                                              Expanded(
                                                child: IconButton(
                                                  icon: const Icon(Icons.add),
                                                  onPressed: () =>
                                                      _updateQuantity(itemName, 1),
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
                    onPressed: () {
                      // Handle payment or order confirmation
                      // For now, we'll just show a confirmation dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirm Order'),
                          content: Text(
                            'Are you sure you want to confirm the order with a total of \$${_totalPrice.toStringAsFixed(2)}?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Handle order confirmation
                                Navigator.pop(context);
                                Navigator.pop(
                                    context, _cart); // Pass updated cart back
                              },
                              child: const Text('Confirm'),
                            ),
                          ],
                        ),
                      );
                    },
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
