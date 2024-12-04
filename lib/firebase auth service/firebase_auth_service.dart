// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';

// class FirebaseAuthService {
//    final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<User?> signUpWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       UserCredential credential = await _auth.createUserWithEmailAndPassword(
//           email: email, password: password);
//       return credential.user;
//     } catch (e) {
//       if (kDebugMode) {
//         print("ERROR Creating User!!");
//       }
//     }
//     return null;
//   }

//   Future<User?> signInWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       UserCredential credential = await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
//       return credential.user;
//     } catch (e) {
//       if (kDebugMode) {
//         print("ERROR Signing In User!!");
//       }
//     }
//     return null;
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<UserCredential?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('The email address is already in use.');
      } else {
        throw Exception('An error occurred during sign-up.');
      }
    } catch (e) {
      if (kDebugMode) {
        print("ERROR Signing Up User: $e");
      }
      return null;
    }
  }

  // Future<User?> signInWithEmailAndPassword(
  //     String email, String password) async {
  //   try {
  //     UserCredential credential = await _auth.signInWithEmailAndPassword(
  //         email: email, password: password);
  //     return credential.user;
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print("ERROR Signing In User: $e");
  //     }
  //   }
  //   return null;
  // }
  Future<Map<String, dynamic>?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = credential.user;
      if (user != null) {
        // Check Customers collection
        DocumentSnapshot customerDoc = await _firestore.collection('Customers').doc(user.uid).get();
        if (customerDoc.exists) {
          return {'userType': 'customer', 'data': customerDoc.data() as Map<String, dynamic>};
        }
        
        // Check Providers collection
        DocumentSnapshot vendorDoc = await _firestore.collection('Providers').doc(user.uid).get();
        if (vendorDoc.exists) {
          return {'userType': 'provider', 'data': vendorDoc.data() as Map<String, dynamic>};
        }
        
        print("User document does not exist in either Customers or Providers collection");
        return null;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("ERROR Signing In User: $e");
      }
      return null;
    }
  }

}
