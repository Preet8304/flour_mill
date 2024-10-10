// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage for profile pictures
// import 'ProfileEdit.dart'; // Import the ProfileEdit screen
//
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   User? _currentUser;
//   File? _image;
//   String _name = "User";
//   String _phone = "Not set";
//   String _location = "Enter your address"; // Default location
//   String _userType = ''; // Determine if the user is Customer or Provider
//   String _profilePicUrl = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _getProfileData(); // Fetch profile details when the screen loads
//   }
//
//   Future<void> _getProfileData() async {
//     _currentUser = _auth.currentUser;
//
//     if (_currentUser != null) {
//       // Check if the user is a Customer or Provider
//       DocumentSnapshot userDoc = await _firestore.collection('Customers').doc(_currentUser!.uid).get();
//
//       if (userDoc.exists) {
//         setState(() {
//           _userType = 'Customer';
//         });
//       } else {
//         userDoc = await _firestore.collection('Providers').doc(_currentUser!.uid).get();
//         if (userDoc.exists) {
//           setState(() {
//             _userType = 'Provider';
//           });
//         }
//       }
//
//       // Now fetch the common user details based on user type
//       if (userDoc.exists) {
//         setState(() {
//           _name = userDoc.get('name') ?? 'Unknown';
//           _phone = userDoc.get('phone') ?? 'Not set'; // Initialize with 'Not set'
//           _location = userDoc.get('location') ?? 'Enter your address'; // Initialize with default
//           _profilePicUrl = userDoc.get('profilePic') ?? '';
//         });
//       }
//     }
//   }
//
//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);
//
//     if (pickedFile != null && _currentUser != null) {
//       File imageFile = File(pickedFile.path);
//       String fileName = '${_currentUser!.uid}/profile_pic.jpg'; // Create a unique file name
//
//       // Upload to Firebase Storage
//       Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
//       UploadTask uploadTask = storageRef.putFile(imageFile);
//
//       TaskSnapshot snapshot = await uploadTask;
//       String downloadUrl = await snapshot.ref.getDownloadURL(); // Get the download URL
//
//       // Update Firestore with the new profile picture URL
//       await _firestore.collection(_userType == 'Customer' ? 'Customers' : 'Providers').doc(_currentUser!.uid).update({
//         'profilePic': downloadUrl,
//       });
//
//       // Update the local state with the new profile picture URL
//       setState(() {
//         _profilePicUrl = downloadUrl;
//       });
//     }
//   }
//
//   void _editProfile() async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ProfileEdit(
//           name: _name,
//           phone: _phone,
//           location: _location, userType: '',
//         ),
//       ),
//     );
//
//     if (result != null && _currentUser != null) {
//       setState(() {
//         _name = result['name'];
//         _phone = result['phone'];
//         _location = result['location'];
//       });
//
//       // Update Firestore with the new details
//       await _firestore.collection(_userType == 'Customer' ? 'Customers' : 'Providers').doc(_currentUser!.uid).update({
//         'name': _name,
//         'phone': _phone,
//         'location': _location,
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: _editProfile, // Navigate to ProfileEdit
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             GestureDetector(
//               onTap: _pickImage, // Allow tapping to pick an image
//               child: Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 40,
//                     backgroundImage: _image != null
//                         ? FileImage(_image!) // Use the selected image
//                         : (_profilePicUrl.isNotEmpty
//                         ? NetworkImage(_profilePicUrl) // Use the profile picture from Firebase
//                         : const AssetImage('assets/default_profile.png')) as ImageProvider,
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Hi, $_name", // Display the name
//                           style: const TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const Text(
//                           "Let's explore together",
//                           style:  TextStyle(
//                             color: Colors.blueGrey,
//                           ),
//                         ),
//                         Text(
//                           _userType == 'Customer'
//                               ? "Customer since 2021"
//                               : "Provider since 2021",
//                           // Display based on user type
//                           style: const TextStyle(
//                             color: Colors.blueGrey,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             InfoTile(
//               icon: Icons.person_outline,
//               title: _name,
//               subtitle: 'Full Name',
//             ),
//             InfoTile(
//               icon: Icons.phone,
//               title: _phone,
//               subtitle: 'Mobile Number',
//             ),
//             InfoTile(
//               icon: Icons.location_on,
//               title: _location,
//               subtitle: 'Location',
//             ),
//             if (_userType == 'Provider') // Show extra info if user is a Provider
//               InfoTile(
//                 icon: Icons.work_outline,
//                 title: "Provider Info",
//                 subtitle: "Services provided in $_location",
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class InfoTile extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String subtitle;
//
//   const InfoTile({
//     super.key,
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Icon(
//             icon,
//             size: 40,
//             color: Colors.blueGrey,
//           ),
//           const SizedBox(width: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 18,
//                 ),
//               ),
//               Text(
//                 subtitle,
//                 style: const TextStyle(
//                   color: Colors.blueGrey,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ProfileEdit.dart'; // Import ProfileEdit
import 'info_tile.dart'; // Import InfoTile

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _currentUser;
  String _name = "User";
  String _phone = "Not set";
  String _location = "Enter your address"; // Default location
  String _userType = ''; // Determine if the user is Customer or Provider
  String _profilePicUrl = ''; // Store the profile picture URL

  @override
  void initState() {
    super.initState();
    _getProfileData(); // Fetch profile details when the screen loads
  }

  Future<void> _getProfileData() async {
    _currentUser = _auth.currentUser;

    if (_currentUser != null) {
      // Check if the user is a Customer or Provider
      DocumentSnapshot userDoc = await _firestore.collection('Customers').doc(_currentUser!.uid).get();

      if (userDoc.exists) {
        setState(() {
          _userType = 'Customer';
        });
      } else {
        userDoc = await _firestore.collection('Providers').doc(_currentUser!.uid).get();
        if (userDoc.exists) {
          setState(() {
            _userType = 'Provider';
          });
        }
      }

      // Now fetch the common user details based on user type
      if (userDoc.exists) {
        setState(() {
          _name = userDoc.get('name') ?? 'Unknown';
          _phone = userDoc.get('phone') ?? 'Not set'; // Initialize with 'Not set'
          _location = userDoc.get('location') ?? 'Enter your address'; // Initialize with default
          _profilePicUrl = userDoc.get('profilePic') ?? ''; // Fetch the profile pic URL
        });
      }
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

    if (result != null && _currentUser != null) {
      setState(() {
        _name = result['name'];
        _phone = result['phone'];
        _location = result['location'];
      });

      // Update Firestore with the new details
      await _firestore.collection(_userType == 'Customer' ? 'Customers' : 'Providers').doc(_currentUser!.uid).update({
        'name': _name,
        'phone': _phone,
        'location': _location,
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
              onTap: () {}, // Allow tapping to pick an image
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: _profilePicUrl.isNotEmpty
                        ? NetworkImage(_profilePicUrl) // Use the profile picture from Firebase
                        : const AssetImage('assets/default_profile.png') as ImageProvider,
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
                        const Text(
                          "Let's explore together",
                          style: TextStyle(
                            color: Colors.blueGrey,
                          ),
                        ),
                        Text(
                          _userType == 'Customer'
                              ? "Customer since 2021"
                              : "Provider since 2021",
                          // Display based on user type
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
            if (_userType == 'Provider') // Show extra info if user is a Provider
              InfoTile(
                icon: Icons.work_outline,
                title: "Provider Info",
                subtitle: "Services provided in $_location",
              ),
          ],
        ),
      ),
    );
  }
}
