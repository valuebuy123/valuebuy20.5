import 'package:flutter/material.dart';
import 'package:valuebuyin/main.dart';
// import 'package:get/get.dart';
import 'package:valuebuyin/nav_bar.dart';
// import 'package:valuebuyin/pages/cart/cart_controller.dart';
import 'package:valuebuyin/pages/orderpage.dart';
import 'package:valuebuyin/pages/profile_page.dart';

class OrderStatusPage extends StatelessWidget {
  final bool isSuccess;
  final VoidCallback? onTryAgain;

  const OrderStatusPage({required this.isSuccess, this.onTryAgain, super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    // final CartController cartController = Get.find<CartController>();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              isSuccess
                  ? 'lib/assets/1024.png'
                  : 'lib/assets/images/salt.png',
              height: screenHeight * 0.3,
              errorBuilder:
                  (context, error, stackTrace) =>
                      const Icon(Icons.error, size: 100),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              isSuccess
                  ? 'Your Order Has Been Accepted'
                  : 'Oops! Order Failed!',
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              isSuccess
                  ? 'We’ve accepted your order, and we’re getting it ready.'
                  : 'Something went terribly wrong.',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.03),
            ElevatedButton(
              onPressed:
                  isSuccess
                      ? () async {
                        print('Track Order button pressed');
                        await Future.delayed(const Duration(milliseconds: 500));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => const orderpage(products: []),
                          ),
                        );
                      }
                      : onTryAgain,
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
                isSuccess ? 'Track Order' : 'Try Again',
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            OutlinedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NavigationMenu(currentIndex: 0, onTap: (index) {  },),
                  ),
                  (route) => false,
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.orangeAccent.shade700),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.1,
                  vertical: screenHeight * 0.02,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Back Home',
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  color: Colors.orangeAccent[700],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationMenu(
        currentIndex: 2,
        onTap: (index) {
          // Handle navigation tap
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => NavigationMenu(currentIndex: index, onTap: (index) {  },),
            ),
            (route) => false,
          );
        },
      ),
    );
  }
}

class orderpage extends StatelessWidget {
  final List products;

  const orderpage({required this.products, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Page'),
      ),
      body: Center(
        child: Text('Products: ${products.length}'),
      ),
    );
  }
}
