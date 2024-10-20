import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UserDetailsPage extends StatelessWidget {
  final String userId;

  const UserDetailsPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
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
                    backgroundImage: userData['profilePic'] != null &&
                            userData['profilePic'].isNotEmpty
                        ? NetworkImage(userData['profilePic'])
                        : const AssetImage('assets/default_profile.jpg')
                            as ImageProvider,
                    onBackgroundImageError: (exception, stackTrace) {
                      // This will be called if the image fails to load
                      print('Error loading profile image: $exception');
                    },
                    child: userData['profilePic'] == null ||
                            userData['profilePic'].isEmpty
                        ? Text(userData['name']?[0].toUpperCase() ?? '?',
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold))
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                _buildInfoRow('Name', userData['name'] ?? 'N/A'),
                _buildInfoRow('Email', userData['email'] ?? 'N/A'),
                _buildInfoRow('Phone', userData['phone'] ?? 'N/A'),
                _buildInfoRow('Address', userData['location'] ?? 'N/A'),
                _buildInfoRow('Created At', formattedDate),

                // Add more fields as needed
              ],
            ),
          );
        },
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
}
