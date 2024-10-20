import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileEdit extends StatefulWidget {
  final String name;
  final String phone;
  final String location;

  const ProfileEdit({Key? key, required this.name, required this.phone, required this.location}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    _name = widget.name;
    _phone = widget.phone;
    _location = widget.location;
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
          _profilePicUrl = await snapshot.ref.getDownloadURL(); // Get the download URL

          print('Profile pic uploaded. URL: $_profilePicUrl');
        }

        // Update Firestore with the new profile details
        await _firestore.collection('Customers').doc(uid).update({
          'name': _name,
          'phone': _phone,
          'location': _location,
          'profilePic': _profilePicUrl ?? '', // Store the image URL in Firestore
        });

        // If the user is a Provider, adjust the collection accordingly
        await _firestore.collection('Providers').doc(uid).update({
          'name': _name,
          'phone': _phone,
          'location': _location,
          'profilePic': _profilePicUrl ?? '',
        });

        // Close the screen and pass the updated profile data back
        Navigator.pop(context, {
          'name': _name,
          'phone': _phone,
          'location': _location,
        });
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
            GestureDetector(
              onTap: _pickImage, // Tap to pick an image
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : const AssetImage('assets/default_profile.png') as ImageProvider,
              ),
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
              onPressed: _isUploading ? null : _saveProfile, // Disable the button if uploading
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
