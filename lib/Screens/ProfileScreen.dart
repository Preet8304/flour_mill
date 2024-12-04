// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'ProfileEdit.dart'; // Import ProfileEdit
// import 'info_tile.dart'; // Import InfoTile

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   User? _currentUser;
//   String _name = "User";
//   String _phone = "Not set";
//   String _location = "Enter your address"; // Default location
//   String _userType = ''; // Determine if the user is Customer or Provider
//   String _profilePicUrl = ''; // Store the profile picture URL

//   @override
//   void initState() {
//     super.initState();
//     _getProfileData(); // Fetch profile details when the screen loads
//   }

//   Future<void> _getProfileData() async {
//     _currentUser = _auth.currentUser;

//     if (_currentUser != null) {
//       // Check if the user is a Customer or Provider
//       DocumentSnapshot userDoc =
//           await _firestore.collection('Customers').doc(_currentUser!.uid).get();

//       if (userDoc.exists) {
//         setState(() {
//           _userType = 'Customer';
//         });
//       } else {
//         userDoc = await _firestore
//             .collection('Providers')
//             .doc(_currentUser!.uid)
//             .get();
//         if (userDoc.exists) {
//           setState(() {
//             _userType = 'Provider';
//           });
//         }
//       }

//       // Now fetch the common user details based on user type
//       if (userDoc.exists) {
//         setState(() {
//           _name = userDoc.get('name') ?? 'Unknown';
//           _phone =
//               userDoc.get('phone') ?? 'Not set'; // Initialize with 'Not set'
//           _location = userDoc.get('location') ??
//               'Enter your address'; // Initialize with default
//           _profilePicUrl =
//               userDoc.get('profilePic') ?? ''; // Fetch the profile pic URL
//         });
//       }
//     }
//   }

//   void _editProfile() async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ProfileEdit(
//           name: _name,
//           phone: _phone,
//           location: _location,
//           userType: _userType,
//           uid: _currentUser!.uid, // Add this line
//         ),
//       ),
//     );

//     if (result != null) {
//       await _getProfileData(); // Refresh the profile data
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false, // This line removes the back button
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
//               onTap: () {}, // Allow tapping to pick an image
//               child: Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 40,
//                     child:_buildProfileImage(),
//                     // backgroundImage: _profilePicUrl.isNotEmpty
//                     //     ? NetworkImage(
//                     //         _profilePicUrl) // Use the profile picture from Firebase
//                     //     : const AssetImage('lib/assets/profile_image.jpg')
//                     //         as ImageProvider,
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
//                           style: TextStyle(
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
//             if (_userType ==
//                 'Provider') // Show extra info if user is a Provider
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

// Widget _buildProfileImage() {
//     return AnimatedSwitcher(
//       duration: const Duration(milliseconds: 300),
//       child: _profilePicUrl != null
//           ? CachedNetworkImage(
//               key: ValueKey(_profilePicUrl),
//               imageUrl: _profilePicUrl!,
//               imageBuilder: (context, imageProvider) => Container(
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   image: DecorationImage(
//                     image: imageProvider,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               placeholder: (context, url) => const CircularProgressIndicator(),
//               errorWidget: (context, url, error) => const Icon(Icons.error),
//             )
//           : Image.asset('lib/assets/profile_image.jpg', fit: BoxFit.cover),
//     );
//   }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'ProfileEdit.dart';
import 'info_tile.dart';

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
  String _location = "Enter your address";
  String _userType = '';
  String? _profilePicUrl;

  @override
  void initState() {
    super.initState();
    _getProfileData();
  }

  Future<void> _getProfileData() async {
    _currentUser = _auth.currentUser;

    if (_currentUser != null) {
      DocumentSnapshot userDoc = await _firestore.collection('Customers').doc(_currentUser!.uid).get();

      if (userDoc.exists) {
        setState(() {
          _userType = 'Customer';
          _name = userDoc.get('name') ?? 'Unknown';
          _phone = userDoc.get('phone') ?? 'Not set';
          _location = userDoc.get('location') ?? 'Enter your address';
          _profilePicUrl = userDoc.get('profilePic');
        });
      } else {
        // Check Providers collection if not found in Customers
        userDoc = await _firestore.collection('Providers').doc(_currentUser!.uid).get();
        if (userDoc.exists) {
          setState(() {
            _userType = 'Provider';
            _name = userDoc.get('name') ?? 'Unknown';
            _phone = userDoc.get('phone') ?? 'Not set';
            _location = userDoc.get('location') ?? 'Enter your address';
            _profilePicUrl = userDoc.get('profilePic');
          });
        }
      }

      // Preload the image if URL is available
      // if (_profilePicUrl != null) {
      //   await precacheImage(CachedNetworkImageProvider(_profilePicUrl!), context);
      // }
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
          userType: _userType,
          uid: _currentUser!.uid,
        ),
      ),
    );

    if (result != null) {
      await _getProfileData(); // Refresh the profile data
    }
  }

  Widget _buildProfileImage() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _profilePicUrl != null
          ? CachedNetworkImage(
              key: ValueKey(_profilePicUrl),
              imageUrl: _profilePicUrl!,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            )
          : Image.asset('lib/assets/profile_image.jpg', fit: BoxFit.cover),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editProfile,
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
                    child: _buildProfileImage(),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi, $_name",
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
            if (_userType == 'Provider')
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