import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Order History"),
        ),
        body: const Center(
          child: Text("Uhh...Ohh, No Orders Yet!",style: TextStyle(fontSize: 20),),
        ),
      ),
    );
  }
}
