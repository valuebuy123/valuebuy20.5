// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:valuebuyin/controllers/order_controller.dart';
// import 'package:valuebuyin/controllers/order_timeline.dart';
// import 'package:valuebuyin/nav_bar.dart';

// class OrdersPage extends StatefulWidget {
//   const OrdersPage({super.key, required List products});

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
//                         SizedBox(height: screenHeight * 0.02),
//                         OrderTimeline(
//                           status: order['status'],
//                           trackingStatus: order['trackingStatus'],
//                         ),
//                         SizedBox(height: screenHeight * 0.01),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             if (canCancel)
//                               OutlinedButton(
//                                 onPressed: () {
//                                   orderController.cancelOrder(order);
//                                 },
//                                 style: OutlinedButton.styleFrom(
//                                   side: const BorderSide(color: Colors.red),
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: screenWidth * 0.04,
//                                     vertical: screenHeight * 0.01,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(20),
//                                   ),
//                                 ),
//                                 child: Text(
//                                   'Cancel Order',
//                                   style: TextStyle(
//                                     fontSize: screenWidth * 0.035,
//                                     color: Colors.red,
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }),
//           Obx(() {
//             if (orderController.orderHistory.isEmpty) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image.network(
//                       'lib/assets/images/cat_in_box.png',
//                       height: screenHeight * 0.2,
//                       errorBuilder: (context, error, stackTrace) {
//                         print(
//                           'Error loading empty state image in OrdersPage (History): $error',
//                         );
//                         return const Icon(Icons.error, size: 100);
//                       },
//                     ),
//                     SizedBox(height: screenHeight * 0.02),
//                     Text(
//                       'No order history available.',
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
//               itemCount: orderController.orderHistory.length,
//               itemBuilder: (context, index) {
//                 final order = orderController.orderHistory[index];
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
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Order ${order['orderNumber']}',
//                                   style: TextStyle(
//                                     fontSize: screenWidth * 0.04,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 SizedBox(height: screenHeight * 0.005),
//                                 Text(
//                                   order['date'],
//                                   style: TextStyle(
//                                     fontSize: screenWidth * 0.035,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                                 SizedBox(height: screenHeight * 0.005),
//                                 Text(
//                                   'Status: ${order['status']}',
//                                   style: TextStyle(
//                                     fontSize: screenWidth * 0.035,
//                                     color:
//                                         order['status'] == 'Canceled'
//                                             ? Colors.red
//                                             : Colors.green,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Text(
//                               'Rs.${order['amount'].toStringAsFixed(2)}',
//                               style: TextStyle(
//                                 fontSize: screenWidth * 0.04,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.orangeAccent[700],
//                               ),
//                             ),
//                           ],
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









import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:valuebuyin/controllers/order_controller.dart';
import 'package:valuebuyin/controllers/order_timeline.dart';
import 'package:valuebuyin/widgets/order_timeline.dart';

