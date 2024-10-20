// import 'package:flour_mill/Screens/checkoutSummary.dart';
// import 'package:flutter/material.dart';
// import 'package:flour_mill/Widgets/itemCardWidget.dart';

// class ItemCard extends StatefulWidget {
//   final Function(String flourName, int quantity) onAddToCart;
//   final Map<String, int> cart;
//   final int cartCount;
//   final Function(String itemName) onRemoveFromCart;

//   const ItemCard({
//     Key? key,
//     required this.onAddToCart,
//     required this.cart,
//     required this.cartCount,
//     required this.onRemoveFromCart,
//   }) : super(key: key);

//   @override
//   _ItemCardState createState() => _ItemCardState();
// }

// class _ItemCardState extends State<ItemCard> {
//   final List<Map<String, dynamic>> flours = [
//     {
//       'name': 'Wheat Flour',
//       'price': 0.50,
//       'image':
//           'https://pics.craiyon.com/2023-09-11/de956556ea004e0cb90831c6c8997bcb.webp'
//     },
//     {
//       'name': 'Rice Flour',
//       'price': 0.60,
//       'image':
//           'https://pics.craiyon.com/2023-10-05/a34a301c25e544c89d9f315dd0665256.webp'
//     },
//     {
//       'name': 'Corn Flour',
//       'price': 0.70,
//       'image':
//           'https://pics.craiyon.com/2023-10-15/032a2f1739de4b4b9930e4f731cc4849.webp'
//     },
//     {
//       'name': 'Plain Flour',
//       'price': 0.80,
//       'image':
//           'https://pics.craiyon.com/2023-10-15/7756a4de78a649948f9a30e8598338a3.webp'
//     },
//     {
//       'name': 'Barley Flour',
//       'price': 0.90,
//       'image':
//           'https://pics.craiyon.com/2023-11-06/51770d6668434a35b69b4c58f40d1d32.webp'
//     },
//     // Add more flour items as needed
//   ];

//   void _addToCart(String flourName, int quantity) {
//     if (widget.cart.containsKey(flourName)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Item is already in the cart!'),
//           backgroundColor: Colors.redAccent,
//           duration: Duration(seconds: 2),
//         ),
//       );
//     } else {
//       widget.onAddToCart(flourName, quantity);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('$flourName added to the cart!'),
//           backgroundColor: Colors.green,
//           duration: const Duration(seconds: 2),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: flours.length,
//               itemBuilder: (context, index) {
//                 final flour = flours[index];
//                 return ItemCardWidget(
//                   name: flour['name'],
//                   price: flour['price'],
//                   image: flour['image'],
//                   onAdd: (quantity) {
//                     _addToCart(flour['name'], quantity);
//                   },
//                 );
//               },
//             ),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.orange,
//               foregroundColor: Colors.white,
//               minimumSize: const Size(double.infinity, 50),
//             ),
//             onPressed: () {
//               if (widget.cart.isNotEmpty) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => CheckoutSummary(
//                       cart: widget.cart,
//                       onRemove: widget.onRemoveFromCart,
//                       orderHistory: [],
//                       refreshHomePage: () => setState(() {}),
//                     ),
//                   ),
//                 );
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Cart is empty! Add some items first.'),
//                     backgroundColor: Colors.red,
//                   ),
//                 );
//               }
//             },
//             child: Stack(
//               children: [
//                 const Center(child: Text('Checkout')),
//                 if (widget.cartCount > 0)
//                   Positioned(
//                     right: 0,
//                     child: CircleAvatar(
//                       radius: 10,
//                       backgroundColor: Colors.red,
//                       child: Text(
//                         '${widget.cartCount}',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flour_mill/Screens/checkoutSummary.dart';
import 'package:flour_mill/utils/flour_images.dart';
import 'package:flutter/material.dart';
import 'package:flour_mill/Widgets/itemCardWidget.dart';

class ItemCard extends StatefulWidget {
  final String vendorId;
  final String shopName;
  final Function(String flourName, int quantity) onAddToCart;
  final Map<String, int> cart;
  final int cartCount;
  final Function(String itemName) onRemoveFromCart;

  const ItemCard({
    Key? key,
    required this.vendorId,
    required this.shopName,
    required this.onAddToCart,
    required this.cart,
    required this.cartCount,
    required this.onRemoveFromCart,
  }) : super(key: key);

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  late Future<DocumentSnapshot> _vendorFuture;
  final FlourImages _flourImages = FlourImages();

  @override
  void initState() {
    super.initState();
    _vendorFuture = FirebaseFirestore.instance
        .collection('Providers')
        .doc(widget.vendorId)
        .get();
  }

  void _addToCart(String flourName, int quantity) {
    if (widget.cart.containsKey(flourName)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item is already in the cart!'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      widget.onAddToCart(flourName, quantity);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$flourName added to the cart!'),
          backgroundColor: const Color(0xFF4CAF50),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Debug - ItemCard vendorId: ${widget.vendorId}"); // Add this line
    print("Debug - ItemCard shopName: ${widget.shopName}"); // Add this line
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder<DocumentSnapshot>(
              future: _vendorFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final vendorData = snapshot.data!.data() as Map<String, dynamic>;
                final flours = vendorData['flourTypes'] as List<dynamic>? ?? [];

                return ListView.builder(
                  itemCount: flours.length,
                  itemBuilder: (context, index) {
                    final flour = flours[index] as Map<String, dynamic>;
                    return ItemCardWidget(
                      name: flour['name'],
                      price: flour['price'].toDouble(),
                      image: _flourImages.getFlourImage(flour['name']),
                      onAdd: (quantity) {
                        _addToCart(flour['name'], quantity);
                      },
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {
              if (widget.cart.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    
                    builder: (context) => CheckoutSummary(
                      shopId: widget.vendorId,
                      shopName: widget.shopName,
                      cart: widget.cart,
                      onRemove: widget.onRemoveFromCart,
                      orderHistory: [],
                      refreshHomePage: () => setState(() {}),
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cart is empty! Add some items first.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Stack(
              children: [
                const Center(child: Text('Checkout')),
                if (widget.cartCount > 0)
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Text(
                        '${widget.cartCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}