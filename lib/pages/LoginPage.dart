// import 'package:flour_mill/vendor/models/shopregistration_model.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flour_mill/Screens/HomePage.dart';
// import 'package:flour_mill/vendor/vendor_homepage.dart';
// import 'package:flour_mill/UIComponents/CustomTextField.dart';
// import 'package:flour_mill/UIComponents/CustomButton.dart';
// import 'package:flour_mill/pages/SignUpPage.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   String _errorMessage = '';
//   bool _isLoading = false;

//   String? _emailError;
//   String? _passwordError;

//   void validateEmail(String value) {
//     setState(() {
//       if (value.isEmpty) {
//         _emailError = 'Email is required';
//       } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//         _emailError = 'Enter a valid email address';
//       } else {
//         _emailError = null;
//       }
//     });
//   }

//   void validatePassword(String value) {
//     setState(() {
//       if (value.isEmpty) {
//         _passwordError = 'Password is required';
//       } else {
//         _passwordError = null;
//       }
//     });
//   }

//   Future<void> loginUser() async {
//     validateEmail(emailController.text);
//     validatePassword(passwordController.text);

//     if (_emailError == null && _passwordError == null) {
//       setState(() {
//         _isLoading = true;
//         _errorMessage = '';
//       });

//       try {
//         UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//           email: emailController.text.trim(),
//           password: passwordController.text.trim(),
//         );

//         if (userCredential.user != null) {
//           // Check if user exists in Customers collection
//           DocumentSnapshot customerDoc = await _firestore
//               .collection('Customers')
//               .doc(userCredential.user!.uid)
//               .get();

//           if (customerDoc.exists) {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => HomePage()),
//             );
//           } else {
//             // If not in Customers, check Providers collection
//             DocumentSnapshot providerDoc = await _firestore
//                 .collection('Providers')
//                 .doc(userCredential.user!.uid)
//                 .get();

//             if (providerDoc.exists) {
//             Map<String, dynamic> rawshopData = providerDoc.data() as Map<String, dynamic>;
//            print("Raw Firestore data: $rawshopData"); // Add this line

//              Map<String, dynamic> shopData = {
//             'shopname': rawshopData['shopname'] ?? 'N/A',
//             'ownername': rawshopData['ownername'] ?? 'N/A',
//             'phonenumber': rawshopData['phonenumber'] ?? 'N/A',
//             'email': rawshopData['email'] ?? 'N/A',
//             'address': rawshopData['address'] ?? 'N/A',
//             'operatinghours': rawshopData['operatinghours'] ?? 'N/A',
//             'flourTypes': (rawshopData['flourTypes'] as List<dynamic>?)?.map((item) => 
//                 FlourType(
//                   name: item['name'] ?? 'Unknown',
//                   price: (item['price'] ?? 0).toDouble(),
//                 ).toMap()
//               ).toList() ?? [],
//             'imageUrl': rawshopData['imageUrl'] ?? '',
//             'userType': rawshopData['userType'] ?? 'provider',
//             'createdAt': rawshopData['createdAt'] ?? DateTime.now(),
//             // Add any other fields you expect in shopData
//           };

