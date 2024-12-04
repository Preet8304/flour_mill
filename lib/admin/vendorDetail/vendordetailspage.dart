import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VendorDetailsPage extends StatelessWidget {
  final String vendorId;

  const VendorDetailsPage({Key? key, required this.vendorId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Vendor Details',style: TextStyle(color: Colors.white),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('Providers').doc(vendorId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Vendor not found', style: TextStyle(color: Colors.white)));
          }

          final vendorData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: vendorData['imageUrl'] != null
                        ? CachedNetworkImageProvider(vendorData['imageUrl'] as String)
                        : null,
                    child: vendorData['imageUrl'] == null
                        ? Icon(Icons.store, size: 60, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  vendorData['shopname']?.toString() ?? 'Shop Name',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  'Owner: ${vendorData['ownername']?.toString() ?? 'Owner Name'}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                _buildInfoRow('Phone number', vendorData['phonenumber']?.toString() ?? 'N/A'),
                _buildInfoRow('Email address', vendorData['email']?.toString() ?? 'N/A'),
                _buildInfoRow('Address', vendorData['address']?.toString() ?? 'N/A'),
                _buildInfoRow('Operating hours', vendorData['operatinghours']?.toString() ?? 'N/A'),
                const SizedBox(height: 20),
                const Text(
                  'Flour Types',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 10),
                _buildFlourTypesGrid(vendorData['flourTypes'] as List<dynamic>? ?? []),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () => _showDeleteConfirmation(context),
                    child: const Text('Delete Account'),
                  ),
                ),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildFlourTypesGrid(List<dynamic> flourTypes) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: flourTypes.length,
      itemBuilder: (context, index) {
        final flour = flourTypes[index] as Map<String, dynamic>? ?? {};
        final flourName = flour['name']?.toString() ?? 'Unknown'; // Changed this line
        final price = flour['price']?.toString() ?? 'N/A';
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getFlourIcon(flour['flourTypes']?.toString() ?? ''),
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(height: 5),
              Text(
                // flour['flourTypes']?.toString() ?? 'Unknown',
                flourName,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                //'\$${flour['price']?.toString() ?? 'N/A'} / bag',
              '\$$price / Kg',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getFlourIcon(String flourType) {
    switch (flourType.toLowerCase()) {
      case 'wheat':
        return Icons.grass;
      case 'rice':
        return Icons.rice_bowl;
      case 'corn':
        return Icons.eco;
      case 'oats':
        return Icons.grain;
      default:
        return Icons.local_florist;
    }
  }

void _showDeleteConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Delete Vendor"),
        content: const Text("Are you sure you want to delete this vendor?"),
        actions: <Widget>[
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text("Delete"),
            onPressed: () async {
              try {
                // Delete the vendor document from Firestore
                await FirebaseFirestore.instance
                    .collection('Providers')
                    .doc(vendorId)
                    .delete();

                // Close the dialog
                Navigator.of(context).pop();

                // Navigate back to the previous screen (vendor list)
                Navigator.of(context).pop();

                // Show a success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vendor deleted successfully')),
                );
              } catch (e) {
                // If an error occurs, show an error message
                print('Error deleting vendor: $e');
                Navigator.of(context).pop(); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to delete vendor')),
                );
              }
            },
          ),
        ],
      );
    },
  );
}
}