import 'package:flutter/material.dart';

class ItemCardWidget extends StatefulWidget {
  final String name;
  final double price;
  final String image;
  final void Function(int quantity) onAdd;

  const ItemCardWidget({
    required this.name,
    required this.price,
    required this.image,
    required this.onAdd,
    super.key,
  });

  @override
  _ItemCardWidgetState createState() => _ItemCardWidgetState();
}

class _ItemCardWidgetState extends State<ItemCardWidget> {
  final TextEditingController quantityController =
      TextEditingController(text: '1'); // Default quantity is 1

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
                child: Image.network(
                  widget.image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.error);
            },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("\₹${widget.price.toStringAsFixed(2)}/kg"),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Quantity (kg)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  final int quantity =
                      int.tryParse(quantityController.text) ?? 1;
                  widget.onAdd(quantity);
                },
                child: const Text('ADD'),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
