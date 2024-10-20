// import 'package:flutter/material.dart';
// import 'package:flour_mill/model/flour_mills.dart';
// import 'package:flour_mill/Screens/OrderingScreen.dart'; // Ensure this import is added

// class FlourMillCard extends StatelessWidget {
//   final FlourMill flourMill;

//   const FlourMillCard({
//     super.key,
//     required this.flourMill,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(20),
//         onTap: () {
//           // Navigate to the OrderingScreen with the selected flourMill
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => OrderingScreen(mills: flourMill)),
//           );
//         },
//         child: Card(
//           color: Colors.white,
//           elevation: 4,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Stack(
//                 children: [
//                   // Image
//                   ClipRRect(
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(15),
//                       topRight: Radius.circular(15),
//                     ),
//                     child: Image.network(
//                       flourMill.imageUrl,
//                       height: 180,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.shopify_sharp,
//                         size: 16, color: Colors.greenAccent),
//                     const SizedBox(width: 4),
//                     Text(
//                       '${flourMill.shopname}',
//                       style: TextStyle(color: Colors.grey[600], fontSize: 12),
//                     ),
//                     const Spacer(),
//                   ],
//                 ),
//               ),
//               const Divider(),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.location_on_outlined,
//                         size: 16, color: Colors.red),
//                     const SizedBox(width: 4),
//                     Text(
//                       flourMill.address,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const Spacer(),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 6, vertical: 2),
//                       decoration: BoxDecoration(
//                         color: Colors.green,
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       child: Row(
//                         children: [
//                           Text(
//                             '${flourMill.rating}',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 12,
//                             ),
//                           ),
//                           const Icon(Icons.star, color: Colors.white, size: 12),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flour_mill/model/flour_mills.dart';
// import 'package:flutter/material.dart';

// class FlourMillCard extends StatelessWidget {
//   final FlourMill flourMill;

//   const FlourMillCard({Key? key, required this.flourMill}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     print("Building card for: ${flourMill.shopname}");
//     return Card(
//       margin: const EdgeInsets.all(8.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min, // Add this line
//         children: [
//           Image.network(
//             flourMill.imageUrl,
//             height: 200,
//             width: double.infinity,
//             fit: BoxFit.cover,
//             errorBuilder: (context, error, stackTrace) {
//               print("Error loading image: $error");
//               return Container(
//                 height: 200,
//                 color: Colors.grey[300],
//                 child: Icon(Icons.error, color: Colors.red),
//               );
//             },
//           ),
//           ListTile(
//             title: Text(flourMill.shopname),
//             subtitle: Text(flourMill.address),
//             trailing: Text("Rating: ${flourMill.rating}"),
//           ),
//           //   Container(
//           //   height: 150, // Adjust as needed
//           //   child: ListView.builder(
//           //     itemCount: flourMill.flourTypes.length,
//           //     itemBuilder: (context, index) {
//           //       var flourType = flourMill.flourTypes[index];
//           //       String typeName = flourType['name']?.toString() ?? 'Unknown';
//           //       double price = flourType['price']?.toDouble() ?? 0.0;

//           //       return ListTile(
//           //         title: Text(typeName == '0.0' ? 'Unknown Type' : typeName),
//           //         trailing: Text('₹${price.toStringAsFixed(2)} per kg'),
//           //       );
//           //     },
//           //   ),
//           // ),
//           ],
//       ),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flour_mill/model/flour_mills.dart';
import 'package:flour_mill/Screens/OrderingScreen.dart';

class FlourMillCard extends StatelessWidget {
  final FlourMill flourMill;

  const FlourMillCard({Key? key, required this.flourMill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrderingScreen(mills: flourMill)),
          );
        },
        child: Card(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: flourMill.imageUrl,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 180,
                        color: Colors.grey[300],
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 180,
                        color: Colors.grey[300],
                        child: Icon(Icons.error, color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.shopify_sharp,
                        size: 16, color: Colors.greenAccent),
                    const SizedBox(width: 4),
                    Text(
                      '${flourMill.shopname}',
                      style: TextStyle(
                          // color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 16, color: Colors.red),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        flourMill.address,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${flourMill.rating}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const Icon(Icons.star, color: Colors.white, size: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // const Divider(),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              //   child: Text(
              //     "Available Flour Types:",
              //     style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              //   ),
              // ),
              // Container(
              //   height: 100, // Adjust as needed
              //   child: ListView.builder(
              //     itemCount: flourMill.flourTypes.length,
              //     itemBuilder: (context, index) {
              //       var flourType = flourMill.flourTypes[index];
              //       String typeName = flourType.keys.first;
              //       double price = flourType.values.first;

              //       return Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(typeName, style: TextStyle(fontSize: 12)),
              //             Text('₹$price per kg', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              //           ],
              //         ),
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
