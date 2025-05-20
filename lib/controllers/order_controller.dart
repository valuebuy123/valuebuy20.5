// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:valuebuyin/nav_bar.dart';

// class OrdersPage extends StatefulWidget {
//   const OrdersPage({super.key, required this.products});

//   final List products;

//   @override
//   _OrdersPageState createState() => _OrdersPageState();
// }

// class _OrdersPageState extends State<OrdersPage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final OrderController orderController = Get.find<OrderController>();
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.orangeAccent[700]),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Orders',
//           style: TextStyle(color: Colors.black, fontSize: 20),
//         ),
//         centerTitle: true,
//         bottom: TabBar(
//           controller: _tabController,
//           indicatorColor: Colors.orangeAccent[700],
//           labelColor: Colors.orangeAccent[700],
//           unselectedLabelColor: Colors.grey,
//           tabs: const [Tab(text: 'Ongoing'), Tab(text: 'History')],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           Obx(() {
//             if (orderController.ongoingOrders.isEmpty) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image.network(
//                       'lib/assets/images/cat_in_box.png',
//                       height: screenHeight * 0.2,
//                       errorBuilder: (context, error, stackTrace) {
//                         print(
//                           'Error loading empty state image in OrdersPage (Ongoing): $error',
//                         );
//                         return const Icon(Icons.error, size: 100);
//                       },
//                     ),
//                     SizedBox(height: screenHeight * 0.02),
//                     Text(
//                       'There is no ongoing order right now.\nYou can order from home',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: screenWidth * 0.04,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }
//             return ListView.builder(
//               padding: EdgeInsets.all(screenWidth * 0.04),
//               itemCount: orderController.ongoingOrders.length,
//               itemBuilder: (context, index) {
//                 final order = orderController.ongoingOrders[index];
//                 final canCancel = orderController.canCancelOrder(order);
//                 final items =
//                     order['items'] as Map<String, List<Map<String, dynamic>>>;

