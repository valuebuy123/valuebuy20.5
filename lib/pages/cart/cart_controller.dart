// import 'dart:math';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class CartController extends GetxController {
//   final RxMap<String, List<Map<String, dynamic>>> cartItems =
//       <String, List<Map<String, dynamic>>>{}.obs;
//   final RxList<Map<String, dynamic>> orderHistory =
//       <Map<String, dynamic>>[].obs;
//   final RxInt cartItemCount = 0.obs;

//   final supabase = Supabase.instance.client; // Initialize Supabase

//   Future<void> addToCart(Map<String, dynamic> product, double weight) async {
//     try {
//       // Ensure the user ID is available
//       final userId = Supabase.instance.client.auth.currentUser?.id;
//       if (userId == null) {
//         throw Exception('User is not logged in.');
//       }

//       // Validate product name
//       final productName = product['name'];
//       if (productName == null || productName.isEmpty) {
//         throw Exception('Product name is missing.');
//       }

//       // Fetch product price details
//       final productResponse =
//           await Supabase.instance.client
//               .from('products')
//               .select(
//                 'price_0_5, price_6_25, price_26_50, price_51_100, price_100_above',
//               )
//               .eq('product_name', productName)
//               .maybeSingle();

//       if (productResponse == null) {
//         throw Exception('Product price details not found.');
//       }

//       // Determine price per kg based on weight
//       double pricePerKg = 0.0;
//       if (weight <= 5) {
//         pricePerKg = productResponse['price_0_5'];
//       } else if (weight <= 25) {
//         pricePerKg = productResponse['price_6_25'];
//       } else if (weight <= 50) {
//         pricePerKg = productResponse['price_26_50'];
//       } else if (weight <= 100) {
//         pricePerKg = productResponse['price_51_100'];
//       } else {
//         pricePerKg = productResponse['price_100_above'];
//       }

//       // Calculate total price
//       final double totalPrice = pricePerKg * weight;

//       // Insert a new row into the 'carts' table
//       final cartData = {
//         'user_id': userId,
//         'product_name': productName,
//         'weight': weight,
//         'price': totalPrice, // Insert total price
//         'created_at': DateTime.now().toIso8601String(),
//       };

//       await Supabase.instance.client.from('carts').insert(cartData);

//       Get.snackbar(
//         'Added to Cart',
//         '$productName has been added to your cart!',
//         snackPosition: SnackPosition.TOP,
//       );

//       cartItemCount.value += 1;
//     } catch (e) {
//       print('Error adding to cart: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to add item to cart: $e',
//         snackPosition: SnackPosition.TOP,
//       );
//     }
//   }

//   // This method is for adding a product to the cart with weight
//   // and is separate from the addToCart method to allow for different use cases

//   Future<void> addProductToCart(
//     Map<String, dynamic> product,
//     double weight,
//   ) async {
//     try {
//       final userId = Supabase.instance.client.auth.currentUser?.id;
//       if (userId == null) {
//         throw Exception('User is not logged in.');
//       }

//       // Check if this product already exists in cart for the current user
//       final existingProduct =
//           await Supabase.instance.client
//               .from('carts')
//               .select('weight')
//               .eq('user_id', userId)
//               .eq('product_name', product['name'])
//               .maybeSingle();

//       if (existingProduct != null) {
//         // Product exists — add to existing weight
//         final double existingWeight =
//             double.tryParse(existingProduct['weight'].toString()) ?? 0.0;
//         final double newWeight = existingWeight + weight;

//         await Supabase.instance.client
//             .from('carts')
//             .update({'weight': newWeight})
//             .match({'user_id': userId, 'product_name': product['name']});

//         Get.snackbar(
//           'Updated Cart',
//           '${product['name']} weight updated in your cart!',
//           snackPosition: SnackPosition.TOP,
//         );
//       } else {
//         // Product does not exist — insert a new cart entry
//         await Supabase.instance.client.from('carts').insert({
//           'user_id': userId,
//           'product_name': product['name'],
//           'weight': weight,
//           'price': product['price'],
//           'created_at': DateTime.now().toIso8601String(),
//         });

//         Get.snackbar(
//           'Added to Cart',
//           '${product['name']} has been added to your cart!',
//           snackPosition: SnackPosition.TOP,
//         );
//       }

//       // Update cart icon count (optional)
//       cartItemCount.value += 1;
//     } catch (e) {
//       print('Error adding to cart: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to add item to cart: $e',
//         snackPosition: SnackPosition.TOP,
//       );
//     }
//   }

