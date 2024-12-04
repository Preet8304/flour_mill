// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';

// class UserDetailsPage extends StatelessWidget {
//   final String userId;

//   const UserDetailsPage({Key? key, required this.userId}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Details'),
//       ),
//       body: StreamBuilder<DocumentSnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('Customers')
//             .doc(userId)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || !snapshot.data!.exists) {
//             return const Center(child: Text('User not found'));
//           }

//           final userData = snapshot.data!.data() as Map<String, dynamic>;
//           String formattedDate = 'N/A';
//           if (userData['createdAt'] != null) {
//             Timestamp createdAt = userData['createdAt'] as Timestamp;
//             formattedDate =
//                 DateFormat('yyyy-MM-dd HH:mm').format(createdAt.toDate());
//           }

//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: CircleAvatar(
//                     radius: 50,
//                     backgroundImage: userData['profilePic'] != null &&
//                             userData['profilePic'].isNotEmpty
//                         ? NetworkImage(userData['profilePic'])
//                         : const AssetImage('assets/default_profile.jpg')
//                             as ImageProvider,
//                     onBackgroundImageError: (exception, stackTrace) {
//                       // This will be called if the image fails to load
//                       print('Error loading profile image: $exception');
//                     },
//                     child: userData['profilePic'] == null ||
//                             userData['profilePic'].isEmpty
//                         ? Text(userData['name']?[0].toUpperCase() ?? '?',
//                             style: const TextStyle(
//                                 fontSize: 30, fontWeight: FontWeight.bold))
//                         : null,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 _buildInfoRow('Name', userData['name'] ?? 'N/A'),
//                 _buildInfoRow('Email', userData['email'] ?? 'N/A'),
//                 _buildInfoRow('Phone', userData['phone'] ?? 'N/A'),
//                 _buildInfoRow('Address', userData['location'] ?? 'N/A'),
//                 _buildInfoRow('Created At', formattedDate),

//                 // Add more fields as needed
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 100,
//             child: Text(
//               '$label:',
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(
//             child: Text(value),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserDetailsPage extends StatelessWidget {
  final String userId;

  const UserDetailsPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmation(context),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Customers')
            .doc(userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User not found'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          String formattedDate = 'N/A';
          if (userData['createdAt'] != null) {
            Timestamp createdAt = userData['createdAt'] as Timestamp;
            formattedDate =
                DateFormat('yyyy-MM-dd HH:mm').format(createdAt.toDate());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    child: _buildProfileImage(userData),
                  ),
                ),
                const SizedBox(height: 20),
                _buildInfoRow('Name', userData['name'] ?? 'N/A'),
                _buildInfoRow('Email', userData['email'] ?? 'N/A'),
                _buildInfoRow('Phone', userData['phone'] ?? 'N/A'),
                _buildInfoRow('Address', userData['location'] ?? 'N/A'),
                _buildInfoRow('Created At', formattedDate),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileImage(Map<String, dynamic> userData) {
    if (userData['profilePic'] != null && userData['profilePic'].isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: userData['profilePic'],
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => _buildFallbackAvatar(userData),
          fit: BoxFit.cover,
          width: 100,
          height: 100,
        ),
      );
    } else {
      return _buildFallbackAvatar(userData);
    }
  }

  Widget _buildFallbackAvatar(Map<String, dynamic> userData) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          userData['name']?[0].toUpperCase() ?? '?',
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete User"),
          content: const Text("Are you sure you want to delete this user?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                _deleteUser(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('Customers')
          .doc(userId)
          .delete();
      Navigator.of(context).pop(); // Close the dialog
      Navigator.of(context).pop(); // Go back to the previous screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted successfully')),
      );
    } catch (e) {
      print('Error deleting user: $e');
      Navigator.of(context).pop(); // Close the dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete user')),
      );
    }
  }
}
