import 'package:flour_mill/Screens/HomePage.dart';
import 'package:flour_mill/firebase%20auth%20service/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart'; // Use this to store user details
import 'package:flour_mill/UIComponents/CustomButton.dart';
import 'package:flour_mill/UIComponents/CustomTextField.dart';
import 'package:flour_mill/UIComponents/CustomToast.dart';
import 'package:flour_mill/pages/LoginPage.dart';

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
        body: SingleChildScrollView(
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
    );
  }

  Widget buildCustomerFields() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomTextField(
            label: 'Email',
            hintText: 'Enter your email',
            controller: _emailController,
            prefixIcon: Icons.mail,
            validator: _validateEmail,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomTextField(
            label: 'Password',
            hintText: 'Enter a strong password',
            controller: _passwordController,
            prefixIcon: Icons.lock,
            isPassword: true,
            validator: _validatePassword,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomTextField(
            label: 'Name',
            hintText: 'Enter your name',
            controller: _nameController,
            prefixIcon: Icons.person,
            validator: _validateName,
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
            label: 'Provider Email',
            hintText: 'Enter Provider Email',
            controller: _companyEmailController,
            prefixIcon: Icons.mail,
            validator: _validateEmail,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomTextField(
            label: 'Provider Password',
            hintText: 'Enter Provider password',
            controller: _companyPasswordController,
            prefixIcon: Icons.lock,
            isPassword: true,
            validator: _validatePassword,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomTextField(
            label: 'Provider Name',
            hintText: 'Enter Provider name',
            controller: _companyNameController,
            prefixIcon: Icons.business,
            validator: _validateName,
          ),
        ),
      ],
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }
    return null;
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

      if (user != null) {
        // Store user details in Firebase Realtime Database
        await _dbRef.child(user.uid).set({
          'email': email,
          'name': name,
          'userType': userType,
        });
        Navigator.pop(context); // Dismiss the dialog
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
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
