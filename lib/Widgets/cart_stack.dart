// import 'package:flour_mill/Screens/checkoutSummary.dart';
// import 'package:flutter/material.dart';

// // Define a type for the callback
// typedef RemoveFromCartCallback = void Function(String itemName);

// class CartStack extends StatelessWidget {
//   final int cartItemCount;
//   final Map<String, int> cart;
//   final RemoveFromCartCallback onRemoveFromCart; // Add this parameter to pass the remove callback

//   const CartStack({
//     Key? key,
//     required this.cartItemCount,
//     required this.cart,
//     required this.onRemoveFromCart, // Initialize the remove callback
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         InkWell(
//           borderRadius: BorderRadius.circular(80),
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => CheckoutSummary(
//                   cart: cart,
//                   onRemove: onRemoveFromCart, orderHistory: [], // Pass the remove callback to CheckoutPage
//                   refreshHomePage: () {}, shopId: '',
//                    shopName: '',
//                     // Add this line
//                 ),
//               ),
//             );
//           },
//           child: Padding(
//             padding: const EdgeInsets.only(right: 10),
//             child: Badge(
//               isLabelVisible: cartItemCount > 0,  // Ensure badge is only shown when items are present
//               label: Text(cartItemCount.toString()), // Display cart count
//               child: const Icon(
//                 Icons.shopping_cart_outlined,
//                 size: 28,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
