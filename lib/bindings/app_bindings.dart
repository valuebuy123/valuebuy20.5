import 'package:get/get.dart';
import 'package:valuebuyin/controllers/address_controller.dart';
import 'package:valuebuyin/pages/cart/cart_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddressController>(() => AddressController());
    Get.lazyPut<ProductController>(() => ProductController());
    Get.lazyPut<CartController>(() => CartController());
    print('AppBindings initialized: AddressController, CartController, ProductController');
  }
}

class ProductController {
}