//                 return Card(
//                   elevation: 2,
//                   margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
//                   child: Padding(
//                     padding: EdgeInsets.all(screenWidth * 0.04),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Order ${order['orderNumber']}',
//                               style: TextStyle(
//                                 fontSize: screenWidth * 0.04,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text(
//                               order['date'],
//                               style: TextStyle(
//                                 fontSize: screenWidth * 0.035,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: screenHeight * 0.01),
//                         Text(
//                           'Rs.${order['amount'].toStringAsFixed(2)}',
//                           style: TextStyle(
//                             fontSize: screenWidth * 0.04,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.orangeAccent[700],
//                           ),
//                         ),
//                         SizedBox(height: screenHeight * 0.01),
//                         ...items.keys.map((category) {
//                           final products = items[category]!;
//                           return Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 category,
//                                 style: TextStyle(
//                                   fontSize: screenWidth * 0.035,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               ...products.map((product) {
//                                 return ListTile(
//                                   leading: ClipRRect(
//                                     borderRadius: BorderRadius.circular(8.0),
//                                     child: Image.network(
//                                       product['image'],
//                                       width: screenWidth * 0.1,
//                                       height: screenWidth * 0.1,
//                                       fit: BoxFit.cover,
//                                       errorBuilder: (
//                                         context,
//                                         error,
//                                         stackTrace,
//                                       ) {
//                                         print(
//                                           'Error loading image in OrdersPage: ${product['image']}, Error: $error',
//                                         );
//                                         return Image.network(
//                                           'lib/assets/images/placeholder.png',
//                                           width: screenWidth * 0.1,
//                                           height: screenWidth * 0.1,
//                                           fit: BoxFit.cover,
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                   title: Text(
//                                     product['name'],
//                                     style: TextStyle(
//                                       fontSize: screenWidth * 0.035,
//                                     ),
//                                   ),
//                                   subtitle: Text(
//                                     'Qty: ${product['weight']}',
//                                     style: TextStyle(
//                                       fontSize: screenWidth * 0.03,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                 );
//                               }),
//                             ],
//                           );
//                         }),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }),
//         ],
//       ),
//       bottomNavigationBar: NavigationMenu(currentIndex: 2, onTap: (index) {  },),
//     );
//   }
// }

// class OrderController extends GetxController {
//   final RxList<Map<String, dynamic>> ongoingOrders =
//       <Map<String, dynamic>>[].obs;
//   final RxList<Map<String, dynamic>> orderHistory =
//       <Map<String, dynamic>>[].obs;

//   void addOrderFromCart(Map<String, dynamic> order) {
//     final formattedOrder = {
//       'orderNumber': order['orderId'],
//       'date': order['date'].toString().split('.')[0],
//       'amount': order['total'],
//       'status': 'Order Placed',
//       'trackingStatus': order['trackingStatus'],
//       'items': order['items'],
//     };
//     ongoingOrders.add(formattedOrder);
//   }

//   bool canCancelOrder(Map<String, dynamic> order) {
//     final latestStatus = order['trackingStatus'].last['status'];
//     return latestStatus == 'Order Placed' || latestStatus == 'Processing';
//   }

//   void cancelOrder(Map<String, dynamic> order) {
//     final index = ongoingOrders.indexOf(order);
//     if (index != -1) {
//       final canceledOrder = Map<String, dynamic>.from(ongoingOrders[index]);
//       canceledOrder['status'] = 'Canceled';
//       ongoingOrders.removeAt(index);
//       orderHistory.add(canceledOrder);
//       Get.snackbar(
//         'Order Canceled',
//         'Order ${canceledOrder['orderNumber']} has been canceled.',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }

//   void updateOrderStatus(Map<String, dynamic> order, String newStatus) {
//     final index = ongoingOrders.indexOf(order);
//     if (index != -1) {
//       ongoingOrders[index]['status'] = newStatus;
//       ongoingOrders[index]['trackingStatus'].add({
//         'status': newStatus,
//         'timestamp': DateTime.now(),
//       });
//       if (newStatus == 'Delivered') {
//         final completedOrder = Map<String, dynamic>.from(ongoingOrders[index]);
//         ongoingOrders.removeAt(index);
//         orderHistory.add(completedOrder);
//       }
//       ongoingOrders.refresh();
//     }
//   }
// }








import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderController extends GetxController {
  final supabase = Supabase.instance.client;
  var ongoingOrders = <Map<String, dynamic>>[].obs;
  var orderHistory = <Map<String, dynamic>>[].obs;

  get isLoading => null;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      // Fetch ongoing orders
      final ongoingResponse = await supabase
          .from('order_status')
          .select()
          .inFilter('status', ['Pending', 'Processing', 'Shipped']);
      ongoingOrders.assignAll(ongoingResponse.cast<Map<String, dynamic>>());

      // Fetch order history
      final historyResponse = await supabase
          .from('order_status')
          .select()
          .inFilter('status', ['Delivered', 'Canceled']);
      orderHistory.assignAll(historyResponse.cast<Map<String, dynamic>>());
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  bool canCancelOrder(Map<String, dynamic> order) {
    return order['can_cancel'] ?? false;
  }

  Future<void> cancelOrder(Map<String, dynamic> order) async {
    try {
      await supabase
          .from('order_status')
          .update({
            'status': 'Canceled',
            'can_cancel': false,
            'tracking_status': [
              ...order['tracking_status'],
              {
                'status': 'Canceled',
                'timestamp': DateTime.now().toIso8601String(),
              }
            ]
          })
          .eq('id', order['id']);
      await fetchOrders();
    } catch (e) {
      print('Error canceling order: $e');
    }
  }

  Future<void> createOrder({
    required String orderNumber,
    required double amount,
    required Map<String, List<Map<String, dynamic>>> items,
  }) async {
    try {
      await supabase.from('order_status').insert({
        'order_number': orderNumber,
        'amount': amount,
        'status': 'Pending',
        'items': items,
        'tracking_status': [
          {
            'status': 'Pending',
            'timestamp': DateTime.now().toIso8601String(),
          }
        ],
        'can_cancel': true,
      });
      print('Order stored: $orderNumber');
      await fetchOrders();
    } catch (e) {
      print('Error creating order: $e');
    }
  }
}