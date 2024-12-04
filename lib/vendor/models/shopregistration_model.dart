import 'dart:io';

class ShopRegistration {
  final String shopname;
  final String ownername;
  final String phonenumber;
  final String email;
  final String address;
  final String operatinghours;
  final File image;
  final List<FlourType> flourTypes;
  final String userType; 
  final DateTime createdAt; // Add this line



  ShopRegistration({
    required this.createdAt,
    required this.shopname,
    required this.ownername,
    required this.phonenumber,
    required this.email, 
    required this.address, 
    required this.operatinghours,
    required this.image,
    required this.flourTypes, required String imageUrl,
    required this.userType,
    });
}

class FlourType {
  final String name;
  double price;

  FlourType({required this.name, required this.price});
    Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
    };
  }
}