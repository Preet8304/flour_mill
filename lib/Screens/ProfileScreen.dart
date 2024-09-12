import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Handle edit button press
            },
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage('https://d2qp0siotla746.cloudfront.net/img/use-cases/profile-picture/template_3.jpg'), // Replace with the actual image URL
                ),
                SizedBox(width: 16),
                Expanded( // Apply Expanded to fix the overflow
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi, Nobita",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Let's explore together",
                        style: TextStyle(
                          color: Colors.blueGrey,
                        ),
                      ),
                      Text(
                        "Joined in 2021",
                        style: TextStyle(
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            InfoTile(
              icon: Icons.person_outline,
              title: 'Shizuka',
              subtitle: 'Full Name',
            ),
            InfoTile(
              icon: Icons.phone,
              title: '+91 8888888888',
              subtitle: 'Mobile Number',
            ),
            InfoTile(
              icon: Icons.location_on,
              title: 'Tokyo, Nerima Ward',
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
