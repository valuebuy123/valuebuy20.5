// // File: lib/pages/ongoing_orders_page.dart

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:valuebuyin/controllers/order_controller.dart';
// import 'package:valuebuyin/controllers/order_timeline.dart';
// import 'package:valuebuyin/widgets/order_timeline.dart';

// class OngoingOrdersPage extends StatelessWidget {
//   const OngoingOrdersPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final OrderController orderController = Get.put(OrderController());
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Ongoing Orders'),
//         backgroundColor: Colors.orangeAccent[700],
//         elevation: 0,
//       ),
//       body: Obx(
//         () => orderController.ongoingOrders.isEmpty
//             ? const Center(
//                 child: Text(
//                   'No Ongoing Orders',
//                   style: TextStyle(fontSize: 18, color: Colors.grey),
//                 ),
//               )
//             : ListView.builder(
//                 padding: EdgeInsets.all(screenWidth * 0.04),
//                 itemCount: orderController.ongoingOrders.length,
//                 itemBuilder: (context, index) {
//                   final order = orderController.ongoingOrders[index];
//                   return OrderCard(
//                     order: order,
//                     screenWidth: screenWidth,
//                     screenHeight: screenHeight,
//                   );
//                 },
//               ),
//       ),
//     );
//   }
// }

// class OrderCard extends StatelessWidget {
//   final Map<String, dynamic> order;
//   final double screenWidth;
//   final double screenHeight;

//   const OrderCard({
//     required this.order,
//     required this.screenWidth,
//     required this.screenHeight,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final OrderController orderController = Get.find<OrderController>();
//     final items = (order['items']?['Selected'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
//     final trackingStatus = (order['tracking_status'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
//     final canCancel = orderController.canCancelOrder(order);

//     return Card(
//       elevation: 4,
//       margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: EdgeInsets.all(screenWidth * 0.04),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Order Header
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Order #${order['order_number'] ?? 'N/A'}',
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.045,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   '₹${order['amount']?.toStringAsFixed(2) ?? '0.00'}',
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.045,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.orangeAccent[700],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: screenHeight * 0.01),
//             Text(
//               'Placed on: ${DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.parse(trackingStatus.isNotEmpty ? trackingStatus.first['timestamp'] : DateTime.now().toIso8601String()))}',
//               style: TextStyle(
//                 fontSize: screenWidth * 0.035,
//                 color: Colors.grey,
//               ),
//             ),
//             SizedBox(height: screenHeight * 0.02),

//             // Ordered Products
//             Text(
//               'Ordered Products',
//               style: TextStyle(
//                 fontSize: screenWidth * 0.04,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             ...items.map((item) => ListTile(
//                   contentPadding: EdgeInsets.zero,
//                   title: Text(
//                     item['product_name'] ?? 'Unknown Product',
//                     style: TextStyle(fontSize: screenWidth * 0.04),
//                   ),
//                   subtitle: Text(
//                     'Weight: ${item['weight']?.toStringAsFixed(2) ?? '0.00'} kg | Price: ₹${item['total_price']?.toStringAsFixed(2) ?? '0.00'}',
//                     style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.grey),
//                   ),
//                 )),

//             SizedBox(height: screenHeight * 0.02),

//             // Order Timeline
//             OrderTimeline(
//               status: order['status'] ?? 'Pending',
//               trackingStatus: trackingStatus.map((e) => {
//                     'status': e['status'],
//                     'timestamp': DateTime.parse(e['timestamp']),
//                   }).toList(),
//             ),

//             SizedBox(height: screenHeight * 0.02),

