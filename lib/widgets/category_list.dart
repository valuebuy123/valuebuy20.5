import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:valuebuyin/pages/product_detail_page.dart';
import 'package:valuebuyin/widgets/product_card.dart';

class CategoryList extends StatefulWidget {
  final String category;

  const CategoryList({required this.category, super.key});

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  late Future<List<Map<String, dynamic>>> productsFuture;

  @override
  void initState() {
    super.initState();
    productsFuture = fetchProductsByCategory(
      widget.category,
    ); // Fetch products by category
  }

  Future<List<Map<String, dynamic>>> fetchProductsByCategory(
    String category,
  ) async {
    try {
      final response = await Supabase.instance.client
          .from('products') // Replace 'products' with your table name
          .select(
            'product_name, weight, price_0_5, price_6_25, price_26_50, price_51_100, price_100_above, image_url, description, category',
          ) // Specify the fields you need
          .eq('category', category);

      // Convert the response to a list of maps
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  double getPriceForWeight(Map<String, dynamic> product, double weight) {
    if (weight <= 5) {
      return product['price_0_5'] ?? 0.0;
    } else if (weight <= 25) {
      return product['price_6_25'] ?? 0.0;
    } else if (weight <= 50) {
      return product['price_26_50'] ?? 0.0;
    } else if (weight <= 100) {
      return product['price_51_100'] ?? 0.0;
    } else {
      return product['price_100_above'] ?? 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = (screenWidth / 180).floor();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products available'));
          }

          final products = snapshot.data!;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount < 2 ? 2 : crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.73,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final weight =
                  double.tryParse(product['weight'].toString()) ?? 0.0;
              final price = getPriceForWeight(product, weight);

              return ProductCard(
                image: product['image_url'] ?? '',
                image_url: product['image_url'] ?? '',
                name: product['product_name'] ?? '',
                weight: product['weight'] ?? '',
                price_0_5: product['price_0_5'] ?? 0.0,
                price_6_25: product['price_6_25'] ?? 0.0,
                price_26_50: product['price_26_50'] ?? 0.0,
                price_51_100: product['price_51_100'] ?? 0.0,
                price_100_above: product['price_100_above'] ?? 0.0,
                category: product['category'] ?? '',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ProductDetailPage(
                            image: product['image_url'] ?? '',
                            name: product['product_name'] ?? '',
                            weight: product['weight'] ?? '',
                            price: price,
                            category: product['category'] ?? '',
                            description:
                                product['description'] ??
                                'No description available',
                            products: products,
                            currentIndex: index,
                            parentIndex: index, // Added the required parameter
                          ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
