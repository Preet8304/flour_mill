// import 'package:flour_mill/Screens/HomePage.dart';
// import 'package:flour_mill/Screens/ProfileEdit.dart';
// import 'package:flour_mill/Screens/ProfileScreen.dart';
// import 'package:flour_mill/firebase%20auth%20service/firebase_auth_service.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flour_mill/UIComponents/CustomButton.dart';
// import 'package:flour_mill/UIComponents/CustomTextField.dart';
// import 'package:flour_mill/UIComponents/CustomToast.dart';
// import 'package:flour_mill/pages/LoginPage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../vendor/shopregistrationform.dart';

// class SignUpPage extends StatefulWidget {
//   const SignUpPage({Key? key}) : super(key: key);

//   @override
//   _SignUpPageState createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final FirebaseAuthService _auth = FirebaseAuthService();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _companyEmailController = TextEditingController();
//   final TextEditingController _companyPasswordController =
//       TextEditingController();
//   final TextEditingController _companyNameController = TextEditingController();

//   int _selectedTabIndex = 0;
//   final List<String> _tabTitles = ['Customer', 'Provider'];

//   final _formKey = GlobalKey<FormState>();

//   String? _nameError;
//   String? _emailError;
//   String? _phoneError;
//   String? _passwordError;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _nameController.dispose();
//     _companyEmailController.dispose();
//     _companyPasswordController.dispose();
//     _companyNameController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           title: const Text('Sign Up',
//               style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black)),
//           centerTitle: true,
//         ),
//         body: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(15.0, 60.0, 15.0, 0.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const CircleAvatar(
//                       radius: 70,
//                       backgroundImage:
//                           AssetImage('lib/assets/profile_image.jpg')),
//                   const SizedBox(height: 40),
//                   DefaultTabController(
//                     length: _tabTitles.length,
//                     initialIndex: _selectedTabIndex,
//                     child: Column(
//                       children: [
//                         TabBar(
//                           onTap: (index) {
//                             setState(() {
//                               _selectedTabIndex = index;
//                             });
//                           },
//                           tabs: _tabTitles
//                               .map((title) => Tab(text: title))
//                               .toList(),
//                           indicatorColor: Colors.blue,
//                           labelColor: Colors.blue,
//                           unselectedLabelColor: Colors.black,
//                         ),
//                         const SizedBox(height: 30.0),
//                         SizedBox(
//                           height: 240.0,
//                           child: TabBarView(
//                             physics: const NeverScrollableScrollPhysics(),
//                             children: [
//                               buildCustomerFields(),
//                               buildProviderFields(),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 24.0),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: CustomButton(
//                       label: 'Sign Up',
//                       icon: Icons.check,
//                       onPressed: () => _handleSignUp(context),
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text('Already have an account?'),
//                       TextButton(
//                         onPressed: () => Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const LoginPage())),
//                         child: const Text('Login'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildCustomerFields() {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: CustomTextField(
//             controller: _nameController,
//             label: "Full Name",
//             hintText: "Enter your full name",
//             errorText: _nameError,
//             isPassword: false,
//             prefixIcon: Icons.person,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Full name is required';
//               }
//               return null;
//             },
//             onChanged: (value) => validateName(value),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: CustomTextField(
//             controller: _emailController,
//             isPassword: false,
//             label: "Email",
//             hintText: "Enter your email",
//             errorText: _emailError,
//             prefixIcon: Icons.email,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Email is required';
//               }
//               if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
//                   .hasMatch(value)) {
//                 return 'Enter a valid email address';
//               }
//               return null;
//             },
//             onChanged: (value) => validateEmail(value),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: CustomTextField(
//             controller: _passwordController,
//             label: "Password",
//             isPassword: true,
//             hintText: "Enter your password",
//             errorText: _passwordError,
//             prefixIcon: Icons.lock,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Password is required';
//               }
//               if (value.length < 8) {
//                 return 'Password must be at least 8 characters long';
//               }
//               return null;
//             },
//             onChanged: (value) => validatePassword(value),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget buildProviderFields() {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: CustomTextField(
//             controller: _companyEmailController,
//             label: "Provider Email",
//             isPassword: false,
//             prefixIcon: Icons.email,
//             hintText: "Enter Provider Email",
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Provider Email is required';
//               }
//               if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
//                   .hasMatch(value)) {
//                 return 'Enter a valid email address';
//               }
//               return null;
//             },
//             errorText: _emailError,
//             onChanged: (value) => validateEmail(value),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: CustomTextField(
//             controller: _companyPasswordController,
//             label: "Provider Password",
//             hintText: "Enter Provider password",
//             isPassword: true,
//             errorText: _passwordError,
//             prefixIcon: Icons.lock,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Provider Password is required';
//               }
//               if (value.length < 8) {
//                 return 'Password must be at least 8 characters long';
//               }
//               return null;
//             },
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: CustomTextField(
//             isPassword: false,
//             controller: _companyNameController,
//             label: "Provider Name",
//             hintText: "Enter Provider name",
//             errorText: _nameError,
//             prefixIcon: Icons.business,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Provider Name is required';
//               }
//               return null;
//             },
//             onChanged: (value) => validateName(value),
//           ),
//         ),
//       ],
//     );
//   }

//   void validateName(String value) {
//     setState(() {
//       _nameError = value.isEmpty ? 'Name is required' : null;
//     });
//   }

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

//   void validatePhone(String value) {
//     setState(() {
//       if (value.isEmpty) {
//         _phoneError = 'Phone number is required';
//       } else if (!RegExp(r'^\+?[0-9]{10,14}$').hasMatch(value)) {
//         _phoneError = 'Enter a valid phone number';
//       } else {
//         _phoneError = null;
//       }
//     });
//   }

//   void validatePassword(String value) {
//     setState(() {
//       if (value.isEmpty) {
//         _passwordError = 'Password is required';
//       } else if (value.length < 6) {
//         _passwordError = 'Password must be at least 6 characters long';
//       } else {
//         _passwordError = null;
//       }
//     });
//   }

//   void _handleSignUp(BuildContext context) async {
//     final String email;
//     final String password;
//     final String name;
//     final userType = _selectedTabIndex == 0 ? 'customer' : 'provider';

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => const Center(
//           child: CircularProgressIndicator(
//               color: Colors.blueAccent, strokeWidth: 2)),
//     );

//     if (_selectedTabIndex == 0) {
//       email = _emailController.text;
//       password = _passwordController.text;
//       name = _nameController.text;
//     } else {
//       email = _companyEmailController.text;
//       password = _companyPasswordController.text;
//       name = _companyNameController.text;
//     }

//     if (email.isEmpty || password.isEmpty || name.isEmpty) {
//       Navigator.pop(context); // Dismiss the dialog
//       showCustomToast(context, 'Please fill in all fields');
//       return;
//     }

//     try {
//       UserCredential? userCredential =
//           await _auth.signUpWithEmailAndPassword(email, password);
//       User? user = userCredential?.user;
//       FirebaseFirestore firestore = FirebaseFirestore.instance;
//       CollectionReference userCollection;

//       if (user != null) {
//         // Store user details in Firestore
//         if (userType == 'customer') {
//           userCollection = firestore.collection('Customers');
//         } else {
//           userCollection = firestore.collection('Providers');
//         }

//         await userCollection.doc(user.uid).set({
//           'email': email,
//           'name': name,
//           'userType': userType,
//           'phone': '',
//           'location': '',
//           'createdAt': Timestamp.now(), // Timestamp for record creation
//         });

//         Navigator.pop(context); // Dismiss the dialog

//         if (userType == 'customer') {
//           // Navigate to HomePage for Customers
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => ProfileEdit(
//                     name: name,
//                     userType: userType,
//                     uid: user.uid,
//                     phone: '',
//                     location: '')),
//           );
//         } else {
//           // Navigate to ShopRegistrationForm for Providers
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => ShopRegistrationForm(
//                       email: email,
//                       name: name,
//                     )),
//           );
//         }
//       }
//     } catch (error) {
//       Navigator.pop(context); // Dismiss the dialog
//       if (error is FirebaseAuthException && error.code == 'email-already-in-use') {
//         showCustomToast(context, 'The email address is already in use.');
//       } else {
//         showCustomToast(context, 'Error: ${error.toString()}');
//       }
//     }
//   }

//   void showCustomToast(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: CustomToast(message: message),
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flour_mill/Screens/ProfileEdit.dart';
import 'package:flour_mill/firebase%20auth%20service/firebase_auth_service.dart';
import 'package:flour_mill/UIComponents/CustomButton.dart';
import 'package:flour_mill/UIComponents/CustomTextField.dart';
import 'package:flour_mill/pages/LoginPage.dart';
import '../vendor/shopregistrationform.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _companyEmailController = TextEditingController();
  final TextEditingController _companyPasswordController =
      TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();

  int _selectedTabIndex = 0;
  final List<String> _tabTitles = ['Customer', 'Provider'];

  final _formKey = GlobalKey<FormState>();

  String? _nameError;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _companyEmailController.dispose();
    _companyPasswordController.dispose();
    _companyNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Sign Up',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          centerTitle: true,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 60.0, 15.0, 0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                              radius: 70,
                              backgroundImage:
                                  AssetImage('lib/assets/profile_image.jpg')),
                          const SizedBox(height: 40),
                          DefaultTabController(
                            length: _tabTitles.length,
                            initialIndex: _selectedTabIndex,
                            child: Column(
                              children: [
                                TabBar(
                                  onTap: (index) {
                                    setState(() {
                                      _selectedTabIndex = index;
                                    });
                                  },
                                  tabs: _tabTitles
                                      .map((title) => Tab(text: title))
                                      .toList(),
                                  indicatorColor: Colors.blue,
                                  labelColor: Colors.blue,
                                  unselectedLabelColor: Colors.black,
                                ),
                                const SizedBox(height: 30.0),
                                SizedBox(
                                  height: 250, // Adjust this value as needed
                                  child: TabBarView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children: [
                                      buildCustomerFields(),
                                      buildProviderFields(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // const SizedBox(height: 10.0),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomButton(
                              label: 'Sign Up',
                              icon: Icons.check,
                              onPressed: () => _handleSignUp(context),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Already have an account?'),
                              TextButton(
                                onPressed: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage())),
                                child: const Text('Login'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildCustomerFields() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextField(
              controller: _nameController,
              label: "Full Name",
              hintText: "Enter your full name",
              errorText: _nameError,
              isPassword: false,
              prefixIcon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Full name is required';
                }
                return null;
              },
              onChanged: (value) => validateName(value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextField(
              controller: _emailController,
              isPassword: false,
              label: "Email",
              hintText: "Enter your email",
              errorText: _emailError,
              prefixIcon: Icons.email,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'Enter a valid email address';
                }
                return null;
              },
              onChanged: (value) => validateEmail(value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextField(
              controller: _passwordController,
              label: "Password",
              isPassword: true,
              hintText: "Enter your password",
              errorText: _passwordError,
              prefixIcon: Icons.lock,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters long';
                }
                return null;
              },
              onChanged: (value) => validatePassword(value),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProviderFields() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextField(
              controller: _companyEmailController,
              label: "Provider Email",
              isPassword: false,
              prefixIcon: Icons.email,
              hintText: "Enter Provider Email",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Provider Email is required';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'Enter a valid email address';
                }
                return null;
              },
              errorText: _emailError,
              onChanged: (value) => validateEmail(value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextField(
              controller: _companyPasswordController,
              label: "Provider Password",
              hintText: "Enter Provider password",
              isPassword: true,
              errorText: _passwordError,
              prefixIcon: Icons.lock,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Provider Password is required';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters long';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextField(
              isPassword: false,
              controller: _companyNameController,
              label: "Provider Name",
              hintText: "Enter Provider name",
              errorText: _nameError,
              prefixIcon: Icons.business,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Provider Name is required';
                }
                return null;
              },
              onChanged: (value) => validateName(value),
            ),
          ),
        ],
      ),
    );
  }

  void validateName(String value) {
    setState(() {
      _nameError = value.isEmpty ? 'Name is required' : null;
    });
  }

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
      } else if (value.length < 6) {
        _passwordError = 'Password must be at least 6 characters long';
      } else {
        _passwordError = null;
      }
    });
  }

  void _handleSignUp(BuildContext context) async {
    final String email;
    final String password;
    final String name;
    final userType = _selectedTabIndex == 0 ? 'customer' : 'provider';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
          child: CircularProgressIndicator(
              color: Colors.blueAccent, strokeWidth: 2)),
    );

    if (_selectedTabIndex == 0) {
      email = _emailController.text;
      password = _passwordController.text;
      name = _nameController.text;
    } else {
      email = _companyEmailController.text;
      password = _companyPasswordController.text;
      name = _companyNameController.text;
    }

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      Navigator.pop(context); // Dismiss the dialog
      showCustomToast(context, 'Please fill in all fields');
      return;
    }

    try {
      UserCredential? userCredential =
          await _auth.signUpWithEmailAndPassword(email, password);
      User? user = userCredential?.user;
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference userCollection;

      if (user != null) {
        // Store user details in Firestore
        if (userType == 'customer') {
          userCollection = firestore.collection('Customers');
        } else {
          userCollection = firestore.collection('Providers');
        }

        await userCollection.doc(user.uid).set({
          'email': email,
          'name': name,
          'userType': userType,
          'phone': '',
          'location': '',
          'createdAt': Timestamp.now(), // Timestamp for record creation
        });

        Navigator.pop(context); // Dismiss the dialog

        if (userType == 'customer') {
          // Navigate to HomePage for Customers
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileEdit(
                    name: name,
                    userType: userType,
                    uid: user.uid,
                    phone: '',
                    location: '')),
          );
        } else {
          // Navigate to ShopRegistrationForm for Providers
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ShopRegistrationForm(
                      email: email,
                      name: name,
                    )),
          );
        }
      }
    } catch (error) {
      Navigator.pop(context); // Dismiss the dialog
      if (error is FirebaseAuthException &&
          error.code == 'email-already-in-use') {
        showCustomToast(context, 'The email address is already in use.');
      } else {
        showCustomToast(context, '${error.toString()}');
      }
    }
  }

  void showCustomToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 50,
        width: MediaQuery.of(context).size.width,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            margin: EdgeInsets.symmetric(horizontal: 24.0),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
    overlay.insert(overlayEntry);
    Future.delayed(Duration(seconds: 5), () {
      overlayEntry.remove();
    });
  }
}
