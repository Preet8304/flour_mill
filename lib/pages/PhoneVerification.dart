import 'package:flour_mill/UIComponents/CustomButton.dart';
import 'package:flour_mill/pages/OTPVerification.dart';
import 'package:flutter/material.dart';
import 'package:flour_mill/UIComponents/CustomTextField.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(PhoneVerification());
}

class PhoneVerification extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();

  PhoneVerification({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Phone Verification'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 80, 30.0, 5.0),
            child: Column(
              children: [
                Lottie.asset(
                  'animations/sendotpmess.json',
                  width: 200,
                  height: 200,
                  repeat: true,
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Enter the Mobile Number',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                const Text(
                  'We will send you a verification code',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  label: "Phone Number",
                  hintText: "Enter Phone Number",
                  controller: phoneController,
                  prefixIcon: Icons.phone,
                  obscureText: false,
                  isPassword: false, validator: (String? value) {  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                    label: "Send OTP",
                    icon: Icons.send,
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OTPVerification()));
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
