import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:valuebuyin/nav_bar.dart';
import 'package:valuebuyin/pages/cart/cart_controller.dart';
import 'package:valuebuyin/pages/cart/cart_page.dart';
import 'package:valuebuyin/pages/product_detail_page.dart' as productDetail;
import 'package:valuebuyin/widgets/product_card.dart';
import 'package:valuebuyin/supabase_client.dart'; // This file must export your initialized SupabaseClient as "supabase"

class ProductGridScreen extends StatelessWidget {
  const ProductGridScreen({super.key});

  // Fetch products from your Supabase SQL table.k
  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final response = await supabase.from('products').select();

    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = (screenWidth / 180).floor();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Store - All Products',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart, color: Colors.teal),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartPage()),
                    );
                  },
                ),
                Obx(() {
                  int itemCount = cartController.getTotalItemCount();
                  return itemCount > 0
                      ? Positioned(
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$itemCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                      : const SizedBox.shrink();
                }),
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          // While the connection is waiting or active, show a loading indicator:
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // If there is an error:
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // When data is available:
          if (snapshot.hasData) {
            final products = snapshot.data!;
            if (products.isEmpty) {
              return const Center(child: Text('No products available'));
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount < 2 ? 2 : crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.73,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(
                    // Assuming the image field is a URL.
                    image: product['image_url'] ?? '',
                    name: product['product_name'] ?? '',
                    weight: product['weight'] ?? '',
                    price_0_5: product['price_0_5'] ?? 0.0,
                    price_6_25: product['price_6_25'] ?? 0.0,
                    price_26_50: product['price_26_50'] ?? 0.0,
                    price_51_100: product['price_51_100'] ?? 0.0,
                    price_100_above: product['price_100_above'] ?? 0.0,
                    image_url:
                        '', // Not used, can be removed if ProductCard doesn't require it.
                    category: product['category'] ?? '',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => productDetail.ProductDetailPage(
                                image: product['image_url'] ?? '',
                                name: product['product_name'] ?? '',
                                weight: product['weight'] ?? '',
                                price: (product['price_0_5']) ?? 0.0,
                                description:
                                    product['description'] ??
                                    'No description available',
                                category: product['category'] ?? '',
                                products: products,
                                currentIndex: index,
                                parentIndex: index, // Added required parameter
                              ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }
          return const Center(child: Text('No data available'));
        },
      ),
      bottomNavigationBar: NavigationMenu(currentIndex: 1, onTap: (index) {  },),
    );
  }
}
