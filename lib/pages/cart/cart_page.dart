// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:valuebuyin/pages/cart/cart_controller.dart';
// import 'package:valuebuyin/pages/checkout_page.dart'; // Import your CheckoutPage

// class CartPage extends StatelessWidget {
//   final CartController cartController = Get.find<CartController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Cart'),
//         backgroundColor: Colors.orangeAccent,
//       ),
//       body: Obx(() {
//         if (cartController.cartItems.isEmpty) {
//           return const Center(child: Text('Your cart is empty'));
//         }

//         double totalPrice = cartController.cartItems.values
//             .expand((itemList) => itemList)
//             .fold(0.0, (sum, item) => sum + (item['total_price'] ?? 0));

//         return Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: cartController.cartItems.length,
//                 itemBuilder: (context, index) {
//                   final category =
//                       cartController.cartItems.keys.elementAt(index);
//                   final products = cartController.cartItems[category]!;

//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(category,
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 16)),
//                       ),
//                       ...products.map((product) {
//                         return Card(
//                           child: ListTile(
//                             leading: product['image_url'] != null
//                                 ? Image.network(
//                                     product['image_url'],
//                                     width: 50,
//                                     height: 50,
//                                     fit: BoxFit.cover,
//                                   )
//                                 : Icon(Icons.image),
//                             title: Text(product['product_name']),
//                             subtitle: Text(
//                               'Weight: ${product['weight']} kg\nPrice: Rs. ${product['total_price']}',
//                             ),
//                             trailing: IconButton(
//                               icon: Icon(Icons.delete, color: Colors.red),
//                               onPressed: () async {
//                                 final cartItemId = product['cart_item_id'];
//                                 if (cartItemId != null) {
//                                   await cartController.deleteCartItem(cartItemId);
//                                 } else {
//                                   Get.snackbar(
//                                     'Error',
//                                     'Unable to delete item. Missing cart item ID.',
//                                     snackPosition: SnackPosition.TOP,
//                                   );
//                                 }
//                               },
                              
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ],
//                   );
//                 },
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 border: Border(top: BorderSide(color: Colors.grey)),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Total: Rs. $totalPrice',
//                     style: TextStyle(
//                         fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       Get.to(() => CheckoutPage(
//                             cartItems: cartController.cartItems,
//                             subtotal: totalPrice,
//                           ));
//                     },
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.orangeAccent),
//                     child: const Text('Checkout'),
//                   )
//                 ],
//               ),
//             )
//           ],
//         );
//       }),
//     );
//   }
// }

















// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// // ignore: depend_on_referenced_packages
// import 'package:badges/badges.dart' as badges; // Use badges package for cart icon badge
// import 'package:valuebuyin/pages/checkout_page.dart';
// import 'cart_controller.dart';
// import 'checkout_page.dart'; // Ensure this file exists

// class CartPage extends StatelessWidget {
//   final CartController cartController = Get.find<CartController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Obx(() => Text('Cart (${cartController.cartItemCount.value})')),
//         backgroundColor: Colors.orangeAccent,
//       ),
//       body: Obx(() {
//         if (cartController.cartItems.isEmpty) {
//           return const Center(child: Text('Your cart is empty'));
//         }

//         double totalPrice = cartController.cartItems.values
//             .expand((itemList) => itemList)
//             .fold(0.0, (sum, item) => sum + (item['total_price'] ?? 0));

//         return Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: cartController.cartItems.length,
//                 itemBuilder: (context, index) {
//                   final category =
//                       cartController.cartItems.keys.elementAt(index);
//                   final products = cartController.cartItems[category]!;

