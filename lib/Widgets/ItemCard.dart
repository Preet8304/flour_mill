import 'package:flutter/material.dart';
/*import 'package:flour_mill/';*/

class FlourMillScreen extends StatefulWidget {
  @override
  _FlourMillScreenState createState() => _FlourMillScreenState();
}

class _FlourMillScreenState extends State<FlourMillScreen> {
  final List<Map<String, dynamic>> flours = [
    {'name': 'Wheat Flour', 'price': 0.50, 'image': 'lib/assets/categories/(1).png'},
    {'name': 'Rice Flour', 'price': 0.60, 'image': 'lib/assets/categories/(2).png'},
    {'name': 'Corn Flour', 'price': 0.70, 'image': 'lib/assets/categories/(2).png'},
    {'name': 'Plain Flour', 'price': 0.80, 'image': 'lib/assets/categories/(2).png'},
    {'name': 'Barley Flour', 'price': 0.90, 'image': 'lib/assets/categories/(2).png'},
  ];

  Map<String, int> cart = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: flours.length,
                itemBuilder: (context, index) {
                  final flour = flours[index];
                  return FlourItemCard(
                    name: flour['name'],
                    price: flour['price'],
                    image: flour['image'],
                    onAdd: (quantity) {
                      setState(() {
                        cart[flour['name']] =
                            (cart[flour['name']] ?? 0) + quantity;
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Updated parameter
                foregroundColor: Colors.white, // Updated parameter
                minimumSize: const Size(double.infinity, 50), // full-width button
              ),
              onPressed: () {
                // Handle add to cart action
                final cartCount =
                cart.values.fold(0, (sum, quantity) => sum + quantity);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added $cartCount items to cart')),
                );
              },
              child: Text(
                  'Add to Cart (${cart.values.fold(0, (sum, quantity) => sum + quantity)})'),
            ),
          ],
        ),
      ),
    );
  }
}

class FlourItemCard extends StatefulWidget {
  final String name;
  final double price;
  final String image;
  final void Function(int quantity) onAdd;

  FlourItemCard(
      {required this.name,
        required this.price,
        required this.image,
        required this.onAdd});

  @override
  _FlourItemCardState createState() => _FlourItemCardState();
}

class _FlourItemCardState extends State<FlourItemCard> {
  TextEditingController quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  widget.image,
                  width: 80,
                  height:80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("\$${widget.price.toStringAsFixed(2)}/kg"),
                  ],
                ),
              ),
              Positioned(child: const Text('Quantity')),
              Container(
                width: 80,
                child: TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Quantity',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, // Updated parameter
                foregroundColor: Colors.black, // Updated parameter
              ),
              onPressed: () {
                final quantity = int.tryParse(quantityController.text) ?? 0;
                if (quantity > 0) {
                  widget.onAdd(quantity);
                  quantityController.clear();
                }
              },
              child: const Text('ADD'),
            ),
          ),
        ],
      ),
    );
  }
}
