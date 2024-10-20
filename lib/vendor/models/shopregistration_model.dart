import 'dart:io';

class ShopRegistration {
  final String shopname;
  final String ownername;
  final String phonenumber;
  final String email;
  final String address;
  final String operatinghours;
  final String flours;
  final File image;



  ShopRegistration({
    required this.shopname,
    required this.ownername,
    required this.phonenumber,
    required this.email, 
    required this.address, 
    required this.operatinghours,
    required this.flours,
    required this.image});
}