//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           category,
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 16),
//                         ),
//                       ),
//                       ...products.map((product) {
//                         return Card(
//                           child: ListTile(
//                             leading: product['image_url'] != null
//                                 ? Image.network(
//                                     product['image_url'],
//                                     width: 50,
//                                     height: 50,
//                                     fit: BoxFit.cover,
//                                   )
//                                 : const Icon(Icons.image),
//                             title: Text(product['product_name']),
//                             subtitle: Text(
//                               'Weight: ${product['weight']} kg\nPrice: Rs. ${product['total_price']}',
//                             ),
//                             trailing: IconButton(
//                               icon: const Icon(Icons.delete, color: Colors.red),
//                               onPressed: () async {
//                                 final cartItemId = product['cart_item_id'];
//                                 if (cartItemId != null) {
//                                   await cartController.deleteCartItem(cartItemId);
//                                 } else {
//                                   Get.snackbar(
//                                     'Error',
//                                     'Unable to delete item. Missing cart item ID.',
//                                     snackPosition: SnackPosition.TOP,
//                                   );
//                                 }
//                               },
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ],
//                   );
//                 },
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 border: const Border(top: BorderSide(color: Colors.grey)),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Total: Rs. $totalPrice',
//                     style: const TextStyle(
//                         fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       Get.to(() => CheckoutPage(
//                             cartItems: cartController.cartItems,
//                             subtotal: totalPrice,
//                           ));
//                     },
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.orangeAccent),
//                     child: const Text('Checkout'),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       }),
//       // Adding a BottomNavigationBar to demonstrate the cart badge
//       bottomNavigationBar: Obx(() => BottomNavigationBar(
//             items: [
//               const BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               label: 'Home',
//               ),
//               BottomNavigationBarItem(
//               icon: badges.Badge(
//                 badgeContent: Text(
//                 cartController.cartItemCount.value.toString(),
//                 style: const TextStyle(color: Colors.white),
//                 ),
//                 child: const Icon(Icons.shopping_cart),
//               ),
//               label: 'Cart',
//               ),
//               const BottomNavigationBarItem(
//               icon: Icon(Icons.person),
//               label: 'Profile',
//               ),
//             ],
//             currentIndex: 1, // Highlight the Cart tab
//             selectedItemColor: Colors.orangeAccent,
//             onTap: (index) {
//               // Handle navigation (e.g., to Home, Cart, Profile)
//               if (index == 1) {
//               // Already on Cart page
//               } else if (index == 0) {
//               // Navigate to Home (implement as needed)
//               Get.back();
//               } else if (index == 2) {
//               // Navigate to Profile
//               Get.toNamed('/profile'); // Ensure the route '/profile' is defined
//               }
//             },
            
//           )),
//     );
//   }
// }











// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:badges/badges.dart' as badges;
// import 'package:valuebuyin/pages/cart/cart_controller.dart';
// import 'package:valuebuyin/pages/checkout_page.dart';

// class CartPage extends StatelessWidget {
//   final CartController cartController = Get.find<CartController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Obx(() => Text('Cart (${cartController.cartItemCount.value})')),
//         backgroundColor: Colors.orangeAccent,
//         centerTitle: true,
//       ),
//       body: Obx(() {
//         if (cartController.cartItems.isEmpty) {
//           return const Center(
//             child: Text(
//               'Your cart is empty',
//               style: TextStyle(fontSize: 18, color: Colors.grey),
//             ),
//           );
//         }

//         double totalPrice = cartController.getTotalPrice();

//         return Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: cartController.cartItems.length,
//                 itemBuilder: (context, index) {
//                   final category =
//                       cartController.cartItems.keys.elementAt(index);
//                   final products = cartController.cartItems[category]!;