//   Future<void> removeFromCart(
//     String category,
//     Map<String, dynamic> product,
//   ) async {
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) {
//         Get.snackbar("Error", "User not logged in");
//         return;
//       }

//       await supabase.from('carts').delete().match({
//         'user_id': userId,
//         //'product_id': product['id'], // Ensure product_id is used for matching
//         'product_name': product['name'],
//       });

//       if (cartItems.containsKey(category)) {
//         cartItems[category]!.remove(product);
//         if (cartItems[category]!.isEmpty) {
//           cartItems.remove(category);
//         }
//         cartItems.refresh();
//       }

//       cartItemCount.value =
//           cartItemCount.value > 0 ? cartItemCount.value - 1 : 0;
//       Get.snackbar(
//         'Removed',
//         '${product['name']} removed from cart',
//         snackPosition: SnackPosition.TOP,
//       );
//     } catch (error) {
//       Get.snackbar("Error", "Failed to remove from cart: $error");
//       print("Error removing from cart: $error");
//     }
//   }

//   Future<void> fetchCartItems() async {
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) {
//         throw Exception('User is not logged in.');
//       }

//       print('Fetching cart items for user: $userId'); // Debug log

//       // Fetch data directly as a list
//       final List<dynamic> data = await supabase
//           .from('carts')
//           .select('product_name, weight, price, created_at')
//           .eq('user_id', userId);

//       print('Fetched cart items: $data'); // Debug log

//       // Group items by category and calculate price dynamically
//       final Map<String, List<Map<String, dynamic>>> groupedItems = {};

//       for (final item in data) {
//         final category = item['category'] ?? 'Uncategorized';
//         if (!groupedItems.containsKey(category)) {
//           groupedItems[category] = [];
//         }

//         // Fetch product details to calculate price
//         final productResponse =
//             await supabase
//                 .from('products')
//                 .select(
//                   'price_0_5, price_6_25, price_26_50, price_51_100, price_100_above',
//                 )
//                 .eq('product_name', item['product_name'])
//                 // .eq('id', item['product_id'])
//                 .maybeSingle();

//         if (productResponse != null) {
//           final double weight =
//               double.tryParse(item['weight'].toString()) ?? 0.0;
//           double pricePerKg = 0.0;

//           // Determine price per kg based on weight
//           if (weight <= 5) {
//             pricePerKg = productResponse['price_0_5'];
//           } else if (weight <= 25) {
//             pricePerKg = productResponse['price_6_25'];
//           } else if (weight <= 50) {
//             pricePerKg = productResponse['price_26_50'];
//           } else if (weight <= 100) {
//             pricePerKg = productResponse['price_51_100'];
//           } else {
//             pricePerKg = productResponse['price_100_above'];
//           }

//           // Calculate total price
//           final double totalPrice = pricePerKg * weight;

//           // Add item with calculated price
//           groupedItems[category]!.add({
//             ...item,
//             'price_per_kg': pricePerKg,
//             'total_price': totalPrice,
//           });
//         }
//       }

//       cartItems.value = groupedItems;
//       cartItems.refresh();
//       print('Updated cartItems observable: $cartItems'); // Debug log
//     } catch (e) {
//       print('Error fetching cart items: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to fetch cart items: $e',
//         snackPosition: SnackPosition.TOP,
//       );
//     }
//   }

//   Future<void> deleteCartItem(int cartItemId) async {
//     try {
//       final response =
//           await supabase
//               .from('carts')
//               .delete()
//               .eq('cart_item_id', cartItemId)
// ;

//       if (response.error == null) {
//         fetchCartItems(); // Refresh cart items after deletion
//         Get.snackbar('Success', 'Item deleted successfully');
//       } else {
//         Get.snackbar(
//           'Error',
//           'Failed to delete item: ${response.error!.message}',
//         );
//       }
//     } catch (e) {
//       print('Error deleting cart item: $e');
//       Get.snackbar('Error', 'Failed to delete item: $e');
//     }
//   }

//   int getTotalItemCount() {
//     int count = 0;
//     cartItems.forEach((category, products) {
//       count += products.length;
//     });
//     return count;
//   }

//   double getTotalPrice() {
//     double total = 0;
//     cartItems.forEach((category, products) {
//       total += products.fold(
//         0,
//         (sum, product) => sum + (product['total_price'] as double),
//       );
//     });
//     return total;
//   }

//   void clearCart() {
//     cartItems.clear();
//     cartItems.refresh();
//     if (kDebugMode) {
//       print('Cart cleared');
//     }
//   }

//   Future<bool> placeOrder() async {
//     print('Placing order...');
//     await Future.delayed(const Duration(seconds: 2));
//     final random = Random();
//     bool success = random.nextDouble() < 0.7;
//     if (success) {
//       final order = {
//         'orderId': 'ORD${DateTime.now().millisecondsSinceEpoch}',
//         'date': DateTime.now(),
//         'items': Map<String, List<Map<String, dynamic>>>.from(cartItems),
//         'total': getTotalPrice(),
//         'trackingStatus': [
//           {'status': 'Order Placed', 'timestamp': DateTime.now()},
//           {
//             'status': 'Processing',
//             'timestamp': DateTime.now().add(const Duration(hours: 1)),
//           },
//           {
//             'status': 'Shipped',
//             'timestamp': DateTime.now().add(const Duration(days: 1)),
//           },
//           {
//             'status': 'Delivered',
//             'timestamp': DateTime.now().add(const Duration(days: 3)),
//           },
//         ],
//       };
//       orderHistory.add(order);
//       orderHistory.refresh();
//       if (kDebugMode) {
//         print('Order placed successfully: ${order['orderId']}');
//       }
//     } else {
//       if (kDebugMode) {
//         print('Order placement failed');
//       }
//     }
//     return success;
//   }

//   Map<String, dynamic>? getLatestOrder() {
//     if (orderHistory.isEmpty) return null;
//     return orderHistory.last;
//   }

//   void updateCartIcon() {
//     cartItemCount.refresh();
//   }
// }














// import 'dart:math';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class CartController extends GetxController {
//   final RxMap<String, List<Map<String, dynamic>>> cartItems =
//       <String, List<Map<String, dynamic>>>{}.obs;
//   final RxList<Map<String, dynamic>> orderHistory =
//       <Map<String, dynamic>>[].obs;
//   final RxInt cartItemCount = 0.obs;

//   final supabase = Supabase.instance.client; // Initialize Supabase

//   Future<void> addToCart(Map<String, dynamic> product, double weight) async {
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) {
//         throw Exception('User is not logged in.');
//       }

//       final productName = product['name'];
//       if (productName == null || productName.isEmpty) {
//         throw Exception('Product name is missing.');
//       }

//       final productResponse = await supabase
//           .from('products')
//           .select(
//             'price_0_5, price_6_25, price_26_50, price_51_100, price_100_above',
//           )
//           .eq('product_name', productName)
//           .maybeSingle();

//       if (productResponse == null) {
//         throw Exception('Product price details not found.');
//       }

//       double pricePerKg = 0.0;
//       if (weight <= 5) {
//         pricePerKg = productResponse['price_0_5'];
//       } else if (weight <= 25) {
//         pricePerKg = productResponse['price_6_25'];
//       } else if (weight <= 50) {
//         pricePerKg = productResponse['price_26_50'];
//       } else if (weight <= 100) {
//         pricePerKg = productResponse['price_51_100'];
//       } else {
//         pricePerKg = productResponse['price_100_above'];
//       }

//       final double totalPrice = pricePerKg * weight;

//       final cartData = {
//         'user_id': userId,
//         'product_name': productName,
//         'weight': weight,
//         'price': totalPrice,
//         'created_at': DateTime.now().toIso8601String(),
//       };

//       await supabase.from('carts').insert(cartData);

//       Get.snackbar(
//         'Added to Cart',
//         '$productName has been added to your cart!',
//         snackPosition: SnackPosition.TOP,
//       );

//       cartItemCount.value += 1;
//     } catch (e) {
//       print('Error adding to cart: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to add item to cart: $e',
//         snackPosition: SnackPosition.TOP,
//       );
//     }
//   }

//   Future<void> addProductToCart(
//     Map<String, dynamic> product,
//     double weight,
//   ) async {
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) {
//         throw Exception('User is not logged in.');
//       }

//       final existingProduct = await supabase
//           .from('carts')
//           .select('weight')
//           .eq('user_id', userId)
//           .eq('product_name', product['name'])
//           .maybeSingle();

//       if (existingProduct != null) {
//         final double existingWeight =
//             double.tryParse(existingProduct['weight'].toString()) ?? 0.0;
//         final double newWeight = existingWeight + weight;

//         await supabase
//             .from('carts')
//             .update({'weight': newWeight})
//             .match({'user_id': userId, 'product_name': product['name']});

//         Get.snackbar(
//           'Updated Cart',
//           '${product['name']} weight updated in your cart!',
//           snackPosition: SnackPosition.TOP,
//         );
//       } else {
//         await supabase.from('carts').insert({
//           'user_id': userId,
//           'product_name': product['name'],
//           'weight': weight,
//           'price': product['price'],
//           'created_at': DateTime.now().toIso8601String(),
//         });

//         Get.snackbar(
//           'Added to Cart',
//           '${product['name']} has been added to your cart!',
//           snackPosition: SnackPosition.TOP,
//         );
//       }

//       cartItemCount.value += 1;
//     } catch (e) {
//       print('Error adding to cart: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to add item to cart: $e',
//         snackPosition: SnackPosition.TOP,
//       );
//     }
//   }

//   Future<void> removeFromCart(
//     String category,
//     Map<String, dynamic> product,
//   ) async {
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) {
//         Get.snackbar("Error", "User not logged in");
//         return;
//       }

//       await supabase.from('carts').delete().match({
//         'user_id': userId,
//         'product_name': product['name'],
//       });

//       if (cartItems.containsKey(category)) {
//         cartItems[category]!.remove(product);
//         if (cartItems[category]!.isEmpty) {
//           cartItems.remove(category);
//         }
//         cartItems.refresh();
//       }

//       cartItemCount.value =
//           cartItemCount.value > 0 ? cartItemCount.value - 1 : 0;
//       Get.snackbar(
//         'Removed',
//         '${product['name']} removed from cart',
//         snackPosition: SnackPosition.TOP,
//       );
//     } catch (error) {
//       Get.snackbar("Error", "Failed to remove from cart: $error");
//       print("Error removing from cart: $error");
//     }
//   }

//   Future<void> fetchCartItems() async {
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) {
//         throw Exception('User is not logged in.');
//       }

//       print('Fetching cart items for user: $userId');

//       final List<dynamic> data = await supabase
//           .from('carts')
//           .select('cart_item_id, product_name, weight, price, created_at')
//           .eq('user_id', userId);

//       print('Fetched cart items: $data');

//       final Map<String, List<Map<String, dynamic>>> groupedItems = {};

//       for (final item in data) {
//         final category = item['category'] ?? 'Uncategorized';
//         if (!groupedItems.containsKey(category)) {
//           groupedItems[category] = [];
//         }

//         final productResponse = await supabase
//             .from('products')
//             .select(
//               'price_0_5, price_6_25, price_26_50, price_51_100, price_100_above',
//             )
//             .eq('product_name', item['product_name'])
//             .maybeSingle();

//         if (productResponse != null) {
//           final double weight =
//               double.tryParse(item['weight'].toString()) ?? 0.0;
//           double pricePerKg = 0.0;

//           if (weight <= 5) {
//             pricePerKg = productResponse['price_0_5'];
//           } else if (weight <= 25) {
//             pricePerKg = productResponse['price_6_25'];
//           } else if (weight <= 50) {
//             pricePerKg = productResponse['price_26_50'];
//           } else if (weight <= 100) {
//             pricePerKg = productResponse['price_51_100'];
//           } else {
//             pricePerKg = productResponse['price_100_above'];
//           }

//           final double totalPrice = pricePerKg * weight;

//           groupedItems[category]!.add({
//             ...item,
//             'price_per_kg': pricePerKg,
//             'total_price': totalPrice,
//           });
//         }
//       }

//       cartItems.value = groupedItems;
//       cartItems.refresh();
//       print('Updated cartItems observable: $cartItems');
//     } catch (e) {
//       print('Error fetching cart items: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to fetch cart items: $e',
//         snackPosition: SnackPosition.TOP,
//       );
//     }
//   }

//   Future<void> deleteCartItem(int cartItemId) async {
//     try {
//       await supabase.from('carts').delete().eq('cart_item_id', cartItemId);

//       fetchCartItems(); // Refresh cart items after deletion
//       cartItemCount.value =
//           cartItemCount.value > 0 ? cartItemCount.value - 1 : 0;
//       Get.snackbar('Success', 'Item deleted successfully');
//     } catch (e) {
//       print('Error deleting cart item: $e');
//       Get.snackbar('Error', 'Failed to delete item: $e');
//     }
//   }

//   int getTotalItemCount() {
//     int count = 0;
//     cartItems.forEach((category, products) {
//       count += products.length;
//     });
//     return count;
//   }

//   double getTotalPrice() {
//     double total = 0;
//     cartItems.forEach((category, products) {
//       total += products.fold(
//         0,
//         (sum, product) => sum + (product['total_price'] as double),
//       );
//     });
//     return total;
//   }

//   void clearCart() {
//     cartItems.clear();
//     cartItems.refresh();
//     cartItemCount.value = 0;
//     if (kDebugMode) {
//       print('Cart cleared');
//     }
//   }

//   Future<bool> placeOrder() async {
//     print('Placing order...');
//     await Future.delayed(const Duration(seconds: 2));
//     final random = Random();
//     bool success = random.nextDouble() < 0.7;
//     if (success) {
//       final order = {
//         'orderId': 'ORD${DateTime.now().millisecondsSinceEpoch}',
//         'date': DateTime.now(),
//         'items': Map<String, List<Map<String, dynamic>>>.from(cartItems),
//         'total': getTotalPrice(),
//         'trackingStatus': [
//           {'status': 'Order Placed', 'timestamp': DateTime.now()},
//           {
//             'status': 'Processing',
//             'timestamp': DateTime.now().add(const Duration(hours: 1)),
//           },
//           {
//             'status': 'Shipped',
//             'timestamp': DateTime.now().add(const Duration(days: 1)),
//           },
//           {
//             'status': 'Delivered',
//             'timestamp': DateTime.now().add(const Duration(days: 3)),
//           },
//         ],
//       };
//       orderHistory.add(order);
//       orderHistory.refresh();
//       if (kDebugMode) {
//         print('Order placed successfully: ${order['orderId']}');
//       }
//     } else {
//       if (kDebugMode) {
//         print('Order placement failed');
//       }
//     }
//     return success;
//   }

//   Map<String, dynamic>? getLatestOrder() {
//     if (orderHistory.isEmpty) return null;
//     return orderHistory.last;
//   }

//   void updateCartIcon() {
//     cartItemCount.refresh();
//   }
// }





















// import 'dart:math';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class CartController extends GetxController {
//   final RxMap<String, List<Map<String, dynamic>>> cartItems =
//       <String, List<Map<String, dynamic>>>{}.obs;
//   final RxList<Map<String, dynamic>> orderHistory =
//       <Map<String, dynamic>>[].obs;
//   final RxInt cartItemCount = 0.obs;

//   final supabase = Supabase.instance.client;


//   Future<void> addToCart(Map<String, dynamic> product, double weight) async {
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) {
//         throw Exception('User is not logged in.');
//       }

//       final productName = product['name'];
//       if (productName == null || productName.isEmpty) {
//         throw Exception('Product name is missing.');
//       }

//       final productResponse = await supabase
//           .from('products')
//           .select(
//             'price_0_5, price_6_25, price_26_50, price_51_100, price_100_above',
//           )
//           .eq('product_name', productName)
//           .maybeSingle();

//       if (productResponse == null) {
//         throw Exception('Product price details not found.');
//       }

//       double pricePerKg = 0.0;
//       if (weight <= 5) {
//         pricePerKg = productResponse['price_0_5'];
//       } else if (weight <= 25) {
//         pricePerKg = productResponse['price_6_25'];
//       } else if (weight <= 50) {
//         pricePerKg = productResponse['price_26_50'];
//       } else if (weight <= 100) {
//         pricePerKg = productResponse['price_51_100'];
//       } else {
//         pricePerKg = productResponse['price_100_above'];
//       }

//       final double totalPrice = pricePerKg * weight;

//       final cartData = {
//         'user_id': userId,
//         'product_name': productName,
//         'weight': weight,
//         'price': totalPrice,
//         'created_at': DateTime.now().toIso8601String(),
//       };

//       await supabase.from('carts').insert(cartData);

//       Get.snackbar(
//         'Success',
//         '$productName added to cart!',
//         snackPosition: SnackPosition.TOP,
//         duration: const Duration(seconds: 2),
//       );
//       cartItemCount.value += 1;
//       await fetchCartItems();
//     } catch (e) {
//       print('Error adding to cart: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to add item: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   Future<void> addProductToCart(
//     Map<String, dynamic> product,
//     double weight,
//   ) async {
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) {
//         throw Exception('User is not logged in.');
//       }

//       final existingProduct = await supabase
//           .from('carts')
//           .select('weight')
//           .eq('user_id', userId)
//           .eq('product_name', product['name'])
//           .maybeSingle();

//       if (existingProduct != null) {
//         final double existingWeight =
//             double.tryParse(existingProduct['weight'].toString()) ?? 0.0;
//         final double newWeight = existingWeight + weight;

//         await supabase
//             .from('carts')
//             .update({'weight': newWeight})
//             .match({'user_id': userId, 'product_name': product['name']});

//         Get.snackbar(
//           'Updated',
//           '${product['name']} weight updated!',
//           snackPosition: SnackPosition.TOP,
//           duration: const Duration(seconds: 2),
//         );
//       } else {
//         await supabase.from('carts').insert({
//           'user_id': userId,
//           'product_name': product['name'],
//           'weight': weight,
//           'price': product['price'],
//           'created_at': DateTime.now().toIso8601String(),
//         });

//         Get.snackbar(
//           'Success',
//           '${product['name']} added to cart!',
//           snackPosition: SnackPosition.TOP,
//           duration: const Duration(seconds: 2),
//         );
//       }

//       cartItemCount.value += 1;
//       await fetchCartItems();
//     } catch (e) {
//       print('Error adding to cart: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to add item: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   Future<void> removeFromCart(
//     String category,
//     Map<String, dynamic> product,
//   ) async {
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) {
//         Get.snackbar("Error", "User not logged in");
//         return;
//       }

//       await supabase.from('carts').delete().match({
//         'user_id': userId,
//         'product_name': product['name'],
//       });

//       if (cartItems.containsKey(category)) {
//         cartItems[category]!.remove(product);
//         if (cartItems[category]!.isEmpty) {
//           cartItems.remove(category);
//         }
//         cartItems.refresh();
//       }

//       cartItemCount.value =
//           cartItemCount.value > 0 ? cartItemCount.value - 1 : 0;
//       Get.snackbar(
//         'Removed',
//         '${product['name']} removed from cart',
//         snackPosition: SnackPosition.TOP,
//         duration: const Duration(seconds: 2),
//       );
//       await fetchCartItems();
//     } catch (error) {
//       Get.snackbar("Error", "Failed to remove item: $error");
//       print("Error removing from cart: $error");
//     }
//   }

//   Future<void> fetchCartItems() async {
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) {
//         throw Exception('User is not logged in.');
//       }

//       final List<dynamic> data = await supabase
//           .from('carts')
//           .select('cart_item_id, product_name, weight, price, created_at')
//           .eq('user_id', userId);

//       final Map<String, List<Map<String, dynamic>>> groupedItems = {};
//       for (final item in data) {
//         final category = item['category'] ?? 'Uncategorized';
//         if (!groupedItems.containsKey(category)) {
//           groupedItems[category] = [];
//         }

//         final productResponse = await supabase
//             .from('products')
//             .select(
//               'price_0_5, price_6_25, price_26_50, price_51_100, price_100_above',
//             )
//             .eq('product_name', item['product_name'])
//             .maybeSingle();

//         if (productResponse != null) {
//           final double weight =
//               double.tryParse(item['weight'].toString()) ?? 0.0;
//           double pricePerKg = 0.0;

//           if (weight <= 5) {
//             pricePerKg = productResponse['price_0_5'];
//           } else if (weight <= 25) {
//             pricePerKg = productResponse['price_6_25'];
//           } else if (weight <= 50) {
//             pricePerKg = productResponse['price_26_50'];
//           } else if (weight <= 100) {
//             pricePerKg = productResponse['price_51_100'];
//           } else {
//             pricePerKg = productResponse['price_100_above'];
//           }

//           final double totalPrice = pricePerKg * weight;

//           groupedItems[category]!.add({
//             ...item,
//             'price_per_kg': pricePerKg,
//             'total_price': totalPrice,
//           });
//         }
//       }

//       cartItems.value = groupedItems;
//       cartItemCount.value = getTotalItemCount();
//       cartItems.refresh();
//     } catch (e) {
//       print('Error fetching cart items: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to fetch cart items: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   Future<void> deleteCartItem(int cartItemId) async {
//     try {
//       await supabase.from('carts').delete().eq('cart_item_id', cartItemId);
//       cartItemCount.value =
//           cartItemCount.value > 0 ? cartItemCount.value - 1 : 0;
//       await fetchCartItems();
//       Get.snackbar(
//         'Success',
//         'Item deleted successfully',
//         snackPosition: SnackPosition.TOP,
//         duration: const Duration(seconds: 2),
//       );
//     } catch (e) {
//       print('Error deleting cart item: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to delete item: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   Future<void> clearCartInSupabase() async {
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) {
//         throw Exception('User is not logged in.');
//       }
//       await supabase.from('carts').delete().eq('user_id', userId);
//       clearCart();
//       Get.snackbar(
//         'Success',
//         'All items deleted successfully',
//         snackPosition: SnackPosition.TOP,
//         duration: const Duration(seconds: 2),
//       );
//     } catch (e) {
//       print('Error clearing cart in Supabase: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to clear cart: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   int getTotalItemCount() {
//     int count = 0;
//     cartItems.forEach((category, products) {
//       count += products.length;
//     });
//     return count;
//   }

//   double getTotalPrice() {
//     double total = 0;
//     cartItems.forEach((category, products) {
//       total += products.fold(
//         0,
//         (sum, product) => sum + (product['total_price'] as double),
//       );
//     });
//     return total;
//   }

//   void clearCart() {
//     cartItems.clear();
//     cartItemCount.value = 0;
//     cartItems.refresh();
//     if (kDebugMode) {
//       print('Cart cleared');
//     }
//   }

//   Future<bool> placeOrder({required String fullName, required String phoneNumber, required double subtotal, required double deliveryFee, required double total, required String paymentMethod, required String address, required double tax}) async {
//     print('Placing order...');
//     await Future.delayed(const Duration(seconds: 2));
//     final random = Random();
//     bool success = random.nextDouble() < 0.7;
//     if (success) {
//       final order = {
//         'orderId': 'ORD${DateTime.now().millisecondsSinceEpoch}',
//         'date': DateTime.now(),
//         'items': Map<String, List<Map<String, dynamic>>>.from(cartItems),
//         'total': getTotalPrice(),
//         'trackingStatus': [
//           {'status': 'Order Placed', 'timestamp': DateTime.now()},
//           {
//             'status': 'Processing',
//             'timestamp': DateTime.now().add(const Duration(hours: 1)),
//           },
//           {
//             'status': 'Shipped',
//             'timestamp': DateTime.now().add(const Duration(days: 1)),
//           },
//           {
//             'status': 'Delivered',
//             'timestamp': DateTime.now().add(const Duration(days: 3)),
//           },
//         ],
//       };
//       orderHistory.add(order);
//       orderHistory.refresh();
//       await clearCartInSupabase();
//       if (kDebugMode) {
//         print('Order placed successfully: ${order['orderId']}');
//       }
//     } else {
//       if (kDebugMode) {
//         print('Order placement failed');
//       }
//     }
//     return success;
//   }

//   Map<String, dynamic>? getLatestOrder() {
//     if (orderHistory.isEmpty) return null;
//     return orderHistory.last;
//   }

//   void updateCartIcon() {
//     cartItemCount.refresh();
//   }
// }







// import 'dart:math';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class CartController extends GetxController {
//   final RxMap<String, List<Map<String, dynamic>>> cartItems =
//       <String, List<Map<String, dynamic>>>{}.obs;
//   final RxList<Map<String, dynamic>> orderHistory =
//       <Map<String, dynamic>>[].obs;
//   final RxInt cartItemCount = 0.obs;

//   final supabase = Supabase.instance.client;

//   Future<void> addToCart(Map<String, dynamic> product, double weight) async {
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) {
//         throw Exception('User is not logged in.');
//       }

//       final productName = product['name'];
//       if (productName == null || productName.isEmpty) {
//         throw Exception('Product name is missing.');
//       }

//       final productResponse = await supabase
//           .from('products')
//           .select(
//             'price_0_5, price_6_25, price_26_50, price_51_100, price_100_above',
//           )
//           .eq('product_name', productName)
//           .maybeSingle();

//       if (productResponse == null) {
//         throw Exception('Product price details not found.');
//       }

//       double pricePerKg = 0.0;
//       if (weight <= 5) {
//         pricePerKg = productResponse['price_0_5'];
//       } else if (weight <= 25) {
//         pricePerKg = productResponse['price_6_25'];
//       } else if (weight <= 50) {
//         pricePerKg = productResponse['price_26_50'];
//       } else if (weight <= 100) {
//         pricePerKg = productResponse['price_51_100'];
//       } else {
//         pricePerKg = productResponse['price_100_above'];
//       }

//       final double totalPrice = pricePerKg * weight;

//       final cartData = {
//         'user_id': userId,
//         'product_name': productName,
//         'weight': weight,
//         'price': totalPrice,
//         'created_at': DateTime.now().toIso8601String(),
//       };

//       await supabase.from('carts').insert(cartData);

//       Get.snackbar(
//         'Success',
//         '$productName added to cart!',
//         snackPosition: SnackPosition.TOP,
//         duration: const Duration(seconds: 2),
//       );
//       cartItemCount.value += 1;
//       await fetchCartItems();
//     } catch (e) {
//       print('Error adding to cart: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to add item: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   Future<void> addProductToCart(
//     Map<String, dynamic> product,
//     double weight,
//   ) async {
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) {
//         throw Exception('User is not logged in.');
//       }

//       final existingProduct = await supabase
//           .from('carts')
//           .select('weight')
//           .eq('user_id', userId)
//           .eq('product_name', product['name'])
//           .maybeSingle();

//       if (existingProduct != null) {
//         final double existingWeight =
//             double.tryParse(existingProduct['weight'].toString()) ?? 0.0;
//         final double newWeight = existingWeight + weight;

//         await supabase
//             .from('carts')
//             .update({'weight': newWeight})
//             .match({'user_id': userId, 'product_name': product['name']});

//         Get.snackbar(
//           'Updated',
//           '${product['name']} weight updated!',
//           snackPosition: SnackPosition.TOP,
//           duration: const Duration(seconds: 2),
//         );
//       } else {
//         await supabase.from('carts').insert({
//           'user_id': userId,
//           'product_name': product['name'],
//           'weight': weight,
//           'price': product['price'],
//           'created_at': DateTime.now().toIso8601String(),
//         });

//         Get.snackbar(
//           'Success',
//           '${product['name']} added to cart!',
//           snackPosition: SnackPosition.TOP,
//           duration: const Duration(seconds: 2),
//         );
//       }

//       cartItemCount.value += 1;
//       await fetchCartItems();
//     } catch (e) {
//       print('Error adding to cart: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to add item: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   Future<void> removeFromCart(
//     String category,
//     Map<String, dynamic> product,
//   ) async {
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) {
//         Get.snackbar("Error", "User not logged in");
//         return;
//       }

//       await supabase.from('carts').delete().match({
//         'user_id': userId,
//         'product_name': product['name'],
//       });

//       if (cartItems.containsKey(category)) {
//         cartItems[category]!.remove(product);
//         if (cartItems[category]!.isEmpty) {
//           cartItems.remove(category);
//         }
//         cartItems.refresh();
//       }

//       cartItemCount.value =
//           cartItemCount.value > 0 ? cartItemCount.value - 1 : 0;
//       Get.snackbar(
//         'Removed',
//         '${product['name']} removed from cart',
//         snackPosition: SnackPosition.TOP,
//         duration: const Duration(seconds: 2),
//       );
//       await fetchCartItems();
//     } catch (error) {
//       Get.snackbar("Error", "Failed to remove item: $error");
//       print("Error removing from cart: $error");
//     }
//   }

//   Future<void> fetchCartItems() async {
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) {
//         throw Exception('User is not logged in.');
//       }

//       final List<dynamic> data = await supabase
//           .from('carts')
//           .select('cart_item_id, product_name, weight, price, created_at')
//           .eq('user_id', userId);

//       final Map<String, List<Map<String, dynamic>>> groupedItems = {};
//       for (final item in data) {
//         final category = item['category'] ?? 'Uncategorized';
//         if (!groupedItems.containsKey(category)) {
//           groupedItems[category] = [];
//         }

//         final productResponse = await supabase
//             .from('products')
//             .select(
//               'price_0_5, price_6_25, price_26_50, price_51_100, price_100_above',
//             )
//             .eq('product_name', item['product_name'])
//             .maybeSingle();

//         if (productResponse != null) {
//           final double weight =
//               double.tryParse(item['weight'].toString()) ?? 0.0;
//           double pricePerKg = 0.0;

//           if (weight <= 5) {
//             pricePerKg = productResponse['price_0_5'];
//           } else if (weight <= 25) {
//             pricePerKg = productResponse['price_6_25'];
//           } else if (weight <= 50) {
//             pricePerKg = productResponse['price_26_50'];
//           } else if (weight <= 100) {
//             pricePerKg = productResponse['price_51_100'];
//           } else {
//             pricePerKg = productResponse['price_100_above'];
//           }

//           final double totalPrice = pricePerKg * weight;

//           groupedItems[category]!.add({
//             ...item,
//             'price_per_kg': pricePerKg,
//             'total_price': totalPrice,
//           });
//         }
//       }

//       cartItems.value = groupedItems;
//       cartItemCount.value = getTotalItemCount();
//       cartItems.refresh();
//     } catch (e) {
//       print('Error fetching cart items: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to fetch cart items: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   Future<void> deleteCartItem(int cartItemId) async {
//     try {
//       await supabase.from('carts').delete().eq('cart_item_id', cartItemId);
//       cartItemCount.value =
//           cartItemCount.value > 0 ? cartItemCount.value - 1 : 0;
//       await fetchCartItems();
//       Get.snackbar(
//         'Success',
//         'Item deleted successfully',
//         snackPosition: SnackPosition.TOP,
//         duration: const Duration(seconds: 2),
//       );
//     } catch (e) {
//       print('Error deleting cart item: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to delete item: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   Future<void> clearCartInSupabase() async {
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) {
//         throw Exception('User is not logged in.');
//       }
//       await supabase.from('carts').delete().eq('user_id', userId);
//       clearCart();
//       Get.snackbar(
//         'Success',
//         'All items deleted successfully',
//         snackPosition: SnackPosition.TOP,
//         duration: const Duration(seconds: 2),
//       );
//     } catch (e) {
//       print('Error clearing cart in Supabase: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to clear cart: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   int getTotalItemCount() {
//     int count = 0;
//     cartItems.forEach((category, products) {
//       count += products.length;
//     });
//     return count;
//   }

//   double getTotalPrice() {
//     double total = 0;
//     cartItems.forEach((category, products) {
//       total += products.fold(
//         0,
//         (sum, product) => sum + (product['total_price'] as double),
//       );
//     });
//     return total;
//   }

//   void clearCart() {
//     cartItems.clear();
//     cartItemCount.value = 0;
//     cartItems.refresh();
//     if (kDebugMode) {
//       print('Cart cleared');
//     }
//   }

//   Future<bool> placeOrder({
//     required String fullName,
//     required String phoneNumber,
//     required double subtotal,
//     required double deliveryFee,
//     required double total,
//     required String paymentMethod,
//     required String address,
//     required double tax,
//   }) async {
//     print('Placing order...');
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) {
//         throw Exception('User is not logged in.');
//       }

//       // Step 1: Validate input data
//       if (fullName.isEmpty || phoneNumber.isEmpty || address.isEmpty) {
//         throw Exception('Full name, phone number, and address are required.');
//       }

//       // Step 2: Insert the order into the orders table with retry logic for schema cache
//       const maxRetries = 3;
//       for (int attempt = 1; attempt <= maxRetries; attempt++) {
//         try {
//           final orderResponse = await supabase.from('orders').insert({
//             'user_id': userId,
//             'full_name': fullName,
//             'phone_number': phoneNumber,
//             'address': address,
//             'subtotal': subtotal,
//             'tax': tax,
//             'delivery_fee': deliveryFee,
//             'total': total,
//             'payment_method': paymentMethod,
//             'status': 'Order Placed',
//           }).select('id').single();

//           final orderId = orderResponse['id'] as String?;
//           if (orderId == null) {
//             throw Exception('Failed to create order: No order ID returned.');
//           }

//           // Step 3: Insert each cart item into the order_items table
//           for (final entry in cartItems.entries) {
//             final products = entry.value;
//             for (final product in products) {
//               if (product['product_name'] == null ||
//                   product['weight'] == null ||
//                   product['total_price'] == null) {
//                 throw Exception('Invalid cart item data: Missing required fields.');
//               }
//               await supabase.from('order_items').insert({
//                 'order_id': orderId,
//                 'product_name': product['product_name'] as String,
//                 'weight': product['weight'] as num,
//                 'price': (product['price_per_kg'] as num?) ?? 0.0,
//                 'total_price': product['total_price'] as num,
//               });
//             }
//           }

//           // Step 4: Add to order history for UI purposes
//           final order = {
//             'orderId': 'ORD$orderId',
//             'date': DateTime.now(),
//             'items': Map<String, List<Map<String, dynamic>>>.from(cartItems),
//             'total': total,
//             'trackingStatus': [
//               {'status': 'Order Placed', 'timestamp': DateTime.now()},
//               {
//                 'status': 'Processing',
//                 'timestamp': DateTime.now().add(const Duration(hours: 1)),
//               },
//               {
//                 'status': 'Shipped',
//                 'timestamp': DateTime.now().add(const Duration(days: 1)),
//               },
//               {
//                 'status': 'Delivered',
//                 'timestamp': DateTime.now().add(const Duration(days: 3)),
//               },
//             ],
//           };
//           orderHistory.add(order);
//           orderHistory.refresh();

//           // Step 5: Clear the cart in Supabase
//           await clearCartInSupabase();

//           print('Order placed successfully: ORD$orderId');
//           return true;
//         } catch (e) {
//           if (e.toString().contains('PGRST204') && attempt < maxRetries) {
//             print('Schema cache error (attempt $attempt/$maxRetries): $e. Retrying...');
//             await Future.delayed(Duration(seconds: 1)); // Wait before retry
//             continue;
//           }
//           throw e; // Re-throw the exception if not a schema cache error or max retries reached
//         }
//       }
//       throw Exception('Failed to place order after $maxRetries attempts due to schema cache issue.');
//     } catch (e) {
//       print('Error placing order: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to place order: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return false;
//     }
//   }

//   Map<String, dynamic>? getLatestOrder() {
//     if (orderHistory.isEmpty) return null;
//     return orderHistory.last;
//   }

//   void updateCartIcon() {
//     cartItemCount.refresh();
//   }
// }





// import 'dart:math';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class CartController extends GetxController {
//   final RxMap<String, List<Map<String, dynamic>>> cartItems =
//       <String, List<Map<String, dynamic>>>{}.obs;
//   final RxList<Map<String, dynamic>> orderHistory =
//       <Map<String, dynamic>>[].obs;
//   final RxInt cartItemCount = 0.obs;

//   // Add a reactive list to track selected products
//   final RxList<Map<String, dynamic>> selectedProducts =
//       <Map<String, dynamic>>[].obs;

//   final supabase = Supabase.instance.client;

//   // Toggle selection for a single product
//   void toggleProductSelection(Map<String, dynamic> product) {
//     if (selectedProducts.contains(product)) {
//       selectedProducts.remove(product);
//     } else {
//       selectedProducts.add(product);
//     }
//     selectedProducts.refresh();
//   }

//   // Toggle selection for all products
//   void toggleSelectAll(bool isSelected) {
//     selectedProducts.clear();
//     if (isSelected) {
//       cartItems.forEach((category, products) {
//         selectedProducts.addAll(products);
//       });
//     }
//     selectedProducts.refresh();
//   }

//   // Check if all products are selected
//   bool areAllProductsSelected() {
//     int totalProducts = getTotalItemCount();
//     return selectedProducts.length == totalProducts && totalProducts > 0;
//   }

//   // Delete selected products
//   Future<void> deleteSelectedProducts() async {
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) {
//         throw Exception('User is not logged in.');
//       }

//       for (var product in selectedProducts) {
//         final cartItemId = product['cart_item_id'];
//         if (cartItemId != null) {
//           await supabase.from('carts').delete().eq('cart_item_id', cartItemId);
//         }
//       }

//       // Clear selected products and refresh cart
//       selectedProducts.clear();
//       await fetchCartItems();
//       Get.snackbar(
//         'Success',
//         'Selected items deleted successfully',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       print('Error deleting selected items: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to delete selected items: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   Future<void> addToCart(Map<String, dynamic> product, double weight) async {
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) {
//         throw Exception('User is not logged in.');
//       }

//       final productName = product['name'];
//       if (productName == null || productName.isEmpty) {
//         throw Exception('Product name is missing.');
//       }

//       final productResponse = await supabase
//           .from('products')
//           .select(
//             'price_0_5, price_6_25, price_26_50, price_51_100, price_100_above',
//           )
//           .eq('product_name', productName)
//           .maybeSingle();

//       if (productResponse == null) {
//         throw Exception('Product price details not found.');
//       }

//       double pricePerKg = 0.0;
//       if (weight <= 5) {
//         pricePerKg = productResponse['price_0_5'];
//       } else if (weight <= 25) {
//         pricePerKg = productResponse['price_6_25'];
//       } else if (weight <= 50) {
//         pricePerKg = productResponse['price_26_50'];
//       } else if (weight <= 100) {
//         pricePerKg = productResponse['price_51_100'];
//       } else {
//         pricePerKg = productResponse['price_100_above'];
//       }

//       final double totalPrice = pricePerKg * weight;

//       final cartData = {
//         'user_id': userId,
//         'product_name': productName,
//         'weight': weight,
//         'price': totalPrice,
//         'created_at': DateTime.now().toIso8601String(),
//       };

//       await supabase.from('carts').insert(cartData);

//       Get.snackbar(
//         'Success',
//         '$productName added to cart!',
//         snackPosition: SnackPosition.TOP,
//         duration: const Duration(seconds: 2),
//       );
//       cartItemCount.value += 1;
//       await fetchCartItems();
//     } catch (e) {
//       print('Error adding to cart: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to add item: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   Future<void> addProductToCart(
//     Map<String, dynamic> product,
//     double weight,
//   ) async {
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) {
//         throw Exception('User is not logged in.');
//       }

//       final existingProduct = await supabase
//           .from('carts')
//           .select('weight')
//           .eq('user_id', userId)
//           .eq('product_name', product['name'])
//           .maybeSingle();

//       if (existingProduct != null) {
//         final double existingWeight =
//             double.tryParse(existingProduct['weight'].toString()) ?? 0.0;
//         final double newWeight = existingWeight + weight;

//         await supabase
//             .from('carts')
//             .update({'weight': newWeight})
//             .match({'user_id': userId, 'product_name': product['name']});

//         Get.snackbar(
//           'Updated',
//           '${product['name']} weight updated!',
//           snackPosition: SnackPosition.TOP,
//           duration: const Duration(seconds: 2),
//         );
//       } else {
//         await supabase.from('carts').insert({
//           'user_id': userId,
//           'product_name': product['name'],
//           'weight': weight,
//           'price': product['price'],
//           'created_at': DateTime.now().toIso8601String(),
//         });

//         Get.snackbar(
//           'Success',
//           '${product['name']} added to cart!',
//           snackPosition: SnackPosition.TOP,
//           duration: const Duration(seconds: 2),
//         );
//       }

//       cartItemCount.value += 1;
//       await fetchCartItems();
//     } catch (e) {
//       print('Error adding to cart: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to add item: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   Future<void> removeFromCart(
//     String category,
//     Map<String, dynamic> product,
//   ) async {
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) {
//         Get.snackbar("Error", "User not logged in");
//         return;
//       }

//       await supabase.from('carts').delete().match({
//         'user_id': userId,
//         'product_name': product['name'],
//       });

//       if (cartItems.containsKey(category)) {
//         cartItems[category]!.remove(product);
//         if (cartItems[category]!.isEmpty) {
//           cartItems.remove(category);
//         }
//         cartItems.refresh();
//       }

//       cartItemCount.value =
//           cartItemCount.value > 0 ? cartItemCount.value - 1 : 0;
//       Get.snackbar(
//         'Removed',
//         '${product['name']} removed from cart',
//         snackPosition: SnackPosition.TOP,
//         duration: const Duration(seconds: 2),
//       );
//       await fetchCartItems();
//     } catch (error) {
//       Get.snackbar("Error", "Failed to remove item: $error");
//       print("Error removing from cart: $error");
//     }
//   }

//   Future<void> fetchCartItems() async {
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) {
//         throw Exception('User is not logged in.');
//       }

//       final List<dynamic> data = await supabase
//           .from('carts')
//           .select('cart_item_id, product_name, weight, price, created_at')
//           .eq('user_id', userId);

//       final Map<String, List<Map<String, dynamic>>> groupedItems = {};
//       for (final item in data) {
//         final category = item['category'] ?? 'Uncategorized';
//         if (!groupedItems.containsKey(category)) {
//           groupedItems[category] = [];
//         }

//         final productResponse = await supabase
//             .from('products')
//             .select(
//               'price_0_5, price_6_25, price_26_50, price_51_100, price_100_above',
//             )
//             .eq('product_name', item['product_name'])
//             .maybeSingle();

//         if (productResponse != null) {
//           final double weight =
//               double.tryParse(item['weight'].toString()) ?? 0.0;
//           double pricePerKg = 0.0;

//           if (weight <= 5) {
//             pricePerKg = productResponse['price_0_5'];
//           } else if (weight <= 25) {
//             pricePerKg = productResponse['price_6_25'];
//           } else if (weight <= 50) {
//             pricePerKg = productResponse['price_26_50'];
//           } else if (weight <= 100) {
//             pricePerKg = productResponse['price_51_100'];
//           } else {
//             pricePerKg = productResponse['price_100_above'];
//           }

//           final double totalPrice = pricePerKg * weight;

//           groupedItems[category]!.add({
//             ...item,
//             'price_per_kg': pricePerKg,
//             'total_price': totalPrice,
//           });
//         }
//       }

//       cartItems.value = groupedItems;
//       cartItemCount.value = getTotalItemCount();
//       cartItems.refresh();
//     } catch (e) {
//       print('Error fetching cart items: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to fetch cart items: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   Future<void> deleteCartItem(int cartItemId) async {
//     try {
//       await supabase.from('carts').delete().eq('cart_item_id', cartItemId);
//       cartItemCount.value =
//           cartItemCount.value > 0 ? cartItemCount.value - 1 : 0;
//       await fetchCartItems();
//       Get.snackbar(
//         'Success',
//         'Item deleted successfully',
//         snackPosition: SnackPosition.TOP,
//         duration: const Duration(seconds: 2),
//       );
//     } catch (e) {
//       print('Error deleting cart item: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to delete item: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   Future<void> clearCartInSupabase() async {
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) {
//         throw Exception('User is not logged in.');
//       }
//       await supabase.from('carts').delete().eq('user_id', userId);
//       clearCart();
//       Get.snackbar(
//         'Success',
//         'All items deleted successfully',
//         snackPosition: SnackPosition.TOP,
//         duration: const Duration(seconds: 2),
//       );
//     } catch (e) {
//       print('Error clearing cart in Supabase: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to clear cart: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   int getTotalItemCount() {
//     int count = 0;
//     cartItems.forEach((category, products) {
//       count += products.length;
//     });
//     return count;
//   }

//   double getTotalPrice() {
//     double total = 0;
//     cartItems.forEach((category, products) {
//       total += products.fold(
//         0,
//         (sum, product) => sum + (product['total_price'] as double),
//       );
//     });
//     return total;
//   }

//   // Calculate total price of selected products
//   double getSelectedTotalPrice() {
//     double total = 0;
//     for (var product in selectedProducts) {
//       total += product['total_price'] as double;
//     }
//     return total;
//   }

//   void clearCart() {
//     cartItems.clear();
//     selectedProducts.clear();
//     cartItemCount.value = 0;
//     cartItems.refresh();
//     selectedProducts.refresh();
//     if (kDebugMode) {
//       print('Cart cleared');
//     }
//   }

//   Future<bool> placeOrder({
//     required String fullName,
//     required String phoneNumber,
//     required double subtotal,
//     required double deliveryFee,
//     required double total,
//     required String paymentMethod,
//     required String address,
//     required double tax,
//   }) async {
//     print('Placing order...');
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) {
//         throw Exception('User is not logged in.');
//       }

//       if (fullName.isEmpty || phoneNumber.isEmpty || address.isEmpty) {
//         throw Exception('Full name, phone number, and address are required.');
//       }

//       const maxRetries = 3;
//       for (int attempt = 1; attempt <= maxRetries; attempt++) {
//         try {
//           final orderResponse = await supabase.from('orders').insert({
//             'user_id': userId,
//             'full_name': fullName,
//             'phone_number': phoneNumber,
//             'address': address,
//             'subtotal': subtotal,
//             'tax': tax,
//             'delivery_fee': deliveryFee,
//             'total': total,
//             'payment_method': paymentMethod,
//             'status': 'Order Placed',
//           }).select('id').single();

//           final orderId = orderResponse['id'] as String?;
//           if (orderId == null) {
//             throw Exception('Failed to create order: No order ID returned.');
//           }

//           for (final entry in cartItems.entries) {
//             final products = entry.value;
//             for (final product in products) {
//               if (product['product_name'] == null ||
//                   product['weight'] == null ||
//                   product['total_price'] == null) {
//                 throw Exception('Invalid cart item data: Missing required fields.');
//               }
//               await supabase.from('order_items').insert({
//                 'order_id': orderId,
//                 'product_name': product['product_name'] as String,
//                 'weight': product['weight'] as num,
//                 'price': (product['price_per_kg'] as num?) ?? 0.0,
//                 'total_price': product['total_price'] as num,
//               });
//             }
//           }

//           final order = {
//             'orderId': 'ORD$orderId',
//             'date': DateTime.now(),
//             'items': Map<String, List<Map<String, dynamic>>>.from(cartItems),
//             'total': total,
//             'trackingStatus': [
//               {'status': 'Order Placed', 'timestamp': DateTime.now()},
//               {
//                 'status': 'Processing',
//                 'timestamp': DateTime.now().add(const Duration(hours: 1)),
//               },
//               {
//                 'status': 'Shipped',
//                 'timestamp': DateTime

// .now().add(const Duration(days: 1)),
//               },
//               {
//                 'status': 'Delivered',
//                 'timestamp': DateTime.now().add(const Duration(days: 3)),
//               },
//             ],
//           };
//           orderHistory.add(order);
//           orderHistory.refresh();

//           await clearCartInSupabase();

//           print('Order placed successfully: ORD$orderId');
//           return true;
//         } catch (e) {
//           if (e.toString().contains('PGRST204') && attempt < maxRetries) {
//             print('Schema cache error (attempt $attempt/$maxRetries): $e. Retrying...');
//             await Future.delayed(Duration(seconds: 1));
//             continue;
//           }
//           throw e;
//         }
//       }
//       throw Exception('Failed to place order after $maxRetries attempts due to schema cache issue.');
//     } catch (e) {
//       print('Error placing order: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to place order: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return false;
//     }
//   }

//   Map<String, dynamic>? getLatestOrder() {
//     if (orderHistory.isEmpty) return null;
//     return orderHistory.last;
//   }

//   void updateCartIcon() {
//     cartItemCount.refresh();
//   }
// }


















// import 'dart:math';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class CartController extends GetxController {
//   final RxMap<String, List<Map<String, dynamic>>> cartItems =
//       <String, List<Map<String, dynamic>>>{}.obs;
//   final RxList<Map<String, dynamic>> orderHistory =
//       <Map<String, dynamic>>[].obs;
//   final RxInt cartItemCount = 0.obs;

//   // Reactive list to track selected products
//   final RxList<Map<String, dynamic>> selectedProducts =
//       <Map<String, dynamic>>[].obs;

//   final supabase = Supabase.instance.client;

//   get subtotal => null;

//   // Toggle selection for a single product
//   void toggleProductSelection(Map<String, dynamic> product) {
//     if (selectedProducts.contains(product)) {
//       selectedProducts.remove(product);
//     } else {
//       selectedProducts.add(product);
//     }
//     selectedProducts.refresh();
//   }

//   // Toggle selection for all products
//   void toggleSelectAll(bool isSelected) {
//     selectedProducts.clear();
//     if (isSelected) {
//       cartItems.forEach((category, products) {
//         selectedProducts.addAll(products);
//       });
//     }
//     selectedProducts.refresh();
//   }

//   // Check if all products are selected
//   bool areAllProductsSelected() {
//     int totalProducts = getTotalItemCount();
//     return selectedProducts.length == totalProducts && totalProducts > 0;
//   }

//   // Delete selected products
//   Future<void> deleteSelectedProducts() async {
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) {
//         throw Exception('User is not logged in.');
//       }

//       for (var product in selectedProducts) {
//         final cartItemId = product['cart_item_id'];
//         if (cartItemId != null) {
//           await supabase.from('carts').delete().eq('cart_item_id', cartItemId);
//         }
//       }

//       // Clear selected products and refresh cart
//       selectedProducts.clear();
//       await fetchCartItems();
//       Get.snackbar(
//         'Success',
//         'Selected items deleted successfully',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       print('Error deleting selected items: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to delete selected items: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   Future<void> addToCart(Map<String, dynamic> product, double weight) async {
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) {
//         throw Exception('User is not logged in.');
//       }

//       final productName = product['name'];
//       if (productName == null || productName.isEmpty) {
//         throw Exception('Product name is missing.');
//       }

//       final productResponse = await supabase
//           .from('products')
//           .select(
//             'price_0_5, price_6_25, price_26_50, price_51_100, price_100_above',
//           )
//           .eq('product_name', productName)
//           .maybeSingle();

//       if (productResponse == null) {
//         throw Exception('Product price details not found.');
//       }

//       double pricePerKg = 0.0;
//       if (weight <= 5) {
//         pricePerKg = productResponse['price_0_5'];
//       } else if (weight <= 25) {
//         pricePerKg = productResponse['price_6_25'];
//       } else if (weight <= 50) {
//         pricePerKg = productResponse['price_26_50'];
//       } else if (weight <= 100) {
//         pricePerKg = productResponse['price_51_100'];
//       } else {
//         pricePerKg = productResponse['price_100_above'];
//       }

//       final double totalPrice = pricePerKg * weight;

//       final cartData = {
//         'user_id': userId,
//         'product_name': productName,
//         'weight': weight,
//         'price': totalPrice,
//         'created_at': DateTime.now().toIso8601String(),
//       };

//       await supabase.from('carts').insert(cartData);

//       Get.snackbar(
//         'Success',
//         '$productName added to cart!',
//         snackPosition: SnackPosition.TOP,
//         duration: const Duration(seconds: 2),
//       );
//       cartItemCount.value += 1;
//       await fetchCartItems();
//     } catch (e) {
//       print('Error adding to cart: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to add item: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   Future<void> addProductToCart(
//     Map<String, dynamic> product,
//     double weight,
//   ) async {
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) {
//         throw Exception('User is not logged in.');
//       }

//       final existingProduct = await supabase
//           .from('carts')
//           .select('weight')
//           .eq('user_id', userId)
//           .eq('product_name', product['name'])
//           .maybeSingle();

//       if (existingProduct != null) {
//         final double existingWeight =
//             double.tryParse(existingProduct['weight'].toString()) ?? 0.0;
//         final double newWeight = existingWeight + weight;

//         await supabase
//             .from('carts')
//             .update({'weight': newWeight})
//             .match({'user_id': userId, 'product_name': product['name']});

//         Get.snackbar(
//           'Updated',
//           '${product['name']} weight updated!',
//           snackPosition: SnackPosition.TOP,
//           duration: const Duration(seconds: 2),
//         );
//       } else {
//         await supabase.from('carts').insert({
//           'user_id': userId,
//           'product_name': product['name'],
//           'weight': weight,
//           'price': product['price'],
//           'created_at': DateTime.now().toIso8601String(),
//         });

//         Get.snackbar(
//           'Success',
//           '${product['name']} added to cart!',
//           snackPosition: SnackPosition.TOP,
//           duration: const Duration(seconds: 2),
//         );
//       }

//       cartItemCount.value += 1;
//       await fetchCartItems();
//     } catch (e) {
//       print('Error adding to cart: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to add item: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   Future<void> removeFromCart(
//     String category,
//     Map<String, dynamic> product,
//   ) async {
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) {
//         Get.snackbar("Error", "User not logged in");
//         return;
//       }

//       await supabase.from('carts').delete().match({
//         'user_id': userId,
//         'product_name': product['name'],
//       });

//       if (cartItems.containsKey(category)) {
//         cartItems[category]!.remove(product);
//         if (cartItems[category]!.isEmpty) {
//           cartItems.remove(category);
//         }
//         cartItems.refresh();
//       }

//       cartItemCount.value =
//           cartItemCount.value > 0 ? cartItemCount.value - 1 : 0;
//       Get.snackbar(
//         'Removed',
//         '${product['name']} removed from cart',
//         snackPosition: SnackPosition.TOP,
//         duration: const Duration(seconds: 2),
//       );
//       await fetchCartItems();
//     } catch (error) {
//       Get.snackbar("Error", "Failed to remove item: $error");
//       print("Error removing from cart: $error");
//     }
//   }

//   Future<void> fetchCartItems() async {
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) {
//         throw Exception('User is not logged in.');
//       }

//       final List<dynamic> data = await supabase
//           .from('carts')
//           .select('cart_item_id, product_name, weight, price, created_at')
//           .eq('user_id', userId);

//       final Map<String, List<Map<String, dynamic>>> groupedItems = {};
//       for (final item in data) {
//         final category = item['category'] ?? 'Uncategorized';
//         if (!groupedItems.containsKey(category)) {
//           groupedItems[category] = [];
//         }

//         final productResponse = await supabase
//             .from('products')
//             .select(
//               'price_0_5, price_6_25, price_26_50, price_51_100, price_100_above',
//             )
//             .eq('product_name', item['product_name'])
//             .maybeSingle();

//         if (productResponse != null) {
//           final double weight =
//               double.tryParse(item['weight'].toString()) ?? 0.0;
//           double pricePerKg = 0.0;

//           if (weight <= 5) {
//             pricePerKg = productResponse['price_0_5'];
//           } else if (weight <= 25) {
//             pricePerKg = productResponse['price_6_25'];
//           } else if (weight <= 50) {
//             pricePerKg = productResponse['price_26_50'];
//           } else if (weight <= 100) {
//             pricePerKg = productResponse['price_51_100'];
//           } else {
//             pricePerKg = productResponse['price_100_above'];
//           }

//           final double totalPrice = pricePerKg * weight;

//           groupedItems[category]!.add({
//             ...item,
//             'price_per_kg': pricePerKg,
//             'total_price': totalPrice,
//           });
//         }
//       }

//       cartItems.value = groupedItems;
//       cartItemCount.value = getTotalItemCount();
//       cartItems.refresh();
//     } catch (e) {
//       print('Error fetching cart items: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to fetch cart items: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   Future<void> deleteCartItem(int cartItemId) async {
//     try {
//       await supabase.from('carts').delete().eq('cart_item_id', cartItemId);
//       cartItemCount.value =
//           cartItemCount.value > 0 ? cartItemCount.value - 1 : 0;
//       await fetchCartItems();
//       Get.snackbar(
//         'Success',
//         'Item deleted successfully',
//         snackPosition: SnackPosition.TOP,
//         duration: const Duration(seconds: 2),
//       );
//     } catch (e) {
//       print('Error deleting cart item: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to delete item: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   Future<void> clearCartInSupabase() async {
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) {
//         throw Exception('User is not logged in.');
//       }
//       await supabase.from('carts').delete().eq('user_id', userId);
//       clearCart();
//       Get.snackbar(
//         'Success',
//         'All items deleted successfully',
//         snackPosition: SnackPosition.TOP,
//         duration: const Duration(seconds: 2),
//       );
//     } catch (e) {
//       print('Error clearing cart in Supabase: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to clear cart: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   int getTotalItemCount() {
//     int count = 0;
//     cartItems.forEach((category, products) {
//       count += products.length;
//     });
//     return count;
//   }

//   double getTotalPrice() {
//     double total = 0;
//     cartItems.forEach((category, products) {
//       total += products.fold(
//         0,
//         (sum, product) => sum + (product['total_price'] as double),
//       );
//     });
//     return total;
//   }

//   // Calculate total price of selected products
//   double getSelectedTotalPrice() {
//     double total = 0;
//     for (var product in selectedProducts) {
//       total += product['total_price'] as double;
//     }
//     return total;
//   }

//   void clearCart() {
//     cartItems.clear();
//     selectedProducts.clear();
//     cartItemCount.value = 0;
//     cartItems.refresh();
//     selectedProducts.refresh();
//     if (kDebugMode) {
//       print('Cart cleared');
//     }
//   }

//   Future<bool> placeOrder({
//     required String fullName,
//     required String phoneNumber,
//     required double subtotal,
//     required double deliveryFee,
//     required double total,
//     required String paymentMethod,
//     required String address,
//     required double tax,
//   }) async {
//     print('Placing order...');
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) {
//         throw Exception('User is not logged in.');
//       }

//       if (fullName.isEmpty || phoneNumber.isEmpty || address.isEmpty) {
//         throw Exception('Full name, phone number, and address are required.');
//       }

//       const maxRetries = 3;
//       for (int attempt = 1; attempt <= maxRetries; attempt++) {
//         try {
//           final orderResponse = await supabase.from('orders').insert({
//             'user_id': userId,
//             'full_name': fullName,
//             'phone_number': phoneNumber,
//             'address': address,
//             'subtotal': subtotal,
//             'tax': tax,
//             'delivery_fee': deliveryFee,
//             'total': total,
//             'payment_method': paymentMethod,
//             'status': 'Order Placed',
//           }).select('id').single();

//           final orderId = orderResponse['id'] as String?;
//           if (orderId == null) {
//             throw Exception('Failed to create order: No order ID returned.');
//           }

//           // Insert only selected products into order_items
//           for (var product in selectedProducts) {
//             if (product['product_name'] == null ||
//                 product['weight'] == null ||
//                 product['total_price'] == null) {
//               throw Exception('Invalid cart item data: Missing required fields.');
//             }
//             await supabase.from('order_items').insert({
//               'order_id': orderId,
//               'product_name': product['product_name'] as String,
//               'weight': product['weight'] as num,
//               'price': (product['price_per_kg'] as num?) ?? 0.0,
//               'total_price': product['total_price'] as num,
//             });
//           }

//           final order = {
//             'orderId': 'ORD$orderId',
//             'date': DateTime.now(),
//             'items': {
//               'Selected': selectedProducts.toList(),
//             },
//             'total': total,
//             'trackingStatus': [
//               {'status': 'Order Placed', 'timestamp': DateTime.now()},
//               {
//                 'status': 'Processing',
//                 'timestamp': DateTime.now().add(const Duration(hours: 1)),
//               },
//               {
//                 'status': 'Shipped',
//                 'timestamp': DateTime.now().add(const Duration(days: 1)),
//               },
//               {
//                 'status': 'Delivered',
//                 'timestamp': DateTime.now().add(const Duration(days: 3)),
//               },
//             ],
//           };
//           orderHistory.add(order);
//           orderHistory.refresh();

//           // Clear only the selected products from the cart
//           for (var product in selectedProducts) {
//             final cartItemId = product['cart_item_id'];
//             if (cartItemId != null) {
//               await deleteCartItem(cartItemId);
//             }
//           }
//           selectedProducts.clear();

//           print('Order placed successfully: ORD$orderId');
//           return true;
//         } catch (e) {
//           if (e.toString().contains('PGRST204') && attempt < maxRetries) {
//             print('Schema cache error (attempt $attempt/$maxRetries): $e. Retrying...');
//             await Future.delayed(Duration(seconds: 1));
//             continue;
//           }
//           throw e;
//         }
//       }
//       throw Exception('Failed to place order after $maxRetries attempts due to schema cache issue.');
//     } catch (e) {
//       print('Error placing order: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to place order: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return false;
//     }
//   }

//   Map<String, dynamic>? getLatestOrder() {
//     if (orderHistory.isEmpty) return null;
//     return orderHistory.last;
//   }

//   void updateCartIcon() {
//     cartItemCount.refresh();
//   }

//   fetchOrders() {}

//   void removeProductFromCart(String category, Map<String, dynamic> product) {}

//   void updateSubtotal() {}
// }





import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:valuebuyin/controllers/order_controller.dart';

class CartController extends GetxController {
  final RxMap<String, List<Map<String, dynamic>>> cartItems =
      <String, List<Map<String, dynamic>>>{}.obs;
  final RxList<Map<String, dynamic>> orderHistory =
      <Map<String, dynamic>>[].obs;
  final RxInt cartItemCount = 0.obs;

  // Reactive list to track selected products
  final RxList<Map<String, dynamic>> selectedProducts =
      <Map<String, dynamic>>[].obs;

  final supabase = Supabase.instance.client;

  // Placeholder for subtotal (to be implemented based on your needs)
  get subtotal => null;

  // Toggle selection for a single product
  void toggleProductSelection(Map<String, dynamic> product) {
    if (selectedProducts.contains(product)) {
      selectedProducts.remove(product);
    } else {
      selectedProducts.add(product);
    }
    selectedProducts.refresh();
  }

  // Toggle selection for all products
  void toggleSelectAll(bool isSelected) {
    selectedProducts.clear();
    if (isSelected) {
      cartItems.forEach((category, products) {
        selectedProducts.addAll(products);
      });
    }
    selectedProducts.refresh();
  }

  // Check if all products are selected
  bool areAllProductsSelected() {
    int totalProducts = getTotalItemCount();
    return selectedProducts.length == totalProducts && totalProducts > 0;
  }

  // Delete selected products
  Future<void> deleteSelectedProducts() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User is not logged in.');
      }

      for (var product in selectedProducts) {
        final cartItemId = product['cart_item_id'];
        if (cartItemId != null) {
          await supabase.from('carts').delete().eq('cart_item_id', cartItemId);
        }
      }

      selectedProducts.clear();
      await fetchCartItems();
      Get.snackbar(
        'Success',
        'Selected items deleted successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error deleting selected items: $e');
      Get.snackbar(
        'Error',
        'Failed to delete selected items: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> addToCart(Map<String, dynamic> product, double weight) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User is not logged in.');
      }

      final productName = product['name'];
      if (productName == null || productName.isEmpty) {
        throw Exception('Product name is missing.');
      }

      final productResponse = await supabase
          .from('products')
          .select(
            'price_0_5, price_6_25, price_26_50, price_51_100, price_100_above',
          )
          .eq('product_name', productName)
          .maybeSingle();

      if (productResponse == null) {
        throw Exception('Product price details not found.');
      }

      double pricePerKg = 0.0;
      if (weight <= 5) {
        pricePerKg = productResponse['price_0_5'];
      } else if (weight <= 25) {
        pricePerKg = productResponse['price_6_25'];
      } else if (weight <= 50) {
        pricePerKg = productResponse['price_26_50'];
      } else if (weight <= 100) {
        pricePerKg = productResponse['price_51_100'];
      } else {
        pricePerKg = productResponse['price_100_above'];
      }

      final double totalPrice = pricePerKg * weight;

      final cartData = {
        'user_id': userId,
        'product_name': productName,
        'weight': weight,
        'price': totalPrice,
        'created_at': DateTime.now().toIso8601String(),
      };

      await supabase.from('carts').insert(cartData);

      Get.snackbar(
        'Success',
        '$productName added to cart!',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
      cartItemCount.value += 1;
      await fetchCartItems();
    } catch (e) {
      print('Error adding to cart: $e');
      Get.snackbar(
        'Error',
        'Failed to add item: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> addProductToCart(
    Map<String, dynamic> product,
    double weight,
  ) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User is not logged in.');
      }

      final existingProduct = await supabase
          .from('carts')
          .select('weight')
          .eq('user_id', userId)
          .eq('product_name', product['name'])
          .maybeSingle();

      if (existingProduct != null) {
        final double existingWeight =
            double.tryParse(existingProduct['weight'].toString()) ?? 0.0;
        final double newWeight = existingWeight + weight;

        await supabase
            .from('carts')
            .update({'weight': newWeight})
            .match({'user_id': userId, 'product_name': product['name']});

        Get.snackbar(
          'Updated',
          '${product['name']} weight updated!',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );
      } else {
        await supabase.from('carts').insert({
          'user_id': userId,
          'product_name': product['name'],
          'weight': weight,
          'price': product['price'],
          'created_at': DateTime.now().toIso8601String(),
        });

        Get.snackbar(
          'Success',
          '${product['name']} added to cart!',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );
      }

      cartItemCount.value += 1;
      await fetchCartItems();
    } catch (e) {
      print('Error adding to cart: $e');
      Get.snackbar(
        'Error',
        'Failed to add item: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> removeFromCart(
    String category,
    Map<String, dynamic> product,
  ) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        Get.snackbar("Error", "User not logged in");
        return;
      }

      await supabase.from('carts').delete().match({
        'user_id': userId,
        'product_name': product['name'],
      });

      if (cartItems.containsKey(category)) {
        cartItems[category]!.remove(product);
        if (cartItems[category]!.isEmpty) {
          cartItems.remove(category);
        }
        cartItems.refresh();
      }

      cartItemCount.value =
          cartItemCount.value > 0 ? cartItemCount.value - 1 : 0;
      Get.snackbar(
        'Removed',
        '${product['name']} removed from cart',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
      await fetchCartItems();
    } catch (error) {
      Get.snackbar("Error", "Failed to remove item: $error");
      print("Error removing from cart: $error");
    }
  }

  Future<void> fetchCartItems() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User is not logged in.');
      }

      final List<dynamic> data = await supabase
          .from('carts')
          .select('cart_item_id, product_name, weight, price, created_at')
          .eq('user_id', userId);

      final Map<String, List<Map<String, dynamic>>> groupedItems = {};
      for (final item in data) {
        final category = item['category'] ?? 'Uncategorized';
        if (!groupedItems.containsKey(category)) {
          groupedItems[category] = [];
        }

        final productResponse = await supabase
            .from('products')
            .select(
              'price_0_5, price_6_25, price_26_50, price_51_100, price_100_above',
            )
            .eq('product_name', item['product_name'])
            .maybeSingle();

        if (productResponse != null) {
          final double weight =
              double.tryParse(item['weight'].toString()) ?? 0.0;
          double pricePerKg = 0.0;

          if (weight <= 5) {
            pricePerKg = productResponse['price_0_5'];
          } else if (weight <= 25) {
            pricePerKg = productResponse['price_6_25'];
          } else if (weight <= 50) {
            pricePerKg = productResponse['price_26_50'];
          } else if (weight <= 100) {
            pricePerKg = productResponse['price_51_100'];
          } else {
            pricePerKg = productResponse['price_100_above'];
          }

          final double totalPrice = pricePerKg * weight;

          groupedItems[category]!.add({
            ...item,
            'price_per_kg': pricePerKg,
            'total_price': totalPrice,
          });
        }
      }

      cartItems.value = groupedItems;
      cartItemCount.value = getTotalItemCount();
      cartItems.refresh();
    } catch (e) {
      print('Error fetching cart items: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch cart items: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteCartItem(int cartItemId) async {
    try {
      await supabase.from('carts').delete().eq('cart_item_id', cartItemId);
      cartItemCount.value =
          cartItemCount.value > 0 ? cartItemCount.value - 1 : 0;
      await fetchCartItems();
      Get.snackbar(
        'Success',
        'Item deleted successfully',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('Error deleting cart item: $e');
      Get.snackbar(
        'Error',
        'Failed to delete item: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> clearCartInSupabase() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User is not logged in.');
      }
      await supabase.from('carts').delete().eq('user_id', userId);
      clearCart();
      Get.snackbar(
        'Success',
        'All items deleted successfully',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('Error clearing cart in Supabase: $e');
      Get.snackbar(
        'Error',
        'Failed to clear cart: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  int getTotalItemCount() {
    int count = 0;
    cartItems.forEach((category, products) {
      count += products.length;
    });
    return count;
  }

  double getTotalPrice() {
    double total = 0;
    cartItems.forEach((category, products) {
      total += products.fold(
        0,
        (sum, product) => sum + (product['total_price'] as double),
      );
    });
    return total;
  }

  double getSelectedTotalPrice() {
    double total = 0;
    for (var product in selectedProducts) {
      total += product['total_price'] as double;
    }
    return total;
  }

  void clearCart() {
    cartItems.clear();
    selectedProducts.clear();
    cartItemCount.value = 0;
    cartItems.refresh();
    selectedProducts.refresh();
    if (kDebugMode) {
      print('Cart cleared');
    }
  }

  Future<bool> placeOrder({
    required String fullName,
    required String phoneNumber,
    required double subtotal,
    required double deliveryFee,
    required double total,
    required String paymentMethod,
    required String address,
    required double tax,
  }) async {
    print('Placing order...');
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User is not logged in.');
      }

      if (fullName.isEmpty || phoneNumber.isEmpty || address.isEmpty) {
        throw Exception('Full name, phone number, and address are required.');
      }

      const maxRetries = 3;
      for (int attempt = 1; attempt <= maxRetries; attempt++) {
        try {
          final orderResponse = await supabase.from('orders').insert({
            'user_id': userId,
            'full_name': fullName,
            'phone_number': phoneNumber,
            'address': address,
            'subtotal': subtotal,
            'tax': tax,
            'delivery_fee': deliveryFee,
            'total': total,
            'payment_method': paymentMethod,
            'status': 'Order Placed',
          }).select('id').single();

          final orderId = orderResponse['id'] as String?;
          if (orderId == null) {
            throw Exception('Failed to create order: No order ID returned.');
          }

          // Insert order items
          for (var product in selectedProducts) {
            if (product['product_name'] == null ||
                product['weight'] == null ||
                product['total_price'] == null) {
              throw Exception('Invalid cart item data: Missing required fields.');
            }
            await supabase.from('order_items').insert({
              'order_id': orderId,
              'product_name': product['product_name'] as String,
              'weight': product['weight'] as num,
              'price': (product['price_per_kg'] as num?) ?? 0.0,
              'total_price': product['total_price'] as num,
            });
          }

          final order = {
            'orderId': 'ORD$orderId',
            'date': DateTime.now(),
            'items': {
              'Selected': selectedProducts.toList(),
            },
            'total': total,
            'trackingStatus': [
              {'status': 'Order Placed', 'timestamp': DateTime.now()},
              {
                'status': 'Processing',
                'timestamp': DateTime.now().add(const Duration(hours: 1)),
              },
              {
                'status': 'Shipped',
                'timestamp': DateTime.now().add(const Duration(days: 1)),
              },
              {
                'status': 'Delivered',
                'timestamp': DateTime.now().add(const Duration(days: 3)),
              },
            ],
          };
          orderHistory.add(order);
          orderHistory.refresh();

          // Clear only the selected products from the cart
          for (var product in selectedProducts) {
            final cartItemId = product['cart_item_id'];
            if (cartItemId != null) {
              await deleteCartItem(cartItemId);
            }
          }
          selectedProducts.clear();

          // Sync with order_status table using the original selectedProducts
          await Get.find<OrderController>().createOrder(
            orderNumber: 'ORD$orderId',
            amount: total,
            items: {'Selected': (order['items'] as Map<String, dynamic>)?['Selected']}, // Use the saved items
          );

          print('Order placed successfully: ORD$orderId');
          return true;
        } catch (e) {
          if (e.toString().contains('PGRST204') && attempt < maxRetries) {
            print('Schema cache error (attempt $attempt/$maxRetries): $e. Retrying...');
            await Future.delayed(Duration(seconds: 1));
            continue;
          }
          throw e;
        }
      }
      throw Exception('Failed to place order after $maxRetries attempts due to schema cache issue.');
    } catch (e) {
      print('Error placing order: $e');
      Get.snackbar(
        'Error',
        'Failed to place order: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  Map<String, dynamic>? getLatestOrder() {
    if (orderHistory.isEmpty) return null;
    return orderHistory.last;
  }

  void updateCartIcon() {
    cartItemCount.refresh();
  }

  fetchOrders() {}

  void removeProductFromCart(String category, Map<String, dynamic> product) {}

  void updateSubtotal() {}
}