//             // Cancel Button
//             if (canCancel)
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: OutlinedButton(
//                   onPressed: () async {
//                     await orderController.cancelOrder(order);
//                     Get.snackbar(
//                       'Order Canceled',
//                       'Order #${order['order_number']} has been canceled.',
//                       snackPosition: SnackPosition.TOP,
//                       backgroundColor: Colors.red,
//                       colorText: Colors.white,
//                     );
//                   },
//                   style: OutlinedButton.styleFrom(
//                     side: BorderSide(color: Colors.red),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   child: Text(
//                     'Cancel Order',
//                     style: TextStyle(
//                       color: Colors.red,
//                       fontSize: screenWidth * 0.04,
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:valuebuyin/controllers/order_controller.dart';
// import 'package:valuebuyin/controllers/order_timeline.dart';
// import 'package:valuebuyin/widgets/order_timeline.dart';

// class OngoingOrdersPage extends StatelessWidget {
//   const OngoingOrdersPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final OrderController orderController = Get.put(OrderController());
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double screenHeight = MediaQuery.of(context).size.height;

//     orderController.fetchOrders();

//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Orders'),
//           backgroundColor: Colors.white,
//           elevation: 0,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.black),
//             onPressed: () => Navigator.pop(context),
//           ),
//           bottom: TabBar(
//             labelColor: Colors.orangeAccent[700],
//             unselectedLabelColor: Colors.grey,
//             indicatorColor: Colors.orangeAccent[700],
//             indicatorWeight: 2.0,
//             tabs: const [
//               Tab(text: 'Ongoing'),
//               Tab(text: 'History'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             Obx(
//               () => orderController.isLoading.value
//                   ? const Center(child: CircularProgressIndicator())
//                   : orderController.ongoingOrders.isEmpty
//                       ? Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Container(
//                                 width: 80,
//                                 height: 80,
//                                 decoration: const BoxDecoration(
//                                   color: Colors.black,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: const Icon(
//                                   Icons.warning_amber_rounded,
//                                   size: 40,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               const SizedBox(height: 10),
//                               Text(
//                                 'There is no ongoing order right now.\nYou can order from home',
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   fontSize: screenWidth * 0.04,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                       : ListView.builder(
//                           padding: EdgeInsets.all(screenWidth * 0.04),
//                           itemCount: orderController.ongoingOrders.length,
//                           itemBuilder: (context, index) {
//                             final order = orderController.ongoingOrders[index];
//                             return OrderCard(
//                               order: order,
//                               screenWidth: screenWidth,
//                               screenHeight: screenHeight,
//                             );
//                           },
//                         ),
//             ),
//             Obx(
//               () => orderController.isLoading.value
//                   ? const Center(child: CircularProgressIndicator())
//                   : orderController.orderHistory.isEmpty
//                       ? Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Icon(
//                                 Icons.history,
//                                 size: 60,
//                                 color: Colors.black,
//                               ),
//                               const SizedBox(height: 10),
//                               Text(
//                                 'No order history available.',
//                                 style: TextStyle(
//                                   fontSize: screenWidth * 0.04,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                       : ListView.builder(
//                           padding: EdgeInsets.all(screenWidth * 0.04),
//                           itemCount: orderController.orderHistory.length,
//                           itemBuilder: (context, index) {
//                             final order = orderController.orderHistory[index];
//                             return OrderCard(
//                               order: order,
//                               screenWidth: screenWidth,
//                               screenHeight: screenHeight,
//                             );
//                           },
//                         ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class OrderCard extends StatelessWidget {
//   final Map<String, dynamic> order;
//   final double screenWidth;
//   final double screenHeight;

//   const OrderCard({
//     required this.order,
//     required this.screenWidth,
//     required this.screenHeight,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final OrderController orderController = Get.find<OrderController>();
//     final items = (order['items']?['Selected'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
//     final trackingStatus = (order['tracking_status'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
//     final canCancel = orderController.canCancelOrder(order);

//     return Card(
//       elevation: 4,
//       margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: EdgeInsets.all(screenWidth * 0.04),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Order #${order['order_number'] ?? 'N/A'}',
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.045,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   '₹${order['amount']?.toStringAsFixed(2) ?? '0.00'}',
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.045,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.orangeAccent[700],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: screenHeight * 0.01),
//             Text(
//               'Placed on: ${DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.parse(trackingStatus.isNotEmpty ? trackingStatus.first['timestamp'] : DateTime.now().toIso8601String()))}',
//               style: TextStyle(
//                 fontSize: screenWidth * 0.035,
//                 color: Colors.grey,
//               ),
//             ),
//             SizedBox(height: screenHeight * 0.02),
//             Text(
//               'Ordered Products',
//               style: TextStyle(
//                 fontSize: screenWidth * 0.04,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             ...items.map((item) => ListTile(
//                   contentPadding: EdgeInsets.zero,
//                   title: Text(
//                     item['product_name'] ?? 'Unknown Product',
//                     style: TextStyle(fontSize: screenWidth * 0.04),
//                   ),
//                   subtitle: Text(
//                     'Weight: ${item['weight']?.toStringAsFixed(2) ?? '0.00'} kg | Price: ₹${item['total_price']?.toStringAsFixed(2) ?? '0.00'}',
//                     style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.grey),
//                   ),
//                 )),
//             SizedBox(height: screenHeight * 0.02),
//             OrderTimeline(
//               status: order['status'] ?? 'Pending',
//               trackingStatus: trackingStatus.map((e) => {
//                     'status': e['status'],
//                     'timestamp': DateTime.parse(e['timestamp']),
//                   }).toList(),
//             ),
//             SizedBox(height: screenHeight * 0.02),
//             if (canCancel)
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: OutlinedButton(
//                   onPressed: () async {
//                     await orderController.cancelOrder(order);
//                     Get.snackbar(
//                       'Order Canceled',
//                       'Order #${order['order_number']} has been canceled.',
//                       snackPosition: SnackPosition.TOP,
//                       backgroundColor: Colors.red,
//                       colorText: Colors.white,
//                     );
//                   },
//                   style: OutlinedButton.styleFrom(
//                     side: BorderSide(color: Colors.red),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   child: Text(
//                     'Cancel Order',
//                     style: TextStyle(
//                       color: Colors.red,
//                       fontSize: screenWidth * 0.04,
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }