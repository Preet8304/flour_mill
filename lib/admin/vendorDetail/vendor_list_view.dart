import 'package:flour_mill/admin/vendorDetail/vendordetailspage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VendorListView extends StatelessWidget {
  const VendorListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Providers').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final vendors = snapshot.data!.docs;

        return ListView.builder(
          itemCount: vendors.length,
          itemBuilder: (context, index) {
            final vendorData = vendors[index].data() as Map<String, dynamic>;
            final vendorName = vendorData['ownername'] ?? 'No Name';
            final vendorEmail = vendorData['email'] ?? 'No Email';
            final vendorImageUrl = vendorData['imageUrl'] as String?;

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: vendorImageUrl != null
                    ? CachedNetworkImageProvider(vendorImageUrl)
                    : null,
                child: vendorImageUrl == null
                    ? Text(vendorName[0].toUpperCase())
                    : null,
              ),
              title: Text(vendorName),
              subtitle: Text(vendorEmail),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VendorDetailsPage(vendorId: vendors[index].id),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}