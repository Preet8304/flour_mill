// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flour_mill/pages/honmepage.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// /*
// import 'package:flour_mill/shared_preferences.dart';
// */
// import 'package:flour_mill/UIComponents/CustomTextField.dart';
// import 'package:flour_mill/UIComponents/CustomButton.dart';
// import 'package:flour_mill/pages/PhoneVerification.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);
//
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   bool isChecked = false;
//
//   @override
//   void initState() {
//     super.initState();
//     checkLoginStatus();
//   }
//
//   Future<void> checkLoginStatus() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
//     if (isLoggedIn) {
//       // User is already logged in, navigate to the home page
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const MyHomePage()),
//       );
//     }
//   }
//
//   Future<void> loginUser() async {
//     final String  email = emailController.text.trim();
//     final String password = passwordController.text;
//
//     final url = Uri.parse('http://192.168.120.253:3000/login');
//     final response = await http.post(
//       url,
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'email': email,
//         'password': password,
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       // Successful login
//       print('Login successful');
//       final SharedPreferences prefs = await SharedPreferences.getInstance();
//       prefs.setBool('isLoggedIn', true); // Save login state
//       // Navigate to the home page
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const MyHomePage()),
//       );
//     } else {
//       // Login failed
//       print('Login failed: ${response.body}');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Login failed')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login Page'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(18.0, 70.0, 18.0, 0.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: <Widget>[
//               const Text(
//                 'Login',
//                 style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 50),
//               CustomTextField(
//                 label: "Email",
//                 hintText: "Enter Email ID",
//                 controller: emailController,
//                 prefixIcon: Icons.email,
//               ),
//               const SizedBox(height: 20),
//               CustomTextField(
//                 label: "Password",
//                 hintText: "Enter Password",
//                 controller: passwordController,
//                 prefixIcon: Icons.lock,
//                 isPassword: true,
//               ),
//               const SizedBox(height: 15),
//               Row(
//                 children: [
//                   Checkbox(
//                     checkColor: Colors.white,
//                     value: isChecked,
//                     onChanged: (bool? value) {
//                       setState(() {
//                         isChecked = value ?? false;
//                       });
//                     },
//                   ),
//                   const Text("Remember Me"),
//                   Expanded(
//                       child:
//                       Container()),
//                   // Added Expanded to push Forget Password to the end
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>  PhoneVerification(),
//                         ),
//                       );
//                     },
//                     child: const Text(
//                       "Forget Password",
//                       style: TextStyle(color: Colors.blue),
//                     ),
//                   ),
//                 ],
//               ),
//               CustomButton(
//                 onPressed: loginUser,
//                 label: 'Login',
//                 icon: Icons.login,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flour_mill/Screens/HomePage.dart';
import 'package:flour_mill/UIComponents/CustomTextField.dart';
import 'package:flour_mill/UIComponents/CustomButton.dart';
import 'package:flour_mill/pages/PhoneVerification.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isChecked = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  HomePage()),
      );
    }
  }

  Future<void> loginUser() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        // Save login state in shared preferences
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  HomePage()),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Login failed: ${e.toString()}';
      });
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
          padding: const EdgeInsets.fromLTRB(18.0, 70.0, 18.0, 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Login',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 50),
              CustomTextField(
                label: "Email",
                hintText: "Enter Email ID",
                controller: emailController,
                prefixIcon: Icons.email,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: "Password",
                hintText: "Enter Password",
                controller: passwordController,
                prefixIcon: Icons.lock,
                isPassword: true,
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value ?? false;
                      });
                    },
                  ),
                  const Text("Remember Me"),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhoneVerification(),
                        ),
                      );
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              CustomButton(
                onPressed: loginUser,
                label: 'Login',
                icon: Icons.login,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
