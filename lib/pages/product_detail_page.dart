import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Assuming you're using GetX for state management
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:valuebuyin/nav_bar.dart';
import 'package:valuebuyin/pages/cart/cart_controller.dart'; // Import your CartController

Future<List<Map<String, dynamic>>> fetchProducts() async {
  try {
    final response = await Supabase.instance.client
        .from('products') // Replace 'products' with your table name
        .select(
          'product_name, description, price_0_5, image_url, weight, category',
        );

    if (response == null || response.isEmpty) {
      throw Exception('No products found');
    }

    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
    throw Exception('Failed to fetch products: $e');
  }
}

class ProductDetailPage extends StatefulWidget {
  final String image;
  final String name;
  final String weight;
  final double price; // Base price per unit
  final String category;
  final String description;
  final List<Map<String, dynamic>> products;
  final int currentIndex;

  const ProductDetailPage({
    required this.image,
    required this.name,
    // required this.weight,
    required this.price,
    required this.category,
    required this.description,
    required this.products,
    required this.currentIndex,
    super.key,
    required this.weight,
    required int parentIndex,
  });

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final CartController cartController = Get.find<CartController>();
  final TextEditingController weightController = TextEditingController();
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    weightController.text = widget.weight; // Set default weight
    totalPrice = widget.price; // Set default total price
  }

  /// Determines the correct price column based on the entered weight.
  double getPriceForWeight(double weight) {
    final product = widget.products[widget.currentIndex];
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

  /// Updates the total price based on the entered weight.
  void updateTotalPrice() {
    final enteredWeight = double.tryParse(weightController.text) ?? 0.0;
    final pricePerUnit = getPriceForWeight(enteredWeight);
    setState(() {
      totalPrice = enteredWeight * pricePerUnit; // Calculate total price
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.orangeAccent[700]),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                widget.image,
                height: screenHeight * 0.3,
                fit: BoxFit.contain,
                errorBuilder:
                    (context, error, stackTrace) =>
                        const Icon(Icons.error, size: 150),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              widget.name,
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent[700],
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Row(
              children: [
                Text(
                  'Price: Rs.${widget.price.toStringAsFixed(2)} / ',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    color: Colors.black54,
                  ),
                ),
                const Text(
                  'kg',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            Row(
              children: [
                Text(
                  'Enter Weight: ',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.2,
                  child: TextField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02,
                        vertical: screenHeight * 0.01,
                      ),
                      hintText: 'Weight',
                    ),
                    onChanged: (value) {
                      updateTotalPrice(); // Update total price when weight changes
                    },
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  'kg',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Total Price: Rs.${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent[700],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Text(
              widget.description,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final enteredWeight =
                      double.tryParse(weightController.text.trim()) ?? 0.0;
                  if (enteredWeight <= 0) {
                    Get.snackbar(
                      'Invalid Weight',
                      'Please enter a valid weight greater than 0.',
                      snackPosition: SnackPosition.TOP,
                      duration: const Duration(seconds: 2),
                    );
                    return;
                  }

                  final product = {
                    'name': widget.name, // Pass the product name
                  };

                  // Call the addToCart function from CartController
                  cartController.addToCart(product, enteredWeight);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent[700],
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.1,
                    vertical: screenHeight * 0.02,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Add to Cart',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationMenu(currentIndex: 1, onTap: (index) {  },),
    );
  }
}
