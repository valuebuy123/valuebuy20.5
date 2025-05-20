
class Product {
  final String id;
  final String title;
  final String description;
  final String name;
  final double price;
  final String image_url;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.name,
    required this.price,
    required this.image_url,
  });

  get weight => null;

  double getPriceForWeight(double weight) {
    if (weight <= 5) {
      return price;
    } else if (weight <= 25) {
      return price * 0.95; // 5% discount
    } else if (weight <= 50) {
      return price * 0.90; // 10% discount
    } else if (weight <= 100) {
      return price * 0.85; // 15% discount
    } else {
      return price * 0.80; // 20% discount
    }
  }
}