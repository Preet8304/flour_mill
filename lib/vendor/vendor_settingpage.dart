import 'package:firebase_auth/firebase_auth.dart';
import 'package:flour_mill/pages/LoginPage.dart';
import 'package:flutter/material.dart';

class VendorSettingPage extends StatelessWidget {
  final Map<String, dynamic> shopData;

  const VendorSettingPage({Key? key, required this.shopData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   backgroundColor: Colors.black,
      //   automaticallyImplyLeading: false,
      // ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child:Container(
  width: double.infinity,
  child: AspectRatio(
    aspectRatio: 2, // This ensures a square shape
    child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: shopData['imageUrl'] != null && shopData['imageUrl'].isNotEmpty
              ? NetworkImage(shopData['imageUrl'] as String)
              : AssetImage('lib/assets/profile_image.jpg') as ImageProvider,
        ),
      ),
    ),
  ),
),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                shopData['shopname']?.toString() ?? 'Shop Name Not Available',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Center(
              child: Text(
                'Owner: ${shopData['ownername']?.toString() ?? 'Not Available'}',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
     child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Implement edit functionality
                      },
                      child: Text('Edit', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _signOut(context),
                      child: Text('Sign Out', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                  ),
                ],
              )
            ),
            SizedBox(height: 20),
            _buildInfoTile('Phone number', shopData['phonenumber']),
            _buildInfoTile('Email address', shopData['email']),
            _buildInfoTile('Address', shopData['address']),
            _buildInfoTile('Operating hours', shopData['operatinghours']),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Flour Types',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            _buildFlourTypeGrid(shopData['flourTypes'] as List<dynamic>? ?? []),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey)),
          SizedBox(height: 4),
          Text(value?.toString() ?? 'Not Available',
              style: TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildFlourTypeGrid(List<dynamic> flourTypes) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: flourTypes.length,
      itemBuilder: (context, index) {
        final flour = flourTypes[index] as Map<String, dynamic>? ?? {};
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.grass, color: Colors.white, size: 30),
              SizedBox(height: 8),
              Text(
                flour['name']?.toString() ?? 'Not Available',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                '₹${flour['price']?.toString() ?? 'Not Available'} / Kg',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }
}
 void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to login page and remove all previous routes
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print("Error signing out: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out. Please try again.')),
      );
    }
  }
