// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flour_mill/model/flour_mills.dart';

// class FlourMillService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<List<FlourMill>> getFlourMills() async {
//     try {
//       QuerySnapshot querySnapshot = await _firestore.collection('Providers').get();
//       return querySnapshot.docs.map((doc) => FlourMill.fromFirestore(doc)).toList();
//     } catch (e) {
//       print('Error fetching flour mills: $e');
//       return [];
//     }
  // }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flour_mill/model/flour_mills.dart';

class FlourMillService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<FlourMill>> getFlourMills() async {
    print("Fetching flour mills from Firestore");
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('Providers').get();
      print("Number of documents fetched: ${querySnapshot.docs.length}");
      
      List<FlourMill> mills = [];
      for (var doc in querySnapshot.docs) {
        try {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          print("Processing document: ${doc.id}");
          print("Document data: $data");
          
       List<Map<String, double>> flourTypes = [];
if (data['flourTypes'] != null) {
  for (var type in data['flourTypes']) {
    if (type is Map) {
      flourTypes.add(Map<String, double>.from(type.map((key, value) {
        double doubleValue;
        if (value is num) {
          doubleValue = value.toDouble();
        } else if (value is String) {
          doubleValue = double.tryParse(value) ?? 0.0;
        } else {
          doubleValue = 0.0;
        }
        return MapEntry(key, doubleValue);
      })));
    } else {
      print("Invalid flourType: $type");
    }
  }
}

          FlourMill mill = FlourMill(
            id: doc.id,
            shopname: data['shopname'] ?? '',
            imageUrl: data['imageUrl'] ?? '',
            rating: (data['rating'] ?? 0).toDouble(),
            address: data['address'] ?? '',
            flourTypes: flourTypes,
          );
          mills.add(mill);
          print("Successfully created FlourMill object for ${mill.shopname}");
        } catch (e) {
          print("Error processing document ${doc.id}: $e");
        }
      }

      print("Number of FlourMill objects created: ${mills.length}");
      return mills;
    } catch (e, stackTrace) {
      print('Error fetching flour mills: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }
}