//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => VendorHomepage(shopData:shopData)),
//               );
//             } else {
//               // User not found in either collection
//               await _auth.signOut();
//               setState(() {
//                 _errorMessage = 'User not found. Please check your credentials or sign up.';
//               });
//             }
//           }
//         }
//       } on FirebaseAuthException catch (e) {
//         setState(() {
//           _errorMessage = 'Login failed: ${e.message}';
//         });
//       } catch (e) {
//         setState(() {
//           _errorMessage = 'An unexpected error occurred. Please try again.';
//         });
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login Page'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               CustomTextField(
//                 label: "Email",
//                 hintText: "Enter Email ID",
//                 controller: emailController,
//                 prefixIcon: Icons.email,
//                 isPassword: false,
//                 errorText: _emailError,
//                 onChanged: validateEmail,
//                 validator: (String? value) => null,
//               ),
//               const SizedBox(height: 20),
//               CustomTextField(
//                 label: "Password",
//                 hintText: "Enter Password",
//                 controller: passwordController,
//                 prefixIcon: Icons.lock,
//                 isPassword: true,
//                 errorText: _passwordError,
//                 onChanged: validatePassword,
//                 validator: (String? value) => null,
//               ),
//               const SizedBox(height: 20),
//               if (_errorMessage.isNotEmpty)
//                 Text(
//                   _errorMessage,
//                   style: const TextStyle(color: Colors.red),
//                 ),
//               const SizedBox(height: 20),
//               _isLoading
//                   ? CircularProgressIndicator()
//                   : CustomButton(
//                       onPressed: loginUser,
//                       label: 'Login',
//                       icon: Icons.login,
//                     ),
//               const SizedBox(height: 20),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => const SignUpPage()),
//                   );
//                 },
//                 child: const Text("Don't have an account? Sign Up"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flour_mill/Screens/HomePage.dart';
import 'package:flour_mill/vendor/vendor_homepage.dart';
import 'package:flour_mill/UIComponents/CustomTextField.dart';
import 'package:flour_mill/UIComponents/CustomButton.dart';
import 'package:flour_mill/pages/SignUpPage.dart';
import 'package:flour_mill/admin/admin_homepage.dart';
import 'package:flour_mill/vendor/models/shopregistration_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _errorMessage = '';
  bool _isLoading = false;

  String? _emailError;
  String? _passwordError;

  void validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        _emailError = 'Email is required';
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        _emailError = 'Enter a valid email address';
      } else {
        _emailError = null;
      }
    });
  }

  void validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _passwordError = 'Password is required';
      } else {
        _passwordError = null;
      }
    });
  }

  Future<void> loginUser() async {
    validateEmail(emailController.text);
    validatePassword(passwordController.text);

    if (_emailError == null && _passwordError == null) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        // Check for admin login
        QuerySnapshot adminSnapshot = await _firestore
            .collection('Admins')
            .where('email', isEqualTo: emailController.text.trim())
            .limit(1)
            .get();

        if (adminSnapshot.docs.isNotEmpty) {
          // Admin found, verify password
          String storedPassword = adminSnapshot.docs.first['password'];
          if (passwordController.text == storedPassword) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdminHomepage()),
            );
            return;
          } else {
            setState(() {
              _errorMessage = 'Invalid admin credentials';
            });
            return;
          }
        }

        // Proceed with regular user login
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        if (userCredential.user != null) {
          // Check if user exists in Customers collection
          DocumentSnapshot customerDoc = await _firestore
              .collection('Customers')
              .doc(userCredential.user!.uid)
              .get();

          if (customerDoc.exists) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else {
            // If not in Customers, check Providers collection
            DocumentSnapshot providerDoc = await _firestore
                .collection('Providers')
                .doc(userCredential.user!.uid)
                .get();

            if (providerDoc.exists) {
              Map<String, dynamic> rawshopData = providerDoc.data() as Map<String, dynamic>;
              print("Raw Firestore data: $rawshopData");

              Map<String, dynamic> shopData = {
                'shopname': rawshopData['shopname'] ?? 'N/A',
                'ownername': rawshopData['ownername'] ?? 'N/A',
                'phonenumber': rawshopData['phonenumber'] ?? 'N/A',
                'email': rawshopData['email'] ?? 'N/A',
                'address': rawshopData['address'] ?? 'N/A',
                'operatinghours': rawshopData['operatinghours'] ?? 'N/A',
                'flourTypes': (rawshopData['flourTypes'] as List<dynamic>?)?.map((item) => 
                    FlourType(
                      name: item['name'] ?? 'Unknown',
                      price: (item['price'] ?? 0).toDouble(),
                    ).toMap()
                  ).toList() ?? [],
                'imageUrl': rawshopData['imageUrl'] ?? '',
                'userType': rawshopData['userType'] ?? 'provider',
                'createdAt': rawshopData['createdAt'] ?? DateTime.now(),
              };

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => VendorHomepage(shopData: shopData)),
              );
            } else {
              // User not found in either collection
              await _auth.signOut();
              setState(() {
                _errorMessage = 'User not found. Please check your credentials or sign up.';
              });
            }
          }
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = 'Login failed: ${e.message}';
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'An unexpected error occurred. Please try again.';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomTextField(
                label: "Email",
                hintText: "Enter Email ID",
                controller: emailController,
                prefixIcon: Icons.email,
                isPassword: false,
                errorText: _emailError,
                onChanged: validateEmail,
                validator: (String? value) => null,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: "Password",
                hintText: "Enter Password",
                controller: passwordController,
                prefixIcon: Icons.lock,
                isPassword: true,
                errorText: _passwordError,
                onChanged: validatePassword,
                validator: (String? value) => null,
              ),
              const SizedBox(height: 20),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : CustomButton(
                      onPressed: loginUser,
                      label: 'Login',
                      icon: Icons.login,
                    ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                  );
                },
                child: const Text("Don't have an account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}