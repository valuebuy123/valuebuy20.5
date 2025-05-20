import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:valuebuyin/pages/cart/cart_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Import your ProductCard widget

Future<List<Map<String, dynamic>>> fetchProducts() async {
  try {
    final response =
        await Supabase.instance.client
            .from('products') // Replace 'products' with your table name
            .select();

    // Check if the response is empty
    if (response == null || response.isEmpty) {
      throw Exception('No products found');
    }

    // Convert the response to a list of maps
    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
    throw Exception('Failed to fetch products: $e');
  }
}

class ProductCard extends StatelessWidget {
  final String image;
  final String name;
  final String weight;
  final double price_0_5;
  final double price_6_25;
  final double price_26_50;
  final double price_51_100;
  final double price_100_above;
  final String image_url;
  final String category;
  final VoidCallback? onTap;

  const ProductCard({
    required this.image,
    required this.name,
    required this.weight,
    required this.price_0_5,
    required this.price_6_25,
    required this.price_26_50,
    required this.price_51_100,
    required this.price_100_above,
    required this.image_url,
    required this.category,
    this.onTap,
    super.key,
  });

  /// Determines the correct price based on the weight.
  double getPriceForWeight(double weight) {
    if (weight <= 5) {
      return price_0_5;
    } else if (weight <= 25) {
      return price_6_25;
    } else if (weight <= 50) {
      return price_26_50;
    } else if (weight <= 100) {
      return price_51_100;
    } else {
      return price_100_above;
    }
  }

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    final double screenWidth = MediaQuery.of(context).size.width;

    // Parse weight to double
    final double parsedWeight = double.tryParse(weight) ?? 0.0;
    final double price = getPriceForWeight(parsedWeight);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: Image.network(
                image,
                height: screenWidth * 0.3,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: screenWidth * 0.3,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 50,
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: screenWidth * 0.01),
                  Text(
                    'Weight: $weight kg',
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rs.${price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.orangeAccent[700],
                        ),
                      ),
                      // IconButton(
                      //   icon: Icon(
                      //     Icons.add_shopping_cart,
                      //     color: Colors.orangeAccent[700],
                      //   ),
                      //   onPressed: () {
                      //     cartController.addToCart({
                      //       'category': category,
                      //       'image': image,
                      //       'name': name,
                      //       'weight': weight,
                      //       'price': price,
                      //       'weight': 1,
                      //     }, 1); // Added the second positional argument
                      //     Get.snackbar(
                      //       'Added',
                      //       '$name added to cart',
                      //       snackPosition: SnackPosition.TOP,
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class ProductListPage extends StatefulWidget {
//   const ProductListPage({Key? key}) : super(key: key);

//   @override
//   _ProductListPageState createState() => _ProductListPageState();
// }

// class _ProductListPageState extends State<ProductListPage> {
//   late Future<List<Map<String, dynamic>>> productsFuture;

//   @override
//   void initState() {
//     super.initState();
//     productsFuture = fetchProducts(); // Fetch products from the database
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Products'),
//         backgroundColor: Colors.orangeAccent[700],
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: productsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No products found.'));
//           }

//           final products = snapshot.data!;
//           return ListView.builder(
//             itemCount: products.length,
//             itemBuilder: (context, index) {
//               final product = products[index];
//               return ProductCard(
//                 image: product['image_url'] ?? '',
//                 name: product['product_name'] ?? '',
//                 weight: product['weight'] ?? '',
//                 price_0_5: product['price_0_5'] ?? 0.0,
//                 price_6_25: product['price_6_25'] ?? 0.0,
//                 price_26_50: product['price_26_50'] ?? 0.0,
//                 price_51_100: product['price_51_100'] ?? 0.0,
//                 price_100_above: product['price_100_above'] ?? 0.0,
//                 image_url: product['image_url'] ?? '',
//                 category: product['category'] ?? '',
//                 onTap: () {
//                   // Navigate to product detail page or perform another action
//                   Get.snackbar('Product Selected', product['product_name']);
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
