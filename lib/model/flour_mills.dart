// // lib/models/flour_mill.dart
// class FlourMill {
//   final String imageUrl;
//   final String deliveryInfo;
//   final String tag;
//   final String name;
//   final double rating;
//   final String type;

//   FlourMill({
//     required this.imageUrl,
//     required this.deliveryInfo,
//     required this.tag,
//     required this.name,
//     required this.rating,
//     required this.type,
//   });
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class FlourMill {
  final String id;
  final String imageUrl;
  final String shopname;
  final String address;
  final double rating;
  final List<Map<String, double>> flourTypes; // Map of flour type to price

  FlourMill({
    required this.id,
    required this.imageUrl,
    required this.shopname,
    required this.address,
    required this.rating,
    required this.flourTypes,
  });
}

  // factory FlourMill.fromMap(Map<String, dynamic> map, String id) {
  //  // Map data = doc.data() as Map<String, dynamic>;
  //   return FlourMill(
  //     // flourTypes: data['flourTypes'] ?? {},
  //     imageUrl: map['imageUrl'] ?? '',
  //     address: map['address'] ?? '',
  //     shopname: map['shopname'] ?? '',
  //     rating: (map['rating'] ?? 0).toDouble(),
  // // flourTypes: _parseFlourTypes(map['flourTypes']),
  //   );
  // }

//   static List<Map<String, double>> _parseFlourTypes(dynamic flourTypes) {
//     if (flourTypes is List) {
//       return flourTypes.map((item) {
//         if (item is Map) {
//           return Map<String, double>.from(item.map((key, value) => 
//             MapEntry(key, (value as num).toDouble())
//           ));
//         }
//         return <String, double>{};
//       }).toList();
//     }
//     return [];
//   }
// }
// 