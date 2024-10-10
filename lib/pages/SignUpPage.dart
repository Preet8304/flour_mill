import 'package:flour_mill/Screens/HomePage.dart';
import 'package:flour_mill/firebase%20auth%20service/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart'; // Use this to store user details
import 'package:flour_mill/UIComponents/CustomButton.dart';
import 'package:flour_mill/UIComponents/CustomTextField.dart';
import 'package:flour_mill/UIComponents/CustomToast.dart';
import 'package:flour_mill/pages/LoginPage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child("users");

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _companyEmailController = TextEditingController();
  final TextEditingController _companyPasswordController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();

  int _selectedTabIndex = 0;
  final List<String> _tabTitles = ['Customer', 'Provider'];

  final _formKey = GlobalKey<FormState>();

  String? _nameError;
  String? _emailError;
  String? _phoneError;
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
          title: const Text('Sign Up',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 60.0, 15.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                      radius: 70,
                      backgroundImage: AssetImage('lib/assets/profile_image.jpg')),
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
                          height: 240.0,
                          child: TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              buildCustomerFields(),
                              buildProviderFields(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0),
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
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage())),
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
  }

  Widget buildCustomerFields() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomTextField(
            controller: _nameController,
            label: "Full Name",
            hintText: "Enter your full name",
            errorText: _nameError,
            prefixIcon: Icons.person,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Full name is required';
              }
              return null;
            },
            obscureText: false,
            onChanged: (value) => validateName(value),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomTextField(
            controller: _emailController,
            label: "Email",
            hintText: "Enter your email",
            errorText: _emailError,
            prefixIcon: Icons.email,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Enter a valid email address';
              }
              return null;
            },
            obscureText: false,
            onChanged: (value) => validateEmail(value),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomTextField(
            controller: _passwordController,
            label: "Password",
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
            obscureText: true,
          ),
        ),
      ],
    );
  }

  Widget buildProviderFields() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomTextField(
            controller: _companyEmailController,
            label: "Provider Email",
            prefixIcon: Icons.email,
            hintText: "Enter Provider Email",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Provider Email is required';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Enter a valid email address';
              }
              return null;
            },
            errorText: _emailError,
            onChanged: (value) => validateEmail(value),
            obscureText: false, // Add this line
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomTextField(
            controller: _companyPasswordController,
            label: "Provider Password",
            hintText: "Enter Provider password",
            errorText: _passwordError,
            obscureText: true,
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
            controller: _companyNameController,
            label: "Provider Name",
            hintText: "Enter Provider name",
            errorText: _nameError,
            obscureText: false,
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

  void validatePhone(String value) {
    setState(() {
      if (value.isEmpty) {
        _phoneError = 'Phone number is required';
      } else if (!RegExp(r'^\+?[0-9]{10,14}$').hasMatch(value)) {
        _phoneError = 'Enter a valid phone number';
      } else {
        _phoneError = null;
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
      User? user = await _auth.signUpWithEmailAndPassword(email, password);
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference userCollection;

      if (user != null) {
        // Store user details in Firebase Realtime Database
        if (userType == 'customer') {
          userCollection = firestore.collection('Customers');
        } else {
          userCollection = firestore.collection('Providers');
        }

        // Store user details in the respective Firestore collection
        await userCollection.doc(user.uid).set({
          'email': email,
          'name': name,
          'userType': userType,
          'createdAt': Timestamp.now(), // Add timestamp for record creation
        });

        Navigator.pop(context); // Dismiss the dialog
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (error) {
      Navigator.pop(context); // Dismiss the dialog
      showCustomToast(context, 'Error: $error');
    }
  }

  void showCustomToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CustomToast(message: message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
