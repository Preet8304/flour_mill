import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flour_mill/admin/userDetail/userdetailspage.dart';
import 'package:flour_mill/firebase auth service/firebase_getuser.dart';

class UserListView extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  UserListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestoreService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final users = snapshot.data!.docs;

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final userData = users[index].data() as Map<String, dynamic>;
            final userName = userData['name'] ?? 'No Name';
            final userEmail = userData['email'] ?? 'No Email';
            final userImageUrl = userData['profilePic'] as String?;

            print('User: $userName, Image URL: $userImageUrl'); // Debug print

   return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: _buildUserAvatar(userImageUrl, userName),
              ),
              title: Text(userName),
              subtitle: Text(userEmail),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserDetailsPage(userId: users[index].id),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

   Widget _buildUserAvatar(String? imageUrl, String userName) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
        return ClipOval(
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => Text(userName[0]),
            fit: BoxFit.cover,
            width: 40,
            height: 40,
          ),
        );
      } else {
        return ClipOval(
          child: Image.file(
            File(imageUrl),
            fit: BoxFit.cover,
            width: 40,
            height: 40,
            errorBuilder: (context, error, stackTrace) => Text(userName[0]),
          ),
        );
      }
    } else {
      return Text(userName[0]);
    }
  }
}