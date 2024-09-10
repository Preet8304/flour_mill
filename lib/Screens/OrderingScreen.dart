import 'package:flour_mill/Widgets/AppbarWidget.dart';
import 'package:flour_mill/model/flour_mills.dart';
import 'package:flutter/material.dart';
import 'package:flour_mill/model/flour_mill_data.dart';

class OrderingScreen extends StatefulWidget {
  const OrderingScreen({super.key,required this.mills});
  
  final FlourMill mills;
  
  @override
  State<OrderingScreen> createState() => _OrderingScreenState();
}

class _OrderingScreenState extends State<OrderingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.mills.name),)
    );
  }
}
