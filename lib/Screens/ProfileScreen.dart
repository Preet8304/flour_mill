import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'ProfileEdit.dart'; // Import the ProfileEdit screen

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image; // Variable to hold the selected image
  String _name = "Shizuka"; // Default name
  String _phone = "+91 8888888888"; // Default phone number
  String _location = "Tokyo, Nerima Ward"; // Default location

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Update the image variable
      });
    }
  }

  void _editProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileEdit(
          name: _name,
          phone: _phone,
          location: _location,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _name = result['name'];
        _phone = result['phone'];
        _location = result['location'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editProfile, // Navigate to ProfileEdit
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
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: _image != null
                        ? FileImage(_image!) // Use the selected image
                        : NetworkImage(
                            'https://d2qp0siotla746.cloudfront.net/img/use-cases/profile-picture/template_3.jpg'), // Default image
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi, $_name", // Display the name
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Let's explore together",
                          style: const TextStyle(
                            color: Colors.blueGrey,
                          ),
                        ),
                        Text(
                          "Joined in 2021",
                          style: const TextStyle(
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            InfoTile(
              icon: Icons.person_outline,
              title: _name,
              subtitle: 'Full Name',
            ),
            InfoTile(
              icon: Icons.phone,
              title: _phone,
              subtitle: 'Mobile Number',
            ),
            InfoTile(
              icon: Icons.location_on,
              title: _location,
              subtitle: 'Location',
            ),
          ],
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const InfoTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 40,
            color: Colors.blueGrey,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