class OngoingOrdersPage extends StatelessWidget {
  const OngoingOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.put(OrderController());
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    orderController.fetchOrders();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Orders'),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: TabBar(
            labelColor: Colors.orangeAccent[700],
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.orangeAccent[700],
            indicatorWeight: 2.0,
            tabs: const [
              Tab(text: 'Ongoing'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Obx(
              () => orderController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : orderController.ongoingOrders.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'lib/assets/empty_ongoing.png', // Ensure this asset exists
                                width: 80,
                                height: 80,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 80,
                                    height: 80,
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.warning_amber_rounded,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'There is no ongoing order right now.\nYou can order from home',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          itemCount: orderController.ongoingOrders.length,
                          itemBuilder: (context, index) {
                            final order = orderController.ongoingOrders[index];
                            return OrderCard(
                              order: order,
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                            );
                          },
                        ),
            ),
            Obx(
              () => orderController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : orderController.orderHistory.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'lib/assets/empty_history.png', // Ensure this asset exists
                                width: 60,
                                height: 60,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.history,
                                    size: 60,
                                    color: Colors.black,
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'No order history available.',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          itemCount: orderController.orderHistory.length,
                          itemBuilder: (context, index) {
                            final order = orderController.orderHistory[index];
                            return OrderCard(
                              order: order,
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final double screenWidth;
  final double screenHeight;

  const OrderCard({
    required this.order,
    required this.screenWidth,
    required this.screenHeight,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find<OrderController>();
    final items = (order['items']?['Selected'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
    final trackingStatus = (order['tracking_status'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
    final canCancel = orderController.canCancelOrder(order);

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order['order_number'] ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '₹${order['amount']?.toStringAsFixed(2) ?? '0.00'}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              'Placed on: ${DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.parse(trackingStatus.isNotEmpty ? trackingStatus.first['timestamp'] : DateTime.now().toIso8601String()))}',
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Ordered Products',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            ...items.map((item) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    item['product_name'] ?? 'Unknown Product',
                    style: TextStyle(fontSize: screenWidth * 0.04),
                  ),
                  subtitle: Text(
                    'Weight: ${item['weight']?.toStringAsFixed(2) ?? '0.00'} kg | Price: ₹${item['total_price']?.toStringAsFixed(2) ?? '0.00'}',
                    style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.grey),
                  ),
                )),
            SizedBox(height: screenHeight * 0.02),
            OrderTimeline(
              status: order['status'] ?? 'Pending',
              trackingStatus: trackingStatus.map((e) => {
                    'status': e['status'],
                    'timestamp': DateTime.parse(e['timestamp']),
                  }).toList(),
            ),
            SizedBox(height: screenHeight * 0.02),
            if (canCancel)
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  onPressed: () async {
                    await orderController.cancelOrder(order);
                    Get.snackbar(
                      'Order Canceled',
                      'Order #${order['order_number']} has been canceled.',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Cancel Order',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}






// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:valuebuyin/controllers/order_controller.dart';
// import 'package:valuebuyin/controllers/order_timeline.dart';
// import 'package:valuebuyin/nav_bar.dart';

// class OrdersPage extends StatefulWidget {
//   const OrdersPage({super.key, required this.products});

//   final List products;

//   @override
//   _OrdersPageState createState() => _OrdersPageState();
// }

// class _OrdersPageState extends State<OrdersPage> with SingleTickerProviderStateMixin {
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
//                       errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 100),
//                     ),
//                     SizedBox(height: screenHeight * 0.02),
//                     Text(
//                       'There is no ongoing order right now.\nYou can order from home',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.grey),
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
//                 final items = order['items'] as Map<String, List<Map<String, dynamic>>>;
//                 final address = order['address'] as Map<String, dynamic>;

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
//                               style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               order['date'],
//                               style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.grey),
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
//                         Text(
//                           'Delivery Address:',
//                           style: TextStyle(fontSize: screenWidth * 0.035, fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           '${address['fullName']}\n${address['flatHouseNo']}, ${address['area']}, ${address['street']}\n${address['cityTown']}, ${address['pincode']}\nMobile: ${address['mobileNumber']}',
//                           style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.grey),
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
//                                       errorBuilder: (context, error, stackTrace) => Image.network(
//                                         'lib/assets/images/placeholder.png',
//                                         width: screenWidth * 0.1,
//                                         height: screenWidth * 0.1,
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                   ),
//                                   title: Text(
//                                     product['name'],
//                                     style: TextStyle(fontSize: screenWidth * 0.035),
//                                   ),
//                                   subtitle: Text(
//                                     'Qty: ${product['weight']}',
//                                     style: TextStyle(fontSize: screenWidth * 0.03, color: Colors.grey),
//                                   ),
//                                 );
//                               }),
//                             ],
//                           );
//                         }),
//                         SizedBox(height: screenHeight * 0.02),
//                         OrderTimeline(
//                           status: order['status'],
//                           trackingStatus: order['trackingStatus'],
//                         ),
//                         SizedBox(height: screenHeight * 0.01),
//                         if (canCancel)
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               OutlinedButton(
//                                 onPressed: () => orderController.cancelOrder(order),
//                                 style: OutlinedButton.styleFrom(
//                                   side: const BorderSide(color: Colors.red),
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: screenWidth * 0.04,
//                                     vertical: screenHeight * 0.01,
//                                   ),
//                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                                 ),
//                                 child: Text(
//                                   'Cancel Order',
//                                   style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.red),
//                                 ),
//                               ),
//                             ],
//                           ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }),
//           Obx(() {
//             if (orderController.orderHistory.isEmpty) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image.network(
//                       'lib/assets/images/cat_in_box.png',
//                       height: screenHeight * 0.2,
//                       errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 100),
//                     ),
//                     SizedBox(height: screenHeight * 0.02),
//                     Text(
//                       'No order history available.',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               );
//             }
//             return ListView.builder(
//               padding: EdgeInsets.all(screenWidth * 0.04),
//               itemCount: orderController.orderHistory.length,
//               itemBuilder: (context, index) {
//                 final order = orderController.orderHistory[index];
//                 final items = order['items'] as Map<String, List<Map<String, dynamic>>>;
//                 final address = order['address'] as Map<String, dynamic>;

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
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Order ${order['orderNumber']}',
//                                   style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold),
//                                 ),
//                                 SizedBox(height: screenHeight * 0.005),
//                                 Text(
//                                   order['date'],
//                                   style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.grey),
//                                 ),
//                                 SizedBox(height: screenHeight * 0.005),
//                                 Text(
//                                   'Status: ${order['status']}',
//                                   style: TextStyle(
//                                     fontSize: screenWidth * 0.035,
//                                     color: order['status'] == 'Canceled' ? Colors.red : Colors.green,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Text(
//                               'Rs.${order['amount'].toStringAsFixed(2)}',
//                               style: TextStyle(
//                                 fontSize: screenWidth * 0.04,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.orangeAccent[700],
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: screenHeight * 0.01),
//                         Text(
//                           'Delivery Address:',
//                           style: TextStyle(fontSize: screenWidth * 0.035, fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           '${address['fullName']}\n${address['flatHouseNo']}, ${address['area']}, ${address['street']}\n${address['cityTown']}, ${address['pincode']}\nMobile: ${address['mobileNumber']}',
//                           style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.grey),
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
//                                       errorBuilder: (context, error, stackTrace) => Image.network(
//                                         'lib/assets/images/placeholder.png',
//                                         width: screenWidth * 0.1,
//                                         height: screenWidth * 0.1,
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                   ),
//                                   title: Text(
//                                     product['name'],
//                                     style: TextStyle(fontSize: screenWidth * 0.035),
//                                   ),
//                                   subtitle: Text(
//                                     'Qty: ${product['weight']}',
//                                     style: TextStyle(fontSize: screenWidth * 0.03, color: Colors.grey),
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
//       bottomNavigationBar: const NavigationMenu(currentIndex: 2),
//     );
//   }
// }
