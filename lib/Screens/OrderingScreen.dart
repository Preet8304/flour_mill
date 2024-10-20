import 'package:flour_mill/Widgets/ItemCard.dart';
import 'package:flour_mill/Widgets/cart_stack.dart';
import 'package:flutter/material.dart';
import 'package:flour_mill/model/flour_mills.dart'; // Add this import

class OrderingScreen extends StatefulWidget {
  final FlourMill mills;
  const OrderingScreen({super.key, required this.mills});

  @override
  State<OrderingScreen> createState() => _OrderingScreenState();
}

class _OrderingScreenState extends State<OrderingScreen> {
  Map<String, int> cart = {}; // Manage cart items here

  void _removeFromCart(String itemName) {
    setState(() {
      cart.remove(itemName);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate total cart items


    final cartCount = cart.values.fold(0, (sum, quantity) => sum + 1); // solved quantity  error code 'sum+quantity'
    //final cartCount = cart.values.fold(0, (sum, quantity) => sum + 1);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mills.name),
        actions: [
          CartStack(
            cartItemCount: cartCount,
            cart: cart,
            onRemoveFromCart: _removeFromCart,
          ),
        ],
      ),
      body: Column(
        children: [
          // Use Expanded to make sure ListView or other content is not constrained
          Expanded(
            child: ItemCard(
              cart: cart, // Pass cart to ItemCard
              onAddToCart: (String flourName, int quantity) {
                // Update cart when items are added
                setState(() {
                  cart[flourName] = (cart[flourName] ?? 0) + quantity; //quantity
                });
              },
              onRemoveFromCart: _removeFromCart,
              cartCount: cartCount, // Optionally pass remove callback
            ),
          ),
        ],
      ),
    );
  }
}