//                   return ExpansionTile(
//                     title: Text(
//                       category,
//                       style: const TextStyle(
//                           fontWeight: FontWeight.bold, fontSize: 16),
//                     ),
//                     children: products.map((product) {
//                       return Card(
//                         elevation: 2,
//                         margin: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 4),
//                         child: ListTile(
//                           leading: product['image_url'] != null
//                               ? Image.network(
//                                   product['image_url'],
//                                   width: 50,
//                                   height: 50,
//                                   fit: BoxFit.cover,
//                                   errorBuilder: (context, error, stackTrace) =>
//                                       const Icon(Icons.broken_image),
//                                 )
//                               : const Icon(Icons.image, size: 50),
//                           title: Text(
//                             product['product_name'],
//                             style: const TextStyle(fontWeight: FontWeight.w600),
//                           ),
//                           subtitle: Text(
//                             'Weight: ${product['weight']} kg\nPrice: Rs. ${product['total_price']}',
//                           ),
//                           trailing: IconButton(
//                             icon: const Icon(Icons.delete, color: Colors.red),
//                             onPressed: () async {
//                               final cartItemId = product['cart_item_id'];
//                               if (cartItemId != null) {
//                                 await cartController.deleteCartItem(cartItemId);
//                               } else {
//                                 Get.snackbar(
//                                   'Error',
//                                   'Unable to delete item. Missing cart item ID.',
//                                   snackPosition: SnackPosition.TOP,
//                                   backgroundColor: Colors.red,
//                                   colorText: Colors.white,
//                                 );
//                               }
//                             },
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   );
//                 },
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 border: const Border(top: BorderSide(color: Colors.grey)),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Total: Rs. ${totalPrice.toStringAsFixed(2)}',
//                     style: const TextStyle(
//                         fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       Get.to(() => CheckoutPage(
//                             cartItems: cartController.cartItems,
//                             subtotal: totalPrice,
//                           ));
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.orangeAccent,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                     child: const Text(
//                       'Checkout',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       }),
//       bottomNavigationBar: Obx(() => BottomNavigationBar(
//             items: [
//               const BottomNavigationBarItem(
//                 icon: Icon(Icons.home),
//                 label: 'Home',
//               ),
//               BottomNavigationBarItem(
//                 icon: badges.Badge(
//                   badgeContent: Text(
//                     cartController.cartItemCount.value.toString(),
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                   child: const Icon(Icons.shopping_cart),
//                 ),
//                 label: 'Cart',
//               ),
//               const BottomNavigationBarItem(
//                 icon: Icon(Icons.person),
//                 label: 'Profile',
//               ),
//             ],
//             currentIndex: 1,
//             selectedItemColor: Colors.orangeAccent,
//             onTap: (index) {
//               if (index == 1) {
//                 // Already on Cart page
//               } else if (index == 0) {
//                 Navigator.popUntil(context, (route) => route.isFirst);
//               } else if (index == 2) {
//                 // Navigate to Profile (implement as needed)
//               }
//             },
//           )),
//     );
//   }
// }














// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:badges/badges.dart' as badges;
// import 'package:valuebuyin/pages/cart/cart_controller.dart';
// import 'package:valuebuyin/pages/checkout_page.dart';

// class CartPage extends StatelessWidget {
//   final CartController cartController = Get.find<CartController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Obx(() => Text('Cart (${cartController.cartItemCount.value})')),
//         backgroundColor: Colors.orangeAccent,
//         centerTitle: true,
//       ),
//       body: Obx(() {
//         if (cartController.cartItems.isEmpty) {
//           return const Center(
//             child: Text(
//               'Your cart is empty',
//               style: TextStyle(fontSize: 18, color: Colors.grey),
//             ),
//           );
//         }

//         double totalPrice = cartController.getTotalPrice();

//         return Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: cartController.cartItems.length,
//                 itemBuilder: (context, index) {
//                   final category =
//                       cartController.cartItems.keys.elementAt(index);
//                   final products = cartController.cartItems[category]!;

//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           category,
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 16),
//                         ),
//                       ),
//                       ...products.map((product) {
//                         return Card(
//                           elevation: 2,
//                           margin: const EdgeInsets.symmetric(
//                               horizontal: 8, vertical: 4),
//                           child: ListTile(
//                             leading: product['image_url'] != null
//                                 ? Image.network(
//                                     product['image_url'],
//                                     width: 50,
//                                     height: 50,
//                                     fit: BoxFit.cover,
//                                     errorBuilder: (context, error, stackTrace) =>
//                                         const Icon(Icons.broken_image),
//                                   )
//                                 : const Icon(Icons.image, size: 50),
//                             title: Text(
//                               product['product_name'],
//                               style: const TextStyle(fontWeight: FontWeight.w600),
//                             ),
//                             subtitle: Text(
//                               'Weight: ${product['weight']} kg\nPrice: Rs. ${product['total_price']}',
//                             ),
//                             trailing: IconButton(
//                               icon: const Icon(Icons.delete, color: Colors.red),
//                               onPressed: () async {
//                                 final cartItemId = product['cart_item_id'];
//                                 if (cartItemId != null) {
//                                   await cartController.deleteCartItem(cartItemId);
//                                 } else {
//                                   Get.snackbar(
//                                     'Error',
//                                     'Unable to delete item. Missing cart item ID.',
//                                     snackPosition: SnackPosition.TOP,
//                                     backgroundColor: Colors.red,
//                                     colorText: Colors.white,
//                                   );
//                                 }
//                               },
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ],
//                   );
//                 },
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 border: const Border(top: BorderSide(color: Colors.grey)),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Total: Rs. ${totalPrice.toStringAsFixed(2)}',
//                     style: const TextStyle(
//                         fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       Get.to(() => CheckoutPage(
//                             cartItems: cartController.cartItems,
//                             subtotal: totalPrice,
//                           ));
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.orangeAccent,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                     child: const Text(
//                       'Checkout',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       }),
//       bottomNavigationBar: Obx(() => BottomNavigationBar(
//             items: [
//               const BottomNavigationBarItem(
//                 icon: Icon(Icons.home),
//                 label: 'Home',
//               ),
//               BottomNavigationBarItem(
//                 icon: badges.Badge(
//                   badgeContent: Text(
//                     cartController.cartItemCount.value.toString(),
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                   child: const Icon(Icons.shopping_cart),
//                 ),
//                 label: 'Cart',
//               ),
//               const BottomNavigationBarItem(
//                 icon: Icon(Icons.person),
//                 label: 'Profile',
//               ),
//             ],
//             currentIndex: 1,
//             selectedItemColor: Colors.orangeAccent,
//             onTap: (index) {
//               if (index == 1) {
//                 // Already on Cart page
//               } else if (index == 0) {
//                 Navigator.popUntil(context, (route) => route.isFirst);
//               } else if (index == 2) {
//                 // Navigate to Profile (implement as needed)
//               }
//             },
//           )),
//     );
//   }
// }





// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:badges/badges.dart' as badges;
// import 'package:valuebuyin/pages/cart/cart_controller.dart';
// import 'package:valuebuyin/pages/checkout_page.dart';

// class CartPage extends StatelessWidget {
//   final CartController cartController = Get.find<CartController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Obx(() => Text('Cart (${cartController.cartItemCount.value})')),
//         backgroundColor: Colors.orangeAccent,
//         centerTitle: true,
//       ),
//       body: Obx(() {
//         if (cartController.cartItems.isEmpty) {
//           return const Center(
//             child: Text(
//               'Your cart is empty',
//               style: TextStyle(fontSize: 18, color: Colors.grey),
//             ),
//           );
//         }

//         return Column(
//           children: [
//             // Select All Checkbox and Selected Items Counter
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Checkbox(
//                         value: cartController.areAllProductsSelected(),
//                         onChanged: (value) {
//                           cartController.toggleSelectAll(value ?? false);
//                         },
//                         activeColor: Colors.orangeAccent,
//                       ),
//                       const Text(
//                         'Select All',
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                   Text(
//                     'Selected: ${cartController.selectedProducts.length}',
//                     style: const TextStyle(fontSize: 16, color: Colors.grey),
//                   ),
//                 ],
//               ),
//             ),
//             // Delete Selected Button
//             if (cartController.selectedProducts.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () async {
//                         await cartController.deleteSelectedProducts();
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                       child: const Text(
//                         'Delete Selected',
//                         style: TextStyle(fontSize: 14, color: Colors.white),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             // Cart Items List
//             Expanded(
//               child: ListView.builder(
//                 itemCount: cartController.cartItems.length,
//                 itemBuilder: (context, index) {
//                   final category =
//                       cartController.cartItems.keys.elementAt(index);
//                   final products = cartController.cartItems[category]!;

//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           category,
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 16),
//                         ),
//                       ),
//                       ...products.map((product) {
//                         return Card(
//                           elevation: 2,
//                           margin: const EdgeInsets.symmetric(
//                               horizontal: 8, vertical: 4),
//                           child: ListTile(
//                             leading: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 // Checkbox for individual product
//                                 Checkbox(
//                                   value: cartController.selectedProducts
//                                       .contains(product),
//                                   onChanged: (value) {
//                                     cartController.toggleProductSelection(product);
//                                   },
//                                   activeColor: Colors.orangeAccent,
//                                 ),
//                                 product['image_url'] != null
//                                     ? Image.network(
//                                         product['image_url'],
//                                         width: 50,
//                                         height: 50,
//                                         fit: BoxFit.cover,
//                                         errorBuilder:
//                                             (context, error, stackTrace) =>
//                                                 const Icon(Icons.broken_image),
//                                       )
//                                     : const Icon(Icons.image, size: 50),
//                               ],
//                             ),
//                             title: Text(
//                               product['product_name'],
//                               style: const TextStyle(fontWeight: FontWeight.w600),
//                             ),
//                             subtitle: Text(
//                               'Weight: ${product['weight']} kg\nPrice: Rs. ${product['total_price']}',
//                             ),
//                             trailing: IconButton(
//                               icon: const Icon(Icons.delete, color: Colors.red),
//                               onPressed: () async {
//                                 final cartItemId = product['cart_item_id'];
//                                 if (cartItemId != null) {
//                                   await cartController.deleteCartItem(cartItemId);
//                                 } else {
//                                   Get.snackbar(
//                                     'Error',
//                                     'Unable to delete item. Missing cart item ID.',
//                                     snackPosition: SnackPosition.TOP,
//                                     backgroundColor: Colors.red,
//                                     colorText: Colors.white,
//                                   );
//                                 }
//                               },
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ],
//                   );
//                 },
//               ),
//             ),
//             // Total Price and Checkout Button
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 border: const Border(top: BorderSide(color: Colors.grey)),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Obx(() {
//                     double totalPrice = cartController.selectedProducts.isNotEmpty
//                         ? cartController.getSelectedTotalPrice()
//                         : cartController.getTotalPrice();
//                     return Text(
//                       'Total: Rs. ${totalPrice.toStringAsFixed(2)}',
//                       style: const TextStyle(
//                           fontSize: 18, fontWeight: FontWeight.bold),
//                     );
//                   }),
//                   ElevatedButton(
//                     onPressed: () {
//                       // If products are selected, pass only selected products to checkout
//                       Map<String, List<Map<String, dynamic>>> itemsToCheckout;
//                       if (cartController.selectedProducts.isNotEmpty) {
//                         itemsToCheckout = {};
//                         for (var product in cartController.selectedProducts) {
//                           final category = cartController.cartItems.entries
//                               .firstWhere((entry) =>
//                                   entry.value.contains(product))
//                               .key;
//                           if (!itemsToCheckout.containsKey(category)) {
//                             itemsToCheckout[category] = [];
//                           }
//                           itemsToCheckout[category]!.add(product);
//                         }
//                       } else {
//                         itemsToCheckout = cartController.cartItems;
//                       }
//                       Get.to(() => CheckoutPage(
//                             cartItems: itemsToCheckout,
//                             subtotal: cartController.selectedProducts.isNotEmpty
//                                 ? cartController.getSelectedTotalPrice()
//                                 : cartController.getTotalPrice(),
//                           ));
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.orangeAccent,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                     child: const Text(
//                       'Checkout',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       }),
//       bottomNavigationBar: Obx(() => BottomNavigationBar(
//             items: [
//               const BottomNavigationBarItem(
//                 icon: Icon(Icons.home),
//                 label: 'Home',
//               ),
//               BottomNavigationBarItem(
//                 icon: badges.Badge(
//                   badgeContent: Text(
//                     cartController.cartItemCount.value.toString(),
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                   child: const Icon(Icons.shopping_cart),
//                 ),
//                 label: 'Cart',
//               ),
//               const BottomNavigationBarItem(
//                 icon: Icon(Icons.person),
//                 label: 'Profile',
//               ),
//             ],
//             currentIndex: 1,
//             selectedItemColor: Colors.orangeAccent,
//             onTap: (index) {
//               if (index == 1) {
//                 // Already on Cart page
//               } else if (index == 0) {
//                 Navigator.popUntil(context, (route) => route.isFirst);
//               } else if (index == 2) {
//                 // Navigate to Profile (implement as needed)
//               }
//             },
//           )),
//     );
//   }
// }











import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import 'package:valuebuyin/pages/cart/cart_controller.dart';
import 'package:valuebuyin/pages/checkout_page.dart';

class CartPage extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('Cart (${cartController.cartItemCount.value})')),
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
      ),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return const Center(
            child: Text(
              'Your cart is empty',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return Column(
          children: [
            // Select All Checkbox and Selected Items Counter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: cartController.areAllProductsSelected(),
                        onChanged: (value) {
                          cartController.toggleSelectAll(value ?? false);
                        },
                        activeColor: Colors.orangeAccent,
                      ),
                      const Text(
                        'Select All',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(
                    'Selected: ${cartController.selectedProducts.length}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            // Delete Selected Button
            if (cartController.selectedProducts.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await cartController.deleteSelectedProducts();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Delete Selected',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            // Cart Items List
            Expanded(
              child: ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final category =
                      cartController.cartItems.keys.elementAt(index);
                  final products = cartController.cartItems[category]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          category,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      ...products.map((product) {
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: ListTile(
                            leading: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Checkbox for individual product
                                Checkbox(
                                  value: cartController.selectedProducts
                                      .contains(product),
                                  onChanged: (value) {
                                    cartController.toggleProductSelection(product);
                                  },
                                  activeColor: Colors.orangeAccent,
                                ),
                                product['image_url'] != null
                                    ? Image.network(
                                        product['image_url'],
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(Icons.broken_image),
                                      )
                                    : const Icon(Icons.image, size: 50),
                              ],
                            ),
                            title: Text(
                              product['product_name'],
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              'Weight: ${product['weight']} kg\nPrice: Rs. ${product['total_price']}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final cartItemId = product['cart_item_id'];
                                if (cartItemId != null) {
                                  await cartController.deleteCartItem(cartItemId);
                                } else {
                                  Get.snackbar(
                                    'Error',
                                    'Unable to delete item. Missing cart item ID.',
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  );
                },
              ),
            ),
            // Total Price and Checkout Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: const Border(top: BorderSide(color: Colors.grey)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() {
                    double totalPrice = cartController.selectedProducts.isNotEmpty
                        ? cartController.getSelectedTotalPrice()
                        : cartController.getTotalPrice();
                    return Text(
                      'Total: Rs. ${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    );
                  }),
                  ElevatedButton(
                    onPressed: cartController.selectedProducts.isEmpty
                        ? null
                        : () {
                            // Pass only selected products to checkout
                            Map<String, List<Map<String, dynamic>>> itemsToCheckout = {};
                            for (var product in cartController.selectedProducts) {
                              final category = cartController.cartItems.entries
                                  .firstWhere((entry) =>
                                      entry.value.contains(product))
                                  .key;
                              if (!itemsToCheckout.containsKey(category)) {
                                itemsToCheckout[category] = [];
                              }
                              itemsToCheckout[category]!.add(product);
                            }
                            Get.to(() => CheckoutPage(
                                  cartItems: itemsToCheckout,
                                  subtotal: cartController.getSelectedTotalPrice(),
                                ));
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cartController.selectedProducts.isEmpty
                          ? Colors.grey
                          : Colors.orangeAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Checkout',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: badges.Badge(
                  badgeContent: Text(
                    cartController.cartItemCount.value.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  child: const Icon(Icons.shopping_cart),
                ),
                label: 'Cart',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: 1,
            selectedItemColor: Colors.orangeAccent,
            onTap: (index) {
              if (index == 1) {
                // Already on Cart page
              } else if (index == 0) {
                Navigator.popUntil(context, (route) => route.isFirst);
              } else if (index == 2) {
                // Navigate to Profile (implement as needed)
              }
            },
          )),
    );
  }
}