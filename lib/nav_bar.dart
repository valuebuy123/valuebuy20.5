import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:valuebuyin/main.dart' show HomeScreen, OrdersPage;
import 'package:valuebuyin/pages/product_grid_screen.dart';
import 'package:valuebuyin/pages/profile_page.dart';

class NavigationMenu extends StatelessWidget {
  final int currentIndex;

  const NavigationMenu({required this.currentIndex, super.key, required Null Function(dynamic index) onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == 0 && currentIndex != 0) {
          Get.offAll(() => const HomeScreen());
        } else if (index == 1 && currentIndex != 1) {
          Get.offAll(() => const ProductGridScreen()); // Navigate to StorePage
        } else if (index == 2 && currentIndex != 2) {
          Get.offAll(() => const OrdersPage(products: []));
        } else if (index == 3 && currentIndex != 3) {
          Get.offAll(() => const ProfilePage());
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.orangeAccent[700],
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Store'),
        BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Order'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
