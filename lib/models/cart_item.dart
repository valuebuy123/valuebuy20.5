import 'package:valuebuyin/pages/product.dart';

class CartItem {
  final Product product;
  int weight;

  CartItem({required this.product, this.weight = 1});
}
