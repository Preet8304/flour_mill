import 'package:flour_mill/Screens/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileEdit extends StatefulWidget {
  final String name;
  final String phone;
  final String location;
  final String userType;
  final String uid;

  const ProfileEdit({
    Key? key,
    required this.name,
    required this.phone,
    required this.location,
    required this.userType,
    required this.uid,
  }) : super(key: key);

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  File? _image; // Variable to hold the image
  String? _profilePicUrl; // Variable to hold the uploaded image URL
  String _name = '';
  String _phone = '';
  String _location = '';
  bool _isUploading = false;
  bool _isProvider = false; // To check if the user is a provider

  @override
  void initState() {
    super.initState();
    _getUserData(); // Fetch user data on init
  }

  // Fetch user data from Firestore
  Future<void> _getUserData() async {
    try {
      DocumentSnapshot customerDoc =
          await _firestore.collection('Customers').doc(widget.uid).get();
      if (customerDoc.exists) {
        setState(() {
          _isProvider = false; // User is a customer
          _name = customerDoc['name'];
          _phone = customerDoc['phone'];
          _location = customerDoc['location'];
          _profilePicUrl = customerDoc['profilePic'];
        });
      } else {
        DocumentSnapshot providerDoc =
            await _firestore.collection('Providers').doc(widget.uid).get();
        if (providerDoc.exists) {
          setState(() {
            _isProvider = true; // User is a provider
            _name = providerDoc['name'];
            _phone = providerDoc['phone'];
            _location = providerDoc['location'];
            _profilePicUrl = providerDoc['profilePic'];
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  // Image picking from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Store the picked image
      });
    }
  }

  // Save profile changes and upload image to Firebase
  Future<void> _saveProfile() async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      String uid = currentUser.uid;

      setState(() {
        _isUploading = true; // Show loading indicator while uploading
      });

      try {
        // If there's an image, upload it to Firebase Storage
        if (_image != null) {
          String fileName = '$uid/profile_pic.jpg'; // Create a unique file name
          Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
          UploadTask uploadTask = storageRef.putFile(_image!);

          TaskSnapshot snapshot = await uploadTask;
          _profilePicUrl =
              await snapshot.ref.getDownloadURL(); // Get the download URL
        }

        // Update Firestore with the new profile details
        if (_isProvider) {
          // If user is a Provider
          await _firestore.collection('Providers').doc(uid).update({
            'name': _name,
            'phone': _phone,
            'location': _location,
            'profilePic':
                _profilePicUrl ?? '', // Store the image URL in Firestore
          });
        } else {
          // If user is a Customer
          await _firestore.collection('Customers').doc(uid).update({
            'name': _name,
            'phone': _phone,
            'location': _location,
            'profilePic': _profilePicUrl ?? '',
          });
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomePage(), // Replace with your actual home page widget
          ),
        );

        // Close the screen and pass the updated profile data back
        // Navigator.pop(context, {
        //   'name': _name,
        //   'phone': _phone,
        //   'location': _location,
        // });
      } catch (e) {
        print('Error uploading profile: $e');
        // You can show an error message to the user here
      } finally {
        setState(() {
          _isUploading = false; // Stop loading indicator
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            // GestureDetector(
            //   onTap: _pickImage, // Tap to pick an image
            //   child: CircleAvatar(
            //     radius: 60,
            //     backgroundImage: _image != null
            //         ? FileImage(_image!)
            //         : _profilePicUrl != null
            //             ? NetworkImage(
            //                 _profilePicUrl!) // Show network image if available
            //             : const AssetImage('lib/assets/profile_image.jpg')
            //                 as ImageProvider,
            //   ),
            // ),
            Stack( // Use Stack for image and edit icon
              alignment: Alignment.bottomRight,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : _profilePicUrl != null
                            ? NetworkImage(_profilePicUrl!)
                            : const AssetImage('lib/assets/profile_image.jpg')
                                as ImageProvider,
                  ),
                ),
                IconButton( // Edit icon button
                  onPressed: _pickImage,
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.zero, // Remove default padding
                  splashRadius: 20, // Adjust splash area for better UX
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'Full Name'),
              onChanged: (value) {
                _name = value;
              },
              controller: TextEditingController(text: _name),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Mobile Number'),
              keyboardType: TextInputType.phone, // Set keyboard type to phone
              inputFormatters: [
                 LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.allow(RegExp(r'^\d{0,10}$')), // Allow only digits and limit to 10 characters
              ],
              onChanged: (value) {
                _phone = value;
              },
              controller: TextEditingController(text: _phone),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Location'),
              onChanged: (value) {
                _location = value;
              },
              controller: TextEditingController(text: _location),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isUploading
                  ? null
                  : _saveProfile, // Disable the button if uploading
              child: _isUploading
                  ? const CircularProgressIndicator() // Show progress if uploading
                  : const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
