class Order {
  final String orderNumber;
  final String date;
  final double amount;
  final String status; // e.g., "Delivered", "Packing", "Shipped", "Received"

  Order({
    required this.orderNumber,
    required this.date,
    required this.amount,
    required this.status,
  });
}