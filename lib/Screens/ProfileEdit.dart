import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import the image picker
import 'dart:io'; // Import for File

class ProfileEdit extends StatefulWidget {
  final String name;
  final String phone;
  final String location;

  const ProfileEdit({
    Key? key,
    required this.name,
    required this.phone,
    required this.location,
  }) : super(key: key);

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  File? _image; // Variable to hold the selected image

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _phoneController = TextEditingController(text: widget.phone);
    _locationController = TextEditingController(text: widget.location);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery); // Updated method

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Update the image variable
      });
    }
  }

  void _saveProfile() {
    // Here you can save the updated profile information
    Navigator.pop(context, {
      'name': _nameController.text,
      'phone': _phoneController.text,
      'location': _locationController.text,
      'image': _image?.path, // Pass the image path if available
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.deepPurple, // Change app bar color
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _pickImage, // Allow tapping to pick an image
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _image != null
                    ? FileImage(_image!) // Use the selected image
                    : const NetworkImage(
                        'https://d2qp0siotla746.cloudfront.net/img/use-cases/profile-picture/template_3.jpg'), // Default image
                child: _image == null
                    ? const Icon(Icons.camera_alt,
                        size: 30, color: Colors.white) // Icon for default image
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors
                    .grey[200]!, // Use null assertion to resolve the error
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Mobile Number',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors
                    .grey[200]!, // Use null assertion to resolve the error
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors
                    .grey[200]!, // Use null assertion to resolve the error
              ),
            ),
          ],
        ),
      ),
    );
  }
}
