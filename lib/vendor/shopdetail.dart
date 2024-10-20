import 'package:flutter/material.dart';
import 'package:flour_mill/vendor/models/shopregistration_model.dart';

class ShopDetailsPage extends StatelessWidget {
  final ShopRegistration shopRegistration;

  const ShopDetailsPage({Key? key, required this.shopRegistration}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Shop Registration Details:');
    print('Shop Name: ${shopRegistration.shopname}');
    print('Owner Name: ${shopRegistration.ownername}');
    print('Phone Number: ${shopRegistration.phonenumber}');
    print('Email: ${shopRegistration.email}');
    print('Address: ${shopRegistration.address}');
    print('Operating Hours: ${shopRegistration.operatinghours}');
    print('Flour Types and Prices:');
    for (var flour in shopRegistration.flourTypes) {
      print('${flour.name}: ${flour.price}');
    }
    print('Image: ${shopRegistration.image}');

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Shop Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text('Debug: ${shopRegistration.toString()}'), // Add this line for debugging

            _buildDetailItem('Shop Name', shopRegistration.shopname.toString()),
            _buildDetailItem('Owner Name', shopRegistration.ownername.toString()),
            _buildDetailItem('Phone Number', shopRegistration.phonenumber),
            _buildDetailItem('Email', shopRegistration.email),
            _buildDetailItem('Address', shopRegistration.address),
            _buildDetailItem('Operating Hours', shopRegistration.operatinghours),
            _buildDetailItem('Flours Available',  _formatFlours(shopRegistration.flourTypes)),
            if (shopRegistration.image != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Shop Image:', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Image.file(
                      shopRegistration.image!,
                      width: 500,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatFlours(List<FlourType> flours) {
    return flours.map((flour) => '${flour.name}: ${flour.price}').join(', ');
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label:', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(value,style: TextStyle(color: value == null ? Colors.red : Colors.black),),
        ],
      ),
    );
  }
}
