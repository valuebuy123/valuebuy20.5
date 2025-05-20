
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:valuebuyin/controllers/address_controller.dart';
// import 'package:valuebuyin/nav_bar.dart';
// import 'package:valuebuyin/pages/adress/address_page.dart';
// import 'package:valuebuyin/pages/cart/cart_controller.dart';
// import 'package:valuebuyin/pages/order_status_page.dart';

// class CheckoutPage extends StatefulWidget {
//   final Map<String, List<Map<String, dynamic>>> cartItems;
//   final double subtotal;

//   const CheckoutPage({
//     required this.cartItems,
//     required this.subtotal,
//     super.key,
//   });

//   @override
//   _CheckoutPageState createState() => _CheckoutPageState();
// }

// class _CheckoutPageState extends State<CheckoutPage> {
//   String _selectedDeliveryOption = 'Delivery';
//   String _selectedPaymentMethod = 'Cash on Delivery';
//   bool _isLoading = false;

//   double get tax => widget.subtotal * 0.004;
//   double get deliveryFee => _selectedDeliveryOption == 'Delivery' ? 0.0 : 0.0;
//   double get total => widget.subtotal + tax + deliveryFee;

//   @override
//   void initState() {
//     super.initState();
//     Get.find<AddressController>().fetchAddresses();
//     Get.find<CartController>();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double screenHeight = MediaQuery.of(context).size.height;
//     final CartController cartController = Get.find<CartController>();
//     final AddressController addressController = Get.find<AddressController>();

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text(
//           'Checkout',
//           style: TextStyle(color: Colors.black, fontSize: 24),
//           textAlign: TextAlign.center,
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.orangeAccent[700]),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(screenWidth * 0.04),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildSectionTitle('Delivery Option', screenWidth),
//               _buildDeliveryOption(
//                 'Delivery',
//                 'FREE',
//                 _selectedDeliveryOption == 'Delivery',
//                 () => setState(() => _selectedDeliveryOption = 'Delivery'),
//                 screenWidth,
//                 screenHeight,
//               ),
//               if (_selectedDeliveryOption == 'Delivery') ...[
//                 SizedBox(height: screenHeight * 0.02),
//                 _buildSectionTitle('Delivery Location', screenWidth),
//                 _buildDeliveryLocation(
//                   screenWidth,
//                   screenHeight,
//                   addressController,
//                 ),
//               ],
//               SizedBox(height: screenHeight * 0.02),
//               _buildSectionTitle('Payment Method', screenWidth),
//               _buildPaymentMethod(
//                 'Cash on Delivery',
//                 Icons.money,
//                 _selectedPaymentMethod == 'Cash on Delivery',
//                 () =>
//                     setState(() => _selectedPaymentMethod = 'Cash on Delivery'),
//                 screenWidth,
//                 screenHeight,
//               ),
//               SizedBox(height: screenHeight * 0.02),
//               _buildSectionTitle('Order Summary', screenWidth),
//               _buildOrderSummary(screenWidth),
//               SizedBox(height: screenHeight * 0.03),
//               ElevatedButton(
//                 onPressed: _isLoading
//                     ? null
//                     : () async {
//                         final defaultAddress =
//                             addressController.getDefaultAddress();
//                         if (_selectedDeliveryOption == 'Delivery' &&
//                             defaultAddress == null) {
//                           Get.snackbar(
//                             'Error',
//                             'Please set a default address for delivery.',
//                             snackPosition: SnackPosition.BOTTOM,
//                           );
//                           return;
//                         }
//                         final confirm = await showDialog<bool>(
//                           context: context,
//                           builder: (context) => AlertDialog(
//                             title: const Text('Confirm Order'),
//                             content: const Text(
//                               'Are you sure you want to place this order?',
//                             ),
//                             actions: [
//                               TextButton(
//                                 onPressed: () => Navigator.pop(context, false),
//                                 child: const Text('Cancel'),
//                               ),
//                               ElevatedButton(
//                                 onPressed: () => Navigator.pop(context, true),
//                                 child: const Text('Confirm'),
//                               ),
//                             ],
//                           ),
//                         );
//                         if (confirm != true) return;
//                         setState(() => _isLoading = true);
//                         try {
//                           bool success = await cartController.placeOrder();
//                           setState(() => _isLoading = false);
//                           if (success) {
//                             cartController.clearCart();
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     const OrderStatusPage(isSuccess: true),
//                               ),
//                             );
//                           } else {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => OrderStatusPage(
//                                   isSuccess: false,
//                                   onTryAgain: () => Navigator.pop(context),
//                                 ),
//                               ),
//                             );
//                           }
//                         } catch (e) {
//                           setState(() => _isLoading = false);
//                           Get.snackbar(
//                             'Error',
//                             'Failed to place order: $e',
//                             snackPosition: SnackPosition.BOTTOM,
//                             backgroundColor: Colors.red,
//                             colorText: Colors.white,
//                           );
//                         }
//                       },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.orangeAccent[700],
//                   padding: EdgeInsets.symmetric(
//                     vertical: screenHeight * 0.02,
//                     horizontal: screenWidth * 0.1,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 child: _isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : Text(
//                         'Checkout Rs.${total.toStringAsFixed(2)}',
//                         style: TextStyle(
//                           fontSize: screenWidth * 0.045,
//                           color: Colors.white,
//                         ),
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: const NavigationMenu(currentIndex: 2),
//     );
//   }

//   Widget _buildSectionTitle(String title, double screenWidth) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
//       child: Text(
//         title,
//         style: TextStyle(
//           fontSize: screenWidth * 0.045,
//           fontWeight: FontWeight.bold,
//           color: Colors.black,
//         ),
//       ),
//     );
//   }

//   Widget _buildDeliveryOption(
//     String title,
//     String subtitle,
//     bool isSelected,
//     VoidCallback onTap,
//     double screenWidth,
//     double screenHeight,
//   ) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
//         padding: EdgeInsets.all(screenWidth * 0.04),
//         decoration: BoxDecoration(
//           color: Colors.grey[100],
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: isSelected ? Colors.orangeAccent[700]! : Colors.transparent,
//             width: 2,
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.04,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 Text(
//                   subtitle,
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.035,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//             Radio<String>(
//               value: title,
//               groupValue: _selectedDeliveryOption,
//               onChanged: (value) => setState(() => _selectedDeliveryOption = value!),
//               activeColor: Colors.orangeAccent[700],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDeliveryLocation(
//     double screenWidth,
//     double screenHeight,
//     AddressController addressController,
//   ) {
//     return Obx(() {
//       final defaultAddress = addressController.getDefaultAddress();
//       if (defaultAddress == null) {
//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const AddressPage()),
//             );
//           },
//           child: Container(
//             padding: EdgeInsets.all(screenWidth * 0.04),
//             decoration: BoxDecoration(
//               color: Colors.grey[100],
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: const Text(
//               'No default address set. Tap to add one.',
//               style: TextStyle(color: Colors.grey),
//             ),
//           ),
//         );
//       }
//       return Container(
//         padding: EdgeInsets.all(screenWidth * 0.04),
//         decoration: BoxDecoration(
//           color: Colors.grey[100],
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   defaultAddress.fullName,
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.04,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   '${defaultAddress.flatHouseNo}, ${defaultAddress.area}, ${defaultAddress.street}',
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.035,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 Text(
//                   '${defaultAddress.cityTown}, ${defaultAddress.pincode}',
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.035,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 Text(
//                   'Mobile: ${defaultAddress.mobileNumber}',
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.035,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const AddressPage()),
//                 );
//               },
//               child: Text(
//                 'Change',
//                 style: TextStyle(color: Colors.orangeAccent[700]),
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }

//   Widget _buildPaymentMethod(
//     String title,
//     IconData icon,
//     bool isSelected,
//     VoidCallback onTap,
//     double screenWidth,
//     double screenHeight,
//   ) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
//         padding: EdgeInsets.all(screenWidth * 0.04),
//         decoration: BoxDecoration(
//           color: Colors.grey[100],
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: isSelected ? Colors.orangeAccent[700]! : Colors.transparent,
//             width: 2,
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Icon(icon, size: screenWidth * 0.06, color: Colors.black),
//                 SizedBox(width: screenWidth * 0.02),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.04,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             Radio<String>(
//               value: title,
//               groupValue: _selectedPaymentMethod,
//               onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
//               activeColor: Colors.orangeAccent[700],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOrderSummary(double screenWidth) {
//     return Container(
//       padding: EdgeInsets.all(screenWidth * 0.04),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         children: [
//           _buildSummaryRow('Subtotal', widget.subtotal, screenWidth),
//           _buildSummaryRow('Tax', tax, screenWidth),
//           _buildSummaryRow(
//             _selectedDeliveryOption == 'Delivery' ? 'Delivery' : 'In-Store Pick Up',
//             deliveryFee,
//             screenWidth,
//           ),
//           const Divider(),
//           _buildSummaryRow('Total:', total, screenWidth, isTotal: true),
//         ],
//       ),
//     );
//   }

//   Widget _buildSummaryRow(
//     String title,
//     double amount,
//     double screenWidth, {
//     bool isTotal = false,
//   }) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: screenWidth * 0.01),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: screenWidth * 0.04,
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//           Text(
//             'Rs.${amount.toStringAsFixed(2)}',
//             style: TextStyle(
//               fontSize: screenWidth * 0.04,
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }






















// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:valuebuyin/controllers/address_controller.dart';
// import 'package:valuebuyin/nav_bar.dart';
// import 'package:valuebuyin/pages/address/address_page.dart';
// import 'package:valuebuyin/pages/adress/address_page.dart';
// import 'package:valuebuyin/pages/cart/cart_controller.dart';
// import 'package:valuebuyin/pages/order_status_page.dart';

// class CheckoutPage extends StatefulWidget {
//   final Map<String, List<Map<String, dynamic>>> cartItems;
//   final double subtotal;

//   const CheckoutPage({
//     required this.cartItems,
//     required this.subtotal,
//     super.key,
//   });

//   @override
//   _CheckoutPageState createState() => _CheckoutPageState();
// }

// class _CheckoutPageState extends State<CheckoutPage> {
//   String _selectedDeliveryOption = 'Delivery';
//   String _selectedPaymentMethod = 'Cash on Delivery';
//   bool _isLoading = false;

//   double get tax => widget.subtotal * 0.004;
//   double get deliveryFee => _selectedDeliveryOption == 'Delivery' ? 0.0 : 0.0;
//   double get total => widget.subtotal + tax + deliveryFee;

//   @override
//   void initState() {
//     super.initState();
//     Get.find<AddressController>().fetchAddresses();
//     Get.find<CartController>();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double screenHeight = MediaQuery.of(context).size.height;
//     final CartController cartController = Get.find<CartController>();
//     final AddressController addressController = Get.find<AddressController>();

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text(
//           'Checkout',
//           style: TextStyle(color: Colors.black, fontSize: 24),
//           textAlign: TextAlign.center,
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.orangeAccent[700]),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(screenWidth * 0.04),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildSectionTitle('Delivery Option', screenWidth),
//               _buildDeliveryOption(
//                 'Delivery',
//                 'FREE',
//                 _selectedDeliveryOption == 'Delivery',
//                 () => setState(() => _selectedDeliveryOption = 'Delivery'),
//                 screenWidth,
//                 screenHeight,
//               ),
//               if (_selectedDeliveryOption == 'Delivery') ...[
//                 SizedBox(height: screenHeight * 0.02),
//                 _buildSectionTitle('Delivery Location', screenWidth),
//                 _buildDeliveryLocation(
//                   screenWidth,
//                   screenHeight,
//                   addressController,
//                 ),
//               ],
//               SizedBox(height: screenHeight * 0.02),
//               _buildSectionTitle('Payment Method', screenWidth),
//               _buildPaymentMethod(
//                 'Cash on Delivery',
//                 Icons.money,
//                 _selectedPaymentMethod == 'Cash on Delivery',
//                 () =>
//                     setState(() => _selectedPaymentMethod = 'Cash on Delivery'),
//                 screenWidth,
//                 screenHeight,
//               ),
//               SizedBox(height: screenHeight * 0.02),
//               _buildSectionTitle('Order Summary', screenWidth),
//               _buildOrderSummary(screenWidth),
//               SizedBox(height: screenHeight * 0.03),
//               ElevatedButton(
//                 onPressed: _isLoading
//                     ? null
//                     : () async {
//                         final defaultAddress =
//                             addressController.getDefaultAddress();
//                         if (_selectedDeliveryOption == 'Delivery' &&
//                             defaultAddress == null) {
//                           Get.snackbar(
//                             'Error',
//                             'Please set a default address for delivery.',
//                             snackPosition: SnackPosition.BOTTOM,
//                             backgroundColor: Colors.red,
//                             colorText: Colors.white,
//                           );
//                           return;
//                         }
//                         final confirm = await showDialog<bool>(
//                           context: context,
//                           builder: (context) => AlertDialog(
//                             title: const Text('Confirm Order'),
//                             content: const Text(
//                               'Are you sure you want to place this order?',
//                             ),
//                             actions: [
//                               TextButton(
//                                 onPressed: () => Navigator.pop(context, false),
//                                 child: const Text('Cancel'),
//                               ),
//                               ElevatedButton(
//                                 onPressed: () => Navigator.pop(context, true),
//                                 child: const Text('Confirm'),
//                               ),
//                             ],
//                           ),
//                         );
//                         if (confirm != true) return;
//                         setState(() => _isLoading = true);
//                         try {
//                           bool success = await cartController.placeOrder();
//                           setState(() => _isLoading = false);
//                           if (success) {
//                             Get.snackbar(
//                               'Success',
//                               'Order placed successfully!',
//                               snackPosition: SnackPosition.TOP,
//                               duration: const Duration(seconds: 2),
//                             );
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     const OrderStatusPage(isSuccess: true),
//                               ),
//                             );
//                           } else {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => OrderStatusPage(
//                                   isSuccess: false,
//                                   onTryAgain: () => Navigator.pop(context),
//                                 ),
//                               ),
//                             );
//                           }
//                         } catch (e) {
//                           setState(() => _isLoading = false);
//                           Get.snackbar(
//                             'Error',
//                             'Failed to place order: $e',
//                             snackPosition: SnackPosition.BOTTOM,
//                             backgroundColor: Colors.red,
//                             colorText: Colors.white,
//                           );
//                         }
//                       },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.orangeAccent[700],
//                   padding: EdgeInsets.symmetric(
//                     vertical: screenHeight * 0.02,
//                     horizontal: screenWidth * 0.1,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 child: _isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : Text(
//                         'Checkout Rs.${total.toStringAsFixed(2)}',
//                         style: TextStyle(
//                           fontSize: screenWidth * 0.045,
//                           color: Colors.white,
//                         ),
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: const NavigationMenu(currentIndex: 2),
//     );
//   }

//   Widget _buildSectionTitle(String title, double screenWidth) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
//       child: Text(
//         title,
//         style: TextStyle(
//           fontSize: screenWidth * 0.045,
//           fontWeight: FontWeight.bold,
//           color: Colors.black,
//         ),
//       ),
//     );
//   }

//   Widget _buildDeliveryOption(
//     String title,
//     String subtitle,
//     bool isSelected,
//     VoidCallback onTap,
//     double screenWidth,
//     double screenHeight,
//   ) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
//         padding: EdgeInsets.all(screenWidth * 0.04),
//         decoration: BoxDecoration(
//           color: Colors.grey[100],
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: isSelected ? Colors.orangeAccent[700]! : Colors.transparent,
//             width: 2,
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.04,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 Text(
//                   subtitle,
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.035,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//             Radio<String>(
//               value: title,
//               groupValue: _selectedDeliveryOption,
//               onChanged: (value) => setState(() => _selectedDeliveryOption = value!),
//               activeColor: Colors.orangeAccent[700],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDeliveryLocation(
//     double screenWidth,
//     double screenHeight,
//     AddressController addressController,
//   ) {
//     return Obx(() {
//       final defaultAddress = addressController.getDefaultAddress();
//       if (defaultAddress == null) {
//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const AddressPage()),
//             );
//           },
//           child: Container(
//             padding: EdgeInsets.all(screenWidth * 0.04),
//             decoration: BoxDecoration(
//               color: Colors.grey[100],
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: const Text(
//               'No default address set. Tap to add one.',
//               style: TextStyle(color: Colors.grey),
//             ),
//           ),
//         );
//       }
//       return Container(
//         padding: EdgeInsets.all(screenWidth * 0.04),
//         decoration: BoxDecoration(
//           color: Colors.grey[100],
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   defaultAddress.fullName,
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.04,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   '${defaultAddress.flatHouseNo}, ${defaultAddress.area}, ${defaultAddress.street}',
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.035,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 Text(
//                   '${defaultAddress.cityTown}, ${defaultAddress.pincode}',
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.035,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 Text(
//                   'Mobile: ${defaultAddress.mobileNumber}',
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.035,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const AddressPage()),
//                 );
//               },
//               child: Text(
//                 'Change',
//                 style: TextStyle(color: Colors.orangeAccent[700]),
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }

//   Widget _buildPaymentMethod(
//     String title,
//     IconData icon,
//     bool isSelected,
//     VoidCallback onTap,
//     double screenWidth,
//     double screenHeight,
//   ) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
//         padding: EdgeInsets.all(screenWidth * 0.04),
//         decoration: BoxDecoration(
//           color: Colors.grey[100],
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: isSelected ? Colors.orangeAccent[700]! : Colors.transparent,
//             width: 2,
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Icon(icon, size: screenWidth * 0.06, color: Colors.black),
//                 SizedBox(width: screenWidth * 0.02),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.04,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             Radio<String>(
//               value: title,
//               groupValue: _selectedPaymentMethod,
//               onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
//               activeColor: Colors.orangeAccent[700],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOrderSummary(double screenWidth) {
//     return Container(
//       padding: EdgeInsets.all(screenWidth * 0.04),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         children: [
//           _buildSummaryRow('Subtotal', widget.subtotal, screenWidth),
//           _buildSummaryRow('Tax', tax, screenWidth),
//           _buildSummaryRow(
//             _selectedDeliveryOption == 'Delivery' ? 'Delivery' : 'In-Store Pick Up',
//             deliveryFee,
//             screenWidth,
//           ),
//           const Divider(),
//           _buildSummaryRow('Total:', total, screenWidth, isTotal: true),
//         ],
//       ),
//     );
//   }

//   Widget _buildSummaryRow(
//     String title,
//     double amount,
//     double screenWidth, {
//     bool isTotal = false,
//   }) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: screenWidth * 0.01),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: screenWidth * 0.04,
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//           Text(
//             'Rs.${amount.toStringAsFixed(2)}',
//             style: TextStyle(
//               fontSize: screenWidth * 0.04,
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }












// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:valuebuyin/controllers/address_controller.dart';
// import 'package:valuebuyin/nav_bar.dart';
// import 'package:valuebuyin/pages/address/address_page.dart';
// import 'package:valuebuyin/pages/adress/address_page.dart';
// import 'package:valuebuyin/pages/cart/cart_controller.dart';
// import 'package:valuebuyin/pages/order_status_page.dart';

// class CheckoutPage extends StatefulWidget {
//   final Map<String, List<Map<String, dynamic>>> cartItems;
//   final double subtotal;

//   const CheckoutPage({
//     required this.cartItems,
//     required this.subtotal,
//     super.key,
//   });

//   @override
//   _CheckoutPageState createState() => _CheckoutPageState();
// }

// class _CheckoutPageState extends State<CheckoutPage> {
//   String _selectedDeliveryOption = 'Delivery';
//   String _selectedPaymentMethod = 'Cash on Delivery';
//   bool _isLoading = false;
//   double _dynamicSubtotal = 0.0;

//   double get tax => _dynamicSubtotal * 0.004;
//   double get deliveryFee => _selectedDeliveryOption == 'Delivery' ? 0.0 : 0.0;
//   double get total => _dynamicSubtotal + tax + deliveryFee;

//   @override
//   void initState() {
//     super.initState();
//     Get.find<AddressController>().fetchAddresses();
//     Get.find<CartController>().fetchCartItems();
//     _dynamicSubtotal = widget.subtotal;
//   }

//   void _updateSubtotal() {
//     final cartController = Get.find<CartController>();
//     setState(() {
//       _dynamicSubtotal = cartController.getTotalPrice();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double screenHeight = MediaQuery.of(context).size.height;
//     final CartController cartController = Get.find<CartController>();
//     final AddressController addressController = Get.find<AddressController>();

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text(
//           'Checkout',
//           style: TextStyle(color: Colors.black, fontSize: 24),
//           textAlign: TextAlign.center,
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.orangeAccent[700]),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(screenWidth * 0.04),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildSectionTitle('Cart Items', screenWidth),
//               Obx(() {
//                 if (cartController.cartItems.isEmpty) {
//                   return const Center(
//                     child: Text(
//                       'No items in cart',
//                       style: TextStyle(fontSize: 16, color: Colors.grey),
//                     ),
//                   );
//                 }
//                 return Column(
//                   children: [
//                     ...cartController.cartItems.entries.map((entry) {
//                       final category = entry.key;
//                       final products = entry.value;
//                       return ExpansionTile(
//                         title: Text(
//                           category,
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 16),
//                         ),
//                         children: products.map((product) {
//                           return Card(
//                             elevation: 2,
//                             margin: const EdgeInsets.symmetric(
//                                 horizontal: 8, vertical: 4),
//                             child: ListTile(
//                               leading: product['image_url'] != null
//                                   ? Image.network(
//                                       product['image_url'],
//                                       width: 50,
//                                       height: 50,
//                                       fit: BoxFit.cover,
//                                       errorBuilder:
//                                           (context, error, stackTrace) =>
//                                               const Icon(Icons.broken_image),
//                                     )
//                                   : const Icon(Icons.image, size: 50),
//                               title: Text(
//                                 product['product_name'],
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.w600),
//                               ),
//                               subtitle: Text(
//                                 'Weight: ${product['weight']} kg\nPrice: Rs. ${product['total_price']}',
//                               ),
//                               trailing: IconButton(
//                                 icon: const Icon(Icons.delete, color: Colors.red),
//                                 onPressed: () async {
//                                   final cartItemId = product['cart_item_id'];
//                                   if (cartItemId != null) {
//                                     await cartController
//                                         .deleteCartItem(cartItemId);
//                                     _updateSubtotal();
//                                   } else {
//                                     Get.snackbar(
//                                       'Error',
//                                       'Unable to delete item. Missing cart item ID.',
//                                       snackPosition: SnackPosition.TOP,
//                                       backgroundColor: Colors.red,
//                                       colorText: Colors.white,
//                                     );
//                                   }
//                                 },
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       );
//                     }).toList(),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8.0),
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           final confirm = await showDialog<bool>(
//                             context: context,
//                             builder: (context) => AlertDialog(
//                               title: const Text('Delete All Items'),
//                               content: const Text(
//                                 'Are you sure you want to delete all items from your cart?',
//                               ),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () =>
//                                       Navigator.pop(context, false),
//                                   child: const Text('Cancel'),
//                                 ),
//                                 ElevatedButton(
//                                   onPressed: () => Navigator.pop(context, true),
//                                   child: const Text('Confirm'),
//                                 ),
//                               ],
//                             ),
//                           );
//                           if (confirm == true) {
//                             await cartController.clearCartInSupabase();
//                             _updateSubtotal();
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red,
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                         ),
//                         child: const Text(
//                           'Delete All Items',
//                           style: TextStyle(fontSize: 16, color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               }),
//               SizedBox(height: screenHeight * 0.02),
//               _buildSectionTitle('Delivery Option', screenWidth),
//               _buildDeliveryOption(
//                 'Delivery',
//                 'FREE',
//                 _selectedDeliveryOption == 'Delivery',
//                 () => setState(() => _selectedDeliveryOption = 'Delivery'),
//                 screenWidth,
//                 screenHeight,
//               ),
//               if (_selectedDeliveryOption == 'Delivery') ...[
//                 SizedBox(height: screenHeight * 0.02),
//                 _buildSectionTitle('Delivery Location', screenWidth),
//                 _buildDeliveryLocation(
//                   screenWidth,
//                   screenHeight,
//                   addressController,
//                 ),
//               ],
//               SizedBox(height: screenHeight * 0.02),
//               _buildSectionTitle('Payment Method', screenWidth),
//               _buildPaymentMethod(
//                 'Cash on Delivery',
//                 Icons.money,
//                 _selectedPaymentMethod == 'Cash on Delivery',
//                 () =>
//                     setState(() => _selectedPaymentMethod = 'Cash on Delivery'),
//                 screenWidth,
//                 screenHeight,
//               ),
//               SizedBox(height: screenHeight * 0.02),
//               _buildSectionTitle('Order Summary', screenWidth),
//               _buildOrderSummary(screenWidth),
//               SizedBox(height: screenHeight * 0.03),
//               ElevatedButton(
//                 onPressed: _isLoading
//                     ? null
//                     : () async {
//                         final defaultAddress =
//                             addressController.getDefaultAddress();
//                         if (_selectedDeliveryOption == 'Delivery' &&
//                             defaultAddress == null) {
//                           Get.snackbar(
//                             'Error',
//                             'Please set a default address for delivery.',
//                             snackPosition: SnackPosition.BOTTOM,
//                             backgroundColor: Colors.red,
//                             colorText: Colors.white,
//                           );
//                           return;
//                         }
//                         if (cartController.cartItems.isEmpty) {
//                           Get.snackbar(
//                             'Error',
//                             'Your cart is empty. Add items to proceed.',
//                             snackPosition: SnackPosition.BOTTOM,
//                             backgroundColor: Colors.red,
//                             colorText: Colors.white,
//                           );
//                           return;
//                         }
//                         final confirm = await showDialog<bool>(
//                           context: context,
//                           builder: (context) => AlertDialog(
//                             title: const Text('Confirm Order'),
//                             content: const Text(
//                               'Are you sure you want to place this order?',
//                             ),
//                             actions: [
//                               TextButton(
//                                 onPressed: () => Navigator.pop(context, false),
//                                 child: const Text('Cancel'),
//                               ),
//                               ElevatedButton(
//                                 onPressed: () => Navigator.pop(context, true),
//                                 child: const Text('Confirm'),
//                               ),
//                             ],
//                           ),
//                         );
//                         if (confirm != true) return;
//                         setState(() => _isLoading = true);
//                         try {
//                           bool success = await cartController.placeOrder();
//                           setState(() => _isLoading = false);
//                           if (success) {
//                             Get.snackbar(
//                               'Success',
//                               'Order placed successfully!',
//                               snackPosition: SnackPosition.TOP,
//                               duration: const Duration(seconds: 2),
//                             );
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     const OrderStatusPage(isSuccess: true),
//                               ),
//                             );
//                           } else {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => OrderStatusPage(
//                                   isSuccess: false,
//                                   onTryAgain: () => Navigator.pop(context),
//                                 ),
//                               ),
//                             );
//                           }
//                         } catch (e) {
//                           setState(() => _isLoading = false);
//                           Get.snackbar(
//                             'Error',
//                             'Failed to place order: $e',
//                             snackPosition: SnackPosition.BOTTOM,
//                             backgroundColor: Colors.red,
//                             colorText: Colors.white,
//                           );
//                         }
//                       },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.orangeAccent[700],
//                   padding: EdgeInsets.symmetric(
//                     vertical: screenHeight * 0.02,
//                     horizontal: screenWidth * 0.1,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 child: _isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : Text(
//                         'Checkout Rs.${total.toStringAsFixed(2)}',
//                         style: TextStyle(
//                           fontSize: screenWidth * 0.045,
//                           color: Colors.white,
//                         ),
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: NavigationMenu(
//         currentIndex: 2,
//         onTap: (index) {
//           if (index == 0) {
//             Navigator.popUntil(context, (route) => route.isFirst);
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title, double screenWidth) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
//       child: Text(
//         title,
//         style: TextStyle(
//           fontSize: screenWidth * 0.045,
//           fontWeight: FontWeight.bold,
//           color: Colors.black,
//         ),
//       ),
//     );
//   }

//   Widget _buildDeliveryOption(
//     String title,
//     String subtitle,
//     bool isSelected,
//     VoidCallback onTap,
//     double screenWidth,
//     double screenHeight,
//   ) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
//         padding: EdgeInsets.all(screenWidth * 0.04),
//         decoration: BoxDecoration(
//           color: Colors.grey[100],
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: isSelected ? Colors.orangeAccent[700]! : Colors.transparent,
//             width: 2,
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.04,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 Text(
//                   subtitle,
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.035,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//             Radio<String>(
//               value: title,
//               groupValue: _selectedDeliveryOption,
//               onChanged: (value) =>
//                   setState(() => _selectedDeliveryOption = value!),
//               activeColor: Colors.orangeAccent[700],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDeliveryLocation(
//     double screenWidth,
//     double screenHeight,
//     AddressController addressController,
//   ) {
//     return Obx(() {
//       final defaultAddress = addressController.getDefaultAddress();
//       if (defaultAddress == null) {
//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const AddressPage()),
//             );
//           },
//           child: Container(
//             padding: EdgeInsets.all(screenWidth * 0.04),
//             decoration: BoxDecoration(
//               color: Colors.grey[100],
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: const Text(
//               'No default address set. Tap to add one.',
//               style: TextStyle(color: Colors.grey),
//             ),
//           ),
//         );
//       }
//       return Container(
//         padding: EdgeInsets.all(screenWidth * 0.04),
//         decoration: BoxDecoration(
//           color: Colors.grey[100],
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   defaultAddress.fullName,
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.04,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   '${defaultAddress.flatHouseNo}, ${defaultAddress.area}, ${defaultAddress.street}',
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.035,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 Text(
//                   '${defaultAddress.cityTown}, ${defaultAddress.pincode}',
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.035,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 Text(
//                   'Mobile: ${defaultAddress.mobileNumber}',
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.035,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const AddressPage()),
//                 );
//               },
//               child: Text(
//                 'Change',
//                 style: TextStyle(color: Colors.orangeAccent[700]),
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }

//   Widget _buildPaymentMethod(
//     String title,
//     IconData icon,
//     bool isSelected,
//     VoidCallback onTap,
//     double screenWidth,
//     double screenHeight,
//   ) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
//         padding: EdgeInsets.all(screenWidth * 0.04),
//         decoration: BoxDecoration(
//           color: Colors.grey[100],
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: isSelected ? Colors.orangeAccent[700]! : Colors.transparent,
//             width: 2,
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Icon(icon, size: screenWidth * 0.06, color: Colors.black),
//                 SizedBox(width: screenWidth * 0.02),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.04,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             Radio<String>(
//               value: title,
//               groupValue: _selectedPaymentMethod,
//               onChanged: (value) =>
//                   setState(() => _selectedPaymentMethod = value!),
//               activeColor: Colors.orangeAccent[700],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOrderSummary(double screenWidth) {
//     return Container(
//       padding: EdgeInsets.all(screenWidth * 0.04),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         children: [
//           _buildSummaryRow('Subtotal', _dynamicSubtotal, screenWidth),
//           _buildSummaryRow('Tax', tax, screenWidth),
//           _buildSummaryRow(
//             _selectedDeliveryOption == 'Delivery'
//                 ? 'Delivery'
//                 : 'In-Store Pick Up',
//             deliveryFee,
//             screenWidth,
//           ),
//           const Divider(),
//           _buildSummaryRow('Total:', total, screenWidth, isTotal: true),
//         ],
//       ),
//     );
//   }

//   Widget _buildSummaryRow(
//     String title,
//     double amount,
//     double screenWidth, {
//     bool isTotal = false,
//   }) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: screenWidth * 0.01),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: screenWidth * 0.04,
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//           Text(
//             'Rs.${amount.toStringAsFixed(2)}',
//             style: TextStyle(
//               fontSize: screenWidth * 0.04,
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




















// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:valuebuyin/controllers/address_controller.dart';
// import 'package:valuebuyin/nav_bar.dart';
// import 'package:valuebuyin/pages/address/address_page.dart';
// import 'package:valuebuyin/pages/adress/address_page.dart';
// import 'package:valuebuyin/pages/cart/cart_controller.dart';
// import 'package:valuebuyin/pages/order_status_page.dart';

// class CheckoutPage extends StatefulWidget {
//   final Map<String, List<Map<String, dynamic>>> cartItems;
//   final double subtotal;

//   const CheckoutPage({
//     required this.cartItems,
//     required this.subtotal,
//     super.key,
//   });

//   @override
//   _CheckoutPageState createState() => _CheckoutPageState();
// }

// class _CheckoutPageState extends State<CheckoutPage> {
//   String _selectedDeliveryOption = 'Delivery';
//   String _selectedPaymentMethod = 'Cash on Delivery';
//   bool _isLoading = false;
//   double _dynamicSubtotal = 0.0;

//   double get tax => _dynamicSubtotal * 0.004;
//   double get deliveryFee => _selectedDeliveryOption == 'Delivery' ? 0.0 : 0.0;
//   double get total => _dynamicSubtotal + tax + deliveryFee;

//   @override
//   void initState() {
//     super.initState();
//     Get.find<AddressController>().fetchAddresses();
//     Get.find<CartController>().fetchCartItems();
//     _dynamicSubtotal = widget.subtotal;
//   }

//   void _updateSubtotal() {
//     final cartController = Get.find<CartController>();
//     setState(() {
//       _dynamicSubtotal = cartController.getTotalPrice();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double screenHeight = MediaQuery.of(context).size.height;
//     final CartController cartController = Get.find<CartController>();
//     final AddressController addressController = Get.find<AddressController>();

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text(
//           'Checkout',
//           style: TextStyle(color: Colors.black, fontSize: 24),
//           textAlign: TextAlign.center,
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.orangeAccent[700]),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(screenWidth * 0.04),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildSectionTitle('Cart Items', screenWidth),
//               Obx(() {
//                 if (cartController.cartItems.isEmpty) {
//                   return const Center(
//                     child: Text(
//                       'No items in cart',
//                       style: TextStyle(fontSize: 16, color: Colors.grey),
//                     ),
//                   );
//                 }
//                 return Column(
//                   children: [
//                     ...cartController.cartItems.entries.map((entry) {
//                       final category = entry.key;
//                       final products = entry.value;
//                       return ExpansionTile(
//                         title: Text(
//                           category,
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 16),
//                         ),
//                         children: products.map((product) {
//                           return Card(
//                             elevation: 2,
//                             margin: const EdgeInsets.symmetric(
//                                 horizontal: 8, vertical: 4),
//                             child: ListTile(
//                               leading: product['image_url'] != null
//                                   ? Image.network(
//                                       product['image_url'],
//                                       width: 50,
//                                       height: 50,
//                                       fit: BoxFit.cover,
//                                       errorBuilder:
//                                           (context, error, stackTrace) =>
//                                               const Icon(Icons.broken_image),
//                                     )
//                                   : const Icon(Icons.image, size: 50),
//                               title: Text(
//                                 product['product_name'],
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.w600),
//                               ),
//                               subtitle: Text(
//                                 'Weight: ${product['weight']} kg\nPrice: Rs. ${product['total_price']}',
//                               ),
//                               trailing: IconButton(
//                                 icon: const Icon(Icons.delete, color: Colors.red),
//                                 onPressed: () async {
//                                   final cartItemId = product['order_id'];
//                                   if (cartItemId != null) {
//                                     await cartController
//                                         .deleteCartItem(cartItemId);
//                                     _updateSubtotal();
//                                   } else {
//                                     Get.snackbar(
//                                       'Error',
//                                       'Unable to delete item. Missing cart item ID.',
//                                       snackPosition: SnackPosition.TOP,
//                                       backgroundColor: Colors.red,
//                                       colorText: Colors.white,
//                                     );
//                                   }
//                                 },
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       );
//                     }).toList(),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8.0),
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           final confirm = await showDialog<bool>(
//                             context: context,
//                             builder: (context) => AlertDialog(
//                               title: const Text('Delete All Items'),
//                               content: const Text(
//                                 'Are you sure you want to delete all items from your cart?',
//                               ),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () =>
//                                       Navigator.pop(context, false),
//                                   child: const Text('Cancel'),
//                                 ),
//                                 ElevatedButton(
//                                   onPressed: () => Navigator.pop(context, true),
//                                   child: const Text('Confirm'),
//                                 ),
//                               ],
//                             ),
//                           );
//                           if (confirm == true) {
//                             await cartController.clearCartInSupabase();
//                             _updateSubtotal();
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red,
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                         ),
//                         child: const Text(
//                           'Delete All Items',
//                           style: TextStyle(fontSize: 16, color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               }),
//               SizedBox(height: screenHeight * 0.02),
//               _buildSectionTitle('Delivery Option', screenWidth),
//               _buildDeliveryOption(
//                 'Delivery',
//                 'FREE',
//                 _selectedDeliveryOption == 'Delivery',
//                 () => setState(() => _selectedDeliveryOption = 'Delivery'),
//                 screenWidth,
//                 screenHeight,
//               ),
//               if (_selectedDeliveryOption == 'Delivery') ...[
//                 SizedBox(height: screenHeight * 0.02),
//                 _buildSectionTitle('Delivery Location', screenWidth),
//                 _buildDeliveryLocation(
//                   screenWidth,
//                   screenHeight,
//                   addressController,
//                 ),
//               ],
//               SizedBox(height: screenHeight * 0.02),
//               _buildSectionTitle('Payment Method', screenWidth),
//               _buildPaymentMethod(
//                 'Cash on Delivery',
//                 Icons.money,
//                 _selectedPaymentMethod == 'Cash on Delivery',
//                 () =>
//                     setState(() => _selectedPaymentMethod = 'Cash on Delivery'),
//                 screenWidth,
//                 screenHeight,
//               ),
//               SizedBox(height: screenHeight * 0.02),
//               _buildSectionTitle('Order Summary', screenWidth),
//               _buildOrderSummary(screenWidth),
//               SizedBox(height: screenHeight * 0.03),
//               ElevatedButton(
//                 onPressed: _isLoading
//                     ? null
//                     : () async {
//                         final defaultAddress =
//                             addressController.getDefaultAddress();
//                         if (_selectedDeliveryOption == 'Delivery' &&
//                             defaultAddress == null) {
//                           Get.snackbar(
//                             'Error',
//                             'Please set a default address for delivery.',
//                             snackPosition: SnackPosition.BOTTOM,
//                             backgroundColor: Colors.red,
//                             colorText: Colors.white,
//                           );
//                           return;
//                         }
//                         if (cartController.cartItems.isEmpty) {
//                           Get.snackbar(
//                             'Error',
//                             'Your cart is empty. Add items to proceed.',
//                             snackPosition: SnackPosition.BOTTOM,
//                             backgroundColor: Colors.red,
//                             colorText: Colors.white,
//                           );
//                           return;
//                         }
//                         final confirm = await showDialog<bool>(
//                           context: context,
//                           builder: (context) => AlertDialog(
//                             title: const Text('Confirm Order'),
//                             content: const Text(
//                               'Are you sure you want to place this order?',
//                             ),
//                             actions: [
//                               TextButton(
//                                 onPressed: () => Navigator.pop(context, false),
//                                 child: const Text('Cancel'),
//                               ),
//                               ElevatedButton(
//                                 onPressed: () => Navigator.pop(context, true),
//                                 child: const Text('Confirm'),
//                               ),
//                             ],
//                           ),
//                         );
//                         if (confirm != true) return;
//                         setState(() => _isLoading = true);
//                         try {
//                           // Prepare order details
//                           final fullName = defaultAddress?.fullName ?? '';
//                           final address = defaultAddress != null
//                               ? '${defaultAddress.flatHouseNo}, ${defaultAddress.area}, ${defaultAddress.street}, ${defaultAddress.cityTown}, ${defaultAddress.pincode}'
//                               : '';
//                           final phoneNumber = defaultAddress?.mobileNumber ?? '';

//                           bool success = await cartController.placeOrder(
//                             fullName: fullName,
//                             address: address,
//                             phoneNumber: phoneNumber,
//                             subtotal: _dynamicSubtotal,
//                             tax: tax,
//                             deliveryFee: deliveryFee,
//                             total: total,
//                             paymentMethod: _selectedPaymentMethod,
//                           );

//                           setState(() => _isLoading = false);
//                           if (success) {
//                             Get.snackbar(
//                               'Success',
//                               'Order placed successfully! Your order has been stored.',
//                               snackPosition: SnackPosition.TOP,
//                               duration: const Duration(seconds: 2),
//                               backgroundColor: Colors.green,
//                               colorText: Colors.white,
//                             );
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     const OrderStatusPage(isSuccess: true),
//                               ),
//                             );
//                           } else {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => OrderStatusPage(
//                                   isSuccess: false,
//                                   onTryAgain: () => Navigator.pop(context),
//                                 ),
//                               ),
//                             );
//                           }
//                         } catch (e) {
//                           setState(() => _isLoading = false);
//                           Get.snackbar(
//                             'Error',
//                             'Failed to place order: $e',
//                             snackPosition: SnackPosition.BOTTOM,
//                             backgroundColor: Colors.red,
//                             colorText: Colors.white,
//                           );
//                         }
//                       },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.orangeAccent[700],
//                   padding: EdgeInsets.symmetric(
//                     vertical: screenHeight * 0.02,
//                     horizontal: screenWidth * 0.1,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 child: _isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : Text(
//                         'Checkout Rs.${total.toStringAsFixed(2)}',
//                         style: TextStyle(
//                           fontSize: screenWidth * 0.045,
//                           color: Colors.white,
//                         ),
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: NavigationMenu(
//         currentIndex: 2,
//         onTap: (index) {
//           if (index == 0) {
//             Navigator.popUntil(context, (route) => route.isFirst);
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title, double screenWidth) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
//       child: Text(
//         title,
//         style: TextStyle(
//           fontSize: screenWidth * 0.045,
//           fontWeight: FontWeight.bold,
//           color: Colors.black,
//         ),
//       ),
//     );
//   }

//   Widget _buildDeliveryOption(
//     String title,
//     String subtitle,
//     bool isSelected,
//     VoidCallback onTap,
//     double screenWidth,
//     double screenHeight,
//   ) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
//         padding: EdgeInsets.all(screenWidth * 0.04),
//         decoration: BoxDecoration(
//           color: Colors.grey[100],
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: isSelected ? Colors.orangeAccent[700]! : Colors.transparent,
//             width: 2,
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.04,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 Text(
//                   subtitle,
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.035,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//             Radio<String>(
//               value: title,
//               groupValue: _selectedDeliveryOption,
//               onChanged: (value) =>
//                   setState(() => _selectedDeliveryOption = value!),
//               activeColor: Colors.orangeAccent[700],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDeliveryLocation(
//     double screenWidth,
//     double screenHeight,
//     AddressController addressController,
//   ) {
//     return Obx(() {
//       final defaultAddress = addressController.getDefaultAddress();
//       if (defaultAddress == null) {
//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const AddressPage()),
//             );
//           },
//           child: Container(
//             padding: EdgeInsets.all(screenWidth * 0.04),
//             decoration: BoxDecoration(
//               color: Colors.grey[100],
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: const Text(
//               'No default address set. Tap to add one.',
//               style: TextStyle(color: Colors.grey),
//             ),
//           ),
//         );
//       }
//       return Container(
//         padding: EdgeInsets.all(screenWidth * 0.04),
//         decoration: BoxDecoration(
//           color: Colors.grey[100],
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   defaultAddress.fullName,
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.04,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   '${defaultAddress.flatHouseNo}, ${defaultAddress.area}, ${defaultAddress.street}',
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.035,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 Text(
//                   '${defaultAddress.cityTown}, ${defaultAddress.pincode}',
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.035,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 Text(
//                   'Mobile: ${defaultAddress.mobileNumber}',
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.035,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const AddressPage()),
//                 );
//               },
//               child: Text(
//                 'Change',
//                 style: TextStyle(color: Colors.orangeAccent[700]),
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }

//   Widget _buildPaymentMethod(
//     String title,
//     IconData icon,
//     bool isSelected,
//     VoidCallback onTap,
//     double screenWidth,
//     double screenHeight,
//   ) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
//         padding: EdgeInsets.all(screenWidth * 0.04),
//         decoration: BoxDecoration(
//           color: Colors.grey[100],
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: isSelected ? Colors.orangeAccent[700]! : Colors.transparent,
//             width: 2,
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Icon(icon, size: screenWidth * 0.06, color: Colors.black),
//                 SizedBox(width: screenWidth * 0.02),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.04,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             Radio<String>(
//               value: title,
//               groupValue: _selectedPaymentMethod,
//               onChanged: (value) =>
//                   setState(() => _selectedPaymentMethod = value!),
//               activeColor: Colors.orangeAccent[700],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOrderSummary(double screenWidth) {
//     return Container(
//       padding: EdgeInsets.all(screenWidth * 0.04),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         children: [
//           _buildSummaryRow('Subtotal', _dynamicSubtotal, screenWidth),
//           _buildSummaryRow('Tax', tax, screenWidth),
//           _buildSummaryRow(
//             _selectedDeliveryOption == 'Delivery'
//                 ? 'Delivery'
//                 : 'In-Store Pick Up',
//             deliveryFee,
//             screenWidth,
//           ),
//           const Divider(),
//           _buildSummaryRow('Total:', total, screenWidth, isTotal: true),
//         ],
//       ),
//     );
//   }

//   Widget _buildSummaryRow(
//     String title,
//     double amount,
//     double screenWidth, {
//     bool isTotal = false,
//   }) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: screenWidth * 0.01),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: screenWidth * 0.04,
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//           Text(
//             'Rs.${amount.toStringAsFixed(2)}',
//             style: TextStyle(
//               fontSize: screenWidth * 0.04,
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }















// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:valuebuyin/controllers/address_controller.dart';
// import 'package:valuebuyin/nav_bar.dart';
// import 'package:valuebuyin/pages/address/address_page.dart';
// import 'package:valuebuyin/pages/adress/address_page.dart';
// import 'package:valuebuyin/pages/cart/cart_controller.dart';
// import 'package:valuebuyin/pages/order_status_page.dart';

// class CheckoutPage extends StatefulWidget {
//   final Map<String, List<Map<String, dynamic>>> cartItems;
//   final double subtotal;

//   const CheckoutPage({
//     required this.cartItems,
//     required this.subtotal,
//     super.key,
//   });

//   @override
//   _CheckoutPageState createState() => _CheckoutPageState();
// }

// class _CheckoutPageState extends State<CheckoutPage> {
//   String _selectedDeliveryOption = 'Delivery';
//   String _selectedPaymentMethod = 'Cash on Delivery';
//   bool _isLoading = false;
//   double _dynamicSubtotal = 0.0;

//   double get tax => _dynamicSubtotal * 0.004;
//   double get deliveryFee => _selectedDeliveryOption == 'Delivery' ? 50.0 : 0.0;
//   double get total => _dynamicSubtotal + tax + deliveryFee;

//   @override
//   void initState() {
//     super.initState();
//     Get.find<AddressController>().fetchAddresses();
//     _dynamicSubtotal = widget.subtotal;
//   }

//   void _updateSubtotal() {
//     // Recalculate subtotal based on widget.cartItems
//     double newSubtotal = 0.0;
//     widget.cartItems.forEach((category, products) {
//       newSubtotal += products.fold(
//         0,
//         (sum, product) => sum + (product['total_price'] as double),
//       );
//     });
//     setState(() {
//       _dynamicSubtotal = newSubtotal;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double screenHeight = MediaQuery.of(context).size.height;
//     final CartController cartController = Get.find<CartController>();
//     final AddressController addressController = Get.find<AddressController>();

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text(
//           'Checkout',
//           style: TextStyle(color: Colors.black, fontSize: 24),
//           textAlign: TextAlign.center,
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.orangeAccent[700]),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(screenWidth * 0.04),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildSectionTitle('Selected Items', screenWidth),
//               // Directly use widget.cartItems without Obx since it's not reactive
//               widget.cartItems.isEmpty
//                   ? const Center(
//                       child: Text(
//                         'No selected items',
//                         style: TextStyle(fontSize: 16, color: Colors.grey),
//                       ),
//                     )
//                   : Column(
//                       children: [
//                         ...widget.cartItems.entries.map((entry) {
//                           final category = entry.key;
//                           final products = entry.value;
//                           return ExpansionTile(
//                             title: Text(
//                               category,
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 16),
//                             ),
//                             children: products.map((product) {
//                               return Card(
//                                 elevation: 2,
//                                 margin: const EdgeInsets.symmetric(
//                                     horizontal: 8, vertical: 4),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 child: ListTile(
//                                   contentPadding: EdgeInsets.all(8),
//                                   leading: product['image_url'] != null
//                                       ? ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                           child: Image.network(
//                                             product['image_url'],
//                                             width: 50,
//                                             height: 50,
//                                             fit: BoxFit.cover,
//                                             errorBuilder: (context, error,
//                                                     stackTrace) =>
//                                                 const Icon(Icons.broken_image),
//                                           ),
//                                         )
//                                       : const Icon(Icons.image, size: 50),
//                                   title: Text(
//                                     product['product_name'],
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 16),
//                                   ),
//                                   subtitle: Text(
//                                     'Weight: ${product['weight']} kg\nPrice: Rs. ${product['total_price'].toStringAsFixed(2)}',
//                                     style: TextStyle(
//                                         fontSize: 14, color: Colors.grey[600]),
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                           );
//                         }).toList(),
//                       ],
//                     ),
//               SizedBox(height: screenHeight * 0.02),
//               _buildSectionTitle('Delivery Option', screenWidth),
//               _buildDeliveryOption(
//                 'Delivery',
//                 'FREE (Rs. 50 if applicable)',
//                 _selectedDeliveryOption == 'Delivery',
//                 () => setState(() => _selectedDeliveryOption = 'Delivery'),
//                 screenWidth,
//                 screenHeight,
//               ),
//               if (_selectedDeliveryOption == 'Delivery') ...[
//                 SizedBox(height: screenHeight * 0.02),
//                 _buildSectionTitle('Delivery Location', screenWidth),
//                 _buildDeliveryLocation(
//                   screenWidth,
//                   screenHeight,
//                   addressController,
//                 ),
//               ],
//               SizedBox(height: screenHeight * 0.02),
//               _buildSectionTitle('Payment Method', screenWidth),
//               _buildPaymentMethod(
//                 'Cash on Delivery',
//                 Icons.money,
//                 _selectedPaymentMethod == 'Cash on Delivery',
//                 () =>
//                     setState(() => _selectedPaymentMethod = 'Cash on Delivery'),
//                 screenWidth,
//                 screenHeight,
//               ),
//               SizedBox(height: screenHeight * 0.02),
//               _buildSectionTitle('Order Summary', screenWidth),
//               _buildOrderSummary(screenWidth),
//               SizedBox(height: screenHeight * 0.03),
//               ElevatedButton(
//                 onPressed: _isLoading
//                     ? null
//                     : () async {
//                         final defaultAddress =
//                             addressController.getDefaultAddress();
//                         if (_selectedDeliveryOption == 'Delivery' &&
//                             defaultAddress == null) {
//                           Get.snackbar(
//                             'Error',
//                             'Please set a default address for delivery.',
//                             snackPosition: SnackPosition.BOTTOM,
//                             backgroundColor: Colors.red,
//                             colorText: Colors.white,
//                           );
//                           return;
//                         }
//                         if (widget.cartItems.isEmpty) {
//                           Get.snackbar(
//                             'Error',
//                             'No items selected. Please select items to proceed.',
//                             snackPosition: SnackPosition.BOTTOM,
//                             backgroundColor: Colors.red,
//                             colorText: Colors.white,
//                           );
//                           return;
//                         }
//                         final confirm = await showDialog<bool>(
//                           context: context,
//                           builder: (context) => AlertDialog(
//                             title: const Text('Confirm Order'),
//                             content: const Text(
//                               'Are you sure you want to place this order?',
//                             ),
//                             actions: [
//                               TextButton(
//                                 onPressed: () => Navigator.pop(context, false),
//                                 child: const Text('Cancel'),
//                               ),
//                               ElevatedButton(
//                                 onPressed: () => Navigator.pop(context, true),
//                                 child: const Text('Confirm'),
//                               ),
//                             ],
//                           ),
//                         );
//                         if (confirm != true) return;
//                         setState(() => _isLoading = true);
//                         try {
//                           // Prepare order details
//                           final fullName = defaultAddress?.fullName ?? '';
//                           final address = defaultAddress != null
//                               ? '${defaultAddress.flatHouseNo}, ${defaultAddress.area}, ${defaultAddress.street}, ${defaultAddress.cityTown}, ${defaultAddress.pincode}'
//                               : '';
//                           final phoneNumber = defaultAddress?.mobileNumber ?? '';

//                           bool success = await cartController.placeOrder(
//                             fullName: fullName,
//                             address: address,
//                             phoneNumber: phoneNumber,
//                             subtotal: _dynamicSubtotal,
//                             tax: tax,
//                             deliveryFee: deliveryFee,
//                             total: total,
//                             paymentMethod: _selectedPaymentMethod,
//                           );

//                           setState(() => _isLoading = false);
//                           if (success) {
//                             Get.snackbar(
//                               'Success',
//                               'Order placed successfully! Your order has been stored.',
//                               snackPosition: SnackPosition.TOP,
//                               duration: const Duration(seconds: 2),
//                               backgroundColor: Colors.green,
//                               colorText: Colors.white,
//                             );
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     const OrderStatusPage(isSuccess: true),
//                               ),
//                             );
//                           } else {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => OrderStatusPage(
//                                   isSuccess: false,
//                                   onTryAgain: () => Navigator.pop(context),
//                                 ),
//                               ),
//                             );
//                           }
//                         } catch (e) {
//                           setState(() => _isLoading = false);
//                           Get.snackbar(
//                             'Error',
//                             'Failed to place order: $e',
//                             snackPosition: SnackPosition.BOTTOM,
//                             backgroundColor: Colors.red,
//                             colorText: Colors.white,
//                           );
//                         }
//                       },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.orangeAccent[700],
//                   padding: EdgeInsets.symmetric(
//                     vertical: screenHeight * 0.02,
//                     horizontal: screenWidth * 0.1,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 child: _isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : Text(
//                         'Checkout Rs.${total.toStringAsFixed(2)}',
//                         style: TextStyle(
//                           fontSize: screenWidth * 0.045,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: NavigationMenu(
//         currentIndex: 2,
//         onTap: (index) {
//           if (index == 0) {
//             Navigator.popUntil(context, (route) => route.isFirst);
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title, double screenWidth) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
//       child: Text(
//         title,
//         style: TextStyle(
//           fontSize: screenWidth * 0.045,
//           fontWeight: FontWeight.bold,
//           color: Colors.black87,
//         ),
//       ),
//     );
//   }

//   Widget _buildDeliveryOption(
//     String title,
//     String subtitle,
//     bool isSelected,
//     VoidCallback onTap,
//     double screenWidth,
//     double screenHeight,
//   ) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
//         padding: EdgeInsets.all(screenWidth * 0.04),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 1,
//               blurRadius: 5,
//               offset: const Offset(0, 2),
//             ),
//           ],
//           border: Border.all(
//             color: isSelected ? Colors.orangeAccent[700]! : Colors.transparent,
//             width: 2,
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.04,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 Text(
//                   subtitle,
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.035,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//             Radio<String>(
//               value: title,
//               groupValue: _selectedDeliveryOption,
//               onChanged: (value) =>
//                   setState(() => _selectedDeliveryOption = value!),
//               activeColor: Colors.orangeAccent[700],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDeliveryLocation(
//     double screenWidth,
//     double screenHeight,
//     AddressController addressController,
//   ) {
//     return Obx(() {
//       final defaultAddress = addressController.getDefaultAddress();
//       if (defaultAddress == null) {
//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const AddressPage()),
//             );
//           },
//           child: Container(
//             padding: EdgeInsets.all(screenWidth * 0.04),
//             decoration: BoxDecoration(
//               color: Colors.grey[100],
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 5,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'No default address set. Tap to add one.',
//                   style: TextStyle(color: Colors.grey[600], fontSize: 14),
//                 ),
//                 Icon(Icons.add, color: Colors.orangeAccent[700]),
//               ],
//             ),
//           ),
//         );
//       }
//       return Container(
//         padding: EdgeInsets.all(screenWidth * 0.04),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 1,
//               blurRadius: 5,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   defaultAddress.fullName,
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.04,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 Text(
//                   '${defaultAddress.flatHouseNo}, ${defaultAddress.area}, ${defaultAddress.street}',
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.035,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 Text(
//                   '${defaultAddress.cityTown}, ${defaultAddress.pincode}',
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.035,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 Text(
//                   'Mobile: ${defaultAddress.mobileNumber}',
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.035,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const AddressPage()),
//                 );
//               },
//               child: Text(
//                 'Change',
//                 style: TextStyle(color: Colors.orangeAccent[700], fontSize: 14),
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }

//   Widget _buildPaymentMethod(
//     String title,
//     IconData icon,
//     bool isSelected,
//     VoidCallback onTap,
//     double screenWidth,
//     double screenHeight,
//   ) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
//         padding: EdgeInsets.all(screenWidth * 0.04),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 1,
//               blurRadius: 5,
//               offset: const Offset(0, 2),
//             ),
//           ],
//           border: Border.all(
//             color: isSelected ? Colors.orangeAccent[700]! : Colors.transparent,
//             width: 2,
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Icon(icon, size: screenWidth * 0.06, color: Colors.black87),
//                 SizedBox(width: screenWidth * 0.02),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.04,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ],
//             ),
//             Radio<String>(
//               value: title,
//               groupValue: _selectedPaymentMethod,
//               onChanged: (value) =>
//                   setState(() => _selectedPaymentMethod = value!),
//               activeColor: Colors.orangeAccent[700],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOrderSummary(double screenWidth) {
//     return Container(
//       padding: EdgeInsets.all(screenWidth * 0.04),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           _buildSummaryRow('Subtotal', _dynamicSubtotal, screenWidth),
//           _buildSummaryRow('Tax (0.4%)', tax, screenWidth),
//           _buildSummaryRow(
//             _selectedDeliveryOption == 'Delivery' ? 'Delivery Fee' : 'Pick Up',
//             deliveryFee,
//             screenWidth,
//           ),
//           Divider(color: Colors.grey[300]),
//           _buildSummaryRow('Total:', total, screenWidth, isTotal: true),
//         ],
//       ),
//     );
//   }

//   Widget _buildSummaryRow(
//     String title,
//     double amount,
//     double screenWidth, {
//     bool isTotal = false,
//   }) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: screenWidth * 0.01),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: screenWidth * 0.04,
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//               color: isTotal ? Colors.black87 : Colors.grey[600],
//             ),
//           ),
//           Text(
//             'Rs.${amount.toStringAsFixed(2)}',
//             style: TextStyle(
//               fontSize: screenWidth * 0.04,
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//               color: isTotal ? Colors.black87 : Colors.grey[600],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }













// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:valuebuyin/controllers/address_controller.dart';
// import 'package:valuebuyin/nav_bar.dart';
// import 'package:valuebuyin/pages/address/address_page.dart';
// import 'package:valuebuyin/pages/adress/address_page.dart';
// import 'package:valuebuyin/pages/cart/cart_controller.dart';
// import 'package:valuebuyin/pages/order_status_page.dart';

// class CheckoutPage extends StatefulWidget {
//   final Map<String, List<Map<String, dynamic>>> cartItems;
//   final double subtotal;

//   const CheckoutPage({
//     required this.cartItems,
//     required this.subtotal,
//     super.key,
//   });

//   @override
//   _CheckoutPageState createState() => _CheckoutPageState();
// }

// class _CheckoutPageState extends State<CheckoutPage> {
//   String _selectedDeliveryOption = 'Delivery';
//   String _selectedPaymentMethod = 'Cash on Delivery';
//   bool _isOnlinePayment = false;
//   String _selectedOnlinePaymentMethod = 'UPI';
//   bool _isLoading = false;
//   double _dynamicSubtotal = 0.0;
//   int? _selectedAddressId; // Changed from String? to int? to match address.id type

//   double get tax => _dynamicSubtotal * 0.004;
//   double get deliveryFee => _selectedDeliveryOption == 'Delivery' ? 50.0 : 0.0;
//   double get total => _dynamicSubtotal + tax + deliveryFee;

//   @override
//   void initState() {
//     super.initState();
//     Get.find<AddressController>().fetchAddresses();
//     _dynamicSubtotal = widget.subtotal;
//     // Set default address if available
//     final addressController = Get.find<AddressController>();
//     final defaultAddress = addressController.getDefaultAddress();
//     if (defaultAddress != null) {
//       _selectedAddressId = defaultAddress.id;
//     }
//   }

//   void _updateSubtotal() {
//     double newSubtotal = 0.0;
//     widget.cartItems.forEach((category, products) {
//       newSubtotal += products.fold(
//         0,
//         (sum, product) => sum + (product['total_price'] as double),
//       );
//     });
//     setState(() {
//       _dynamicSubtotal = newSubtotal;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double screenHeight = MediaQuery.of(context).size.height;
//     final CartController cartController = Get.find<CartController>();
//     final AddressController addressController = Get.find<AddressController>();

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text(
//           'Checkout',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//           textAlign: TextAlign.center,
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.orangeAccent[700]),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(screenWidth * 0.04),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildSectionTitle('Selected Items', screenWidth),
//               widget.cartItems.isEmpty
//                   ? const Center(
//                       child: Text(
//                         'No selected items',
//                         style: TextStyle(fontSize: 16, color: Colors.grey),
//                       ),
//                     )
//                   : Column(
//                       children: widget.cartItems.entries.map((entry) {
//                         final category = entry.key;
//                         final products = entry.value;
//                         return ExpansionTile(
//                           title: Text(
//                             category,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                           children: products.map((product) {
//                             return Card(
//                               elevation: 2,
//                               margin: const EdgeInsets.symmetric(
//                                   horizontal: 8, vertical: 4),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: ListTile(
//                                 contentPadding: const EdgeInsets.all(8),
//                                 leading: product['image_url'] != null
//                                     ? ClipRRect(
//                                         borderRadius: BorderRadius.circular(8),
//                                         child: Image.network(
//                                           product['image_url'],
//                                           width: 50,
//                                           height: 50,
//                                           fit: BoxFit.cover,
//                                           errorBuilder:
//                                               (context, error, stackTrace) =>
//                                                   const Icon(Icons.broken_image),
//                                         ),
//                                       )
//                                     : const Icon(Icons.image, size: 50),
//                                 title: Text(
//                                   product['product_name'],
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 subtitle: Text(
//                                   'Weight: ${product['weight']} kg\nPrice: Rs. ${product['total_price'].toStringAsFixed(2)}',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.grey[600],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         );
//                       }).toList(),
//                     ),
//               SizedBox(height: screenHeight * 0.02),
//               _buildSectionTitle('Delivery Option', screenWidth),
//               _buildDeliveryOption(
//                 'Delivery',
//                 'FREE (Rs. 50 if applicable)',
//                 _selectedDeliveryOption == 'Delivery',
//                 () => setState(() => _selectedDeliveryOption = 'Delivery'),
//                 screenWidth,
//                 screenHeight,
//               ),
//               if (_selectedDeliveryOption == 'Delivery') ...[
//                 SizedBox(height: screenHeight * 0.02),
//                 _buildSectionTitle('Select Delivery Address', screenWidth),
//                 _buildAddressDropdown(
//                   screenWidth,
//                   screenHeight,
//                   addressController,
//                 ),
//               ],
//               SizedBox(height: screenHeight * 0.02),
//               _buildSectionTitle('Payment Method', screenWidth),
//               _buildPaymentMethodSection(
//                 screenWidth,
//                 screenHeight,
//               ),
//               SizedBox(height: screenHeight * 0.02),
//               _buildSectionTitle('Order Summary', screenWidth),
//               _buildOrderSummary(screenWidth),
//               SizedBox(height: screenHeight * 0.03),
//               ElevatedButton(
//                 onPressed: _isLoading
//                     ? null
//                     : () async {
//                         final selectedAddress = addressController.addresses
//                             .firstWhereOrNull(
//                                 (address) => address.id == _selectedAddressId);
//                         if (_selectedDeliveryOption == 'Delivery' &&
//                             selectedAddress == null) {
//                           Get.snackbar(
//                             'Error',
//                             'Please select a delivery address.',
//                             snackPosition: SnackPosition.BOTTOM,
//                             backgroundColor: Colors.red,
//                             colorText: Colors.white,
//                           );
//                           return;
//                         }
//                         if (widget.cartItems.isEmpty) {
//                           Get.snackbar(
//                             'Error',
//                             'No items selected. Please select items to proceed.',
//                             snackPosition: SnackPosition.BOTTOM,
//                             backgroundColor: Colors.red,
//                             colorText: Colors.white,
//                           );
//                           return;
//                         }
//                         final confirm = await showDialog<bool>(
//                           context: context,
//                           builder: (context) => AlertDialog(
//                             title: const Text('Confirm Order'),
//                             content: const Text(
//                               'Are you sure you want to place this order?',
//                             ),
//                             actions: [
//                               TextButton(
//                                 onPressed: () => Navigator.pop(context, false),
//                                 child: const Text('Cancel'),
//                               ),
//                               ElevatedButton(
//                                 onPressed: () => Navigator.pop(context, true),
//                                 child: const Text('Confirm'),
//                               ),
//                             ],
//                           ),
//                         );
//                         if (confirm != true) return;
//                         setState(() => _isLoading = true);
//                         try {
//                           final fullName = selectedAddress?.fullName ?? '';
//                           final address = selectedAddress != null
//                               ? '${selectedAddress.flatHouseNo}, ${selectedAddress.area}, ${selectedAddress.street}, ${selectedAddress.cityTown}, ${selectedAddress.pincode}'
//                               : '';
//                           final phoneNumber =
//                               selectedAddress?.mobileNumber ?? '';
//                           final paymentMethod = _isOnlinePayment
//                               ? _selectedOnlinePaymentMethod
//                               : _selectedPaymentMethod;

//                           bool success = await cartController.placeOrder(
//                             fullName: fullName,
//                             address: address,
//                             phoneNumber: phoneNumber,
//                             subtotal: _dynamicSubtotal,
//                             tax: tax,
//                             deliveryFee: deliveryFee,
//                             total: total,
//                             paymentMethod: paymentMethod,
//                           );

//                           setState(() => _isLoading = false);
//                           if (success) {
//                             Get.snackbar(
//                               'Success',
//                               'Order placed successfully! Your order has been stored.',
//                               snackPosition: SnackPosition.TOP,
//                               duration: const Duration(seconds: 2),
//                               backgroundColor: Colors.green,
//                               colorText: Colors.white,
//                             );
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     const OrderStatusPage(isSuccess: true),
//                               ),
//                             );
//                           } else {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => OrderStatusPage(
//                                   isSuccess: false,
//                                   onTryAgain: () => Navigator.pop(context),
//                                 ),
//                               ),
//                             );
//                           }
//                         } catch (e) {
//                           setState(() => _isLoading = false);
//                           Get.snackbar(
//                             'Error',
//                             'Failed to place order: $e',
//                             snackPosition: SnackPosition.BOTTOM,
//                             backgroundColor: Colors.red,
//                             colorText: Colors.white,
//                           );
//                         }
//                       },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.orangeAccent[700],
//                   padding: EdgeInsets.symmetric(
//                     vertical: screenHeight * 0.02,
//                     horizontal: screenWidth * 0.1,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   elevation: 5,
//                 ),
//                 child: _isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : Text(
//                         'Checkout Rs.${total.toStringAsFixed(2)}',
//                         style: TextStyle(
//                           fontSize: screenWidth * 0.045,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: NavigationMenu(
//         currentIndex: 2,
//         onTap: (index) {
//           if (index == 0) {
//             Navigator.popUntil(context, (route) => route.isFirst);
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title, double screenWidth) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
//       child: Text(
//         title,
//         style: TextStyle(
//           fontSize: screenWidth * 0.045,
//           fontWeight: FontWeight.bold,
//           color: Colors.black87,
//         ),
//       ),
//     );
//   }

//   Widget _buildDeliveryOption(
//     String title,
//     String subtitle,
//     bool isSelected,
//     VoidCallback onTap,
//     double screenWidth,
//     double screenHeight,
//   ) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
//         padding: EdgeInsets.all(screenWidth * 0.04),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 1,
//               blurRadius: 5,
//               offset: const Offset(0, 2),
//             ),
//           ],
//           border: Border.all(
//             color: isSelected ? Colors.orangeAccent[700]! : Colors.transparent,
//             width: 2,
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.04,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 Text(
//                   subtitle,
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.035,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//             Radio<String>(
//               value: title,
//               groupValue: _selectedDeliveryOption,
//               onChanged: (value) =>
//                   setState(() => _selectedDeliveryOption = value!),
//               activeColor: Colors.orangeAccent[700],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAddressDropdown(
//     double screenWidth,
//     double screenHeight,
//     AddressController addressController,
//   ) {
//     return Obx(() {
//       final addresses = addressController.addresses;
//       if (addresses.isEmpty) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: EdgeInsets.all(screenWidth * 0.04),
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.1),
//                     spreadRadius: 1,
//                     blurRadius: 5,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: const Text(
//                 'No addresses available',
//                 style: TextStyle(color: Colors.grey, fontSize: 16),
//               ),
//             ),
//             SizedBox(height: screenHeight * 0.01),
//             TextButton.icon(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const AddressPage()),
//                 );
//               },
//               icon: Icon(Icons.add, color: Colors.orangeAccent[700]),
//               label: Text(
//                 'Add New Address',
//                 style:
//                     TextStyle(color: Colors.orangeAccent[700], fontSize: 14),
//               ),
//             ),
//           ],
//         );
//       }

//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 5,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//               border: Border.all(color: Colors.grey[300]!, width: 1),
//             ),
//             child: DropdownButton<int>(
//               value: _selectedAddressId,
//               hint: const Text('Select an address'),
//               isExpanded: true,
//               underline: const SizedBox(),
//               items: addresses.map((address) {
//                 return DropdownMenuItem<int>(
//                   value: address.id,
//                   child: Text(
//                     '${address.fullName}, ${address.flatHouseNo}, ${address.area}, ${address.cityTown}',
//                     style: TextStyle(
//                       fontSize: screenWidth * 0.04,
//                       color: Colors.black87,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedAddressId = value;
//                 });
//               },
//             ),
//           ),
//           SizedBox(height: screenHeight * 0.01),
//           TextButton.icon(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const AddressPage()),
//               );
//             },
//             icon: Icon(Icons.add, color: Colors.orangeAccent[700]),
//             label: Text(
//               'Add New Address',
//               style: TextStyle(color: Colors.orangeAccent[700], fontSize: 14),
//             ),
//           ),
//         ],
//       );
//     });
//   }

//   Widget _buildPaymentMethodSection(double screenWidth, double screenHeight) {
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: () {
//             setState(() {
//               _selectedPaymentMethod = 'Cash on Delivery';
//               _isOnlinePayment = false;
//             });
//           },
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 300),
//             margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
//             padding: EdgeInsets.all(screenWidth * 0.04),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 5,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//               border: Border.all(
//                 color: _selectedPaymentMethod == 'Cash on Delivery' &&
//                         !_isOnlinePayment
//                     ? Colors.orangeAccent[700]!
//                     : Colors.transparent,
//                 width: 2,
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.money,
//                         size: screenWidth * 0.06, color: Colors.black87),
//                     SizedBox(width: screenWidth * 0.02),
//                     Text(
//                       'Cash on Delivery',
//                       style: TextStyle(
//                         fontSize: screenWidth * 0.04,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Radio<String>(
//                   value: 'Cash on Delivery',
//                   groupValue: _isOnlinePayment ? '' : _selectedPaymentMethod,
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedPaymentMethod = value!;
//                       _isOnlinePayment = false;
//                     });
//                   },
//                   activeColor: Colors.orangeAccent[700],
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Row(
//           children: [
//             Checkbox(
//               value: _isOnlinePayment,
//               onChanged: (value) {
//                 setState(() {
//                   _isOnlinePayment = value!;
//                   if (_isOnlinePayment) {
//                     _selectedPaymentMethod = _selectedOnlinePaymentMethod;
//                   } else {
//                     _selectedPaymentMethod = 'Cash on Delivery';
//                   }
//                 });
//               },
//               activeColor: Colors.orangeAccent[700],
//             ),
//             const Text(
//               'Pay Online',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//           ],
//         ),
//         if (_isOnlinePayment)
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
//             margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 5,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//               border: Border.all(color: Colors.grey[300]!, width: 1),
//             ),
//             child: DropdownButton<String>(
//               value: _selectedOnlinePaymentMethod,
//               isExpanded: true,
//               underline: const SizedBox(),
//               items: ['UPI', 'Debit Card', 'Credit Card'].map((method) {
//                 return DropdownMenuItem<String>(
//                   value: method,
//                   child: Row(
//                     children: [
//                       Icon(
//                         method == 'UPI'
//                             ? Icons.payment
//                             : method == 'Debit Card'
//                                 ? Icons.credit_card
//                                 : Icons.credit_score,
//                         color: Colors.orangeAccent[700],
//                       ),
//                       SizedBox(width: screenWidth * 0.02),
//                       Text(
//                         method,
//                         style: TextStyle(
//                           fontSize: screenWidth * 0.04,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedOnlinePaymentMethod = value!;
//                   _selectedPaymentMethod = value;
//                 });
//               },
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildOrderSummary(double screenWidth) {
//     return Container(
//       padding: EdgeInsets.all(screenWidth * 0.04),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           _buildSummaryRow('Subtotal', _dynamicSubtotal, screenWidth),
//           _buildSummaryRow('Tax (0.4%)', tax, screenWidth),
//           _buildSummaryRow(
//             _selectedDeliveryOption == 'Delivery' ? 'Delivery Fee' : 'Pick Up',
//             deliveryFee,
//             screenWidth,
//           ),
//           Divider(color: Colors.grey[300]),
//           _buildSummaryRow('Total:', total, screenWidth, isTotal: true),
//         ],
//       ),
//     );
//   }

//   Widget _buildSummaryRow(
//     String title,
//     double amount,
//     double screenWidth, {
//     bool isTotal = false,
//   }) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: screenWidth * 0.01),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: screenWidth * 0.04,
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//               color: isTotal ? Colors.black87 : Colors.grey[600],
//             ),
//           ),
//           Text(
//             'Rs.${amount.toStringAsFixed(2)}',
//             style: TextStyle(
//               fontSize: screenWidth * 0.04,
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//               color: isTotal ? Colors.black87 : Colors.grey[600],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }









// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:valuebuyin/controllers/address_controller.dart';
// import 'package:valuebuyin/nav_bar.dart';
// import 'package:valuebuyin/pages/address/address_page.dart';
// import 'package:valuebuyin/pages/adress/address_page.dart';
// import 'package:valuebuyin/pages/cart/cart_controller.dart';
// import 'package:valuebuyin/pages/order_status_page.dart';

// class CheckoutPage extends StatefulWidget {
//   final Map<String, List<Map<String, dynamic>>> cartItems;
//   final double subtotal;

//   const CheckoutPage({
//     required this.cartItems,
//     required this.subtotal,
//     super.key,
//   });

//   @override
//   _CheckoutPageState createState() => _CheckoutPageState();
// }

// class _CheckoutPageState extends State<CheckoutPage> {
//   String _selectedDeliveryOption = 'Delivery';
//   String _selectedPaymentMethod = 'Cash on Delivery';
//   bool _isOnlinePayment = false;
//   String _selectedOnlinePaymentMethod = 'UPI';
//   bool _isLoading = false;
//   double _dynamicSubtotal = 0.0;
//   int? _selectedAddressId;

//   double get tax => _dynamicSubtotal * 0.004;
//   double get deliveryFee => _selectedDeliveryOption == 'Delivery' ? 50.0 : 0.0;
//   double get total => _dynamicSubtotal + tax + deliveryFee;

//   @override
//   void initState() {
//     super.initState();
//     Get.find<AddressController>().fetchAddresses();
//     _dynamicSubtotal = widget.subtotal;
//     // Automatically select the first address if available
//     final addressController = Get.find<AddressController>();
//     addressController.fetchAddresses().then((_) {
//       final addresses = addressController.addresses;
//       if (addresses.isNotEmpty) {
//         setState(() {
//           final defaultAddress = addressController.getDefaultAddress() ?? addresses[0];
//           _selectedAddressId = defaultAddress.id;
//         });
//       }
//     });
//     _updateSubtotal();
//   }

//   void _updateSubtotal() {
//     double newSubtotal = 0.0;
//     widget.cartItems.forEach((category, products) {
//       newSubtotal += products.fold(
//         0,
//         (sum, product) => sum + (product['total_price'] as double),
//       );
//     });
//     setState(() {
//       _dynamicSubtotal = newSubtotal;
//     });
//   }

//   void _deleteProduct(String category, Map<String, dynamic> product) {
//     final cartController = Get.find<CartController>();
//     cartController.removeProductFromCart(category, product);
//     setState(() {
//       widget.cartItems[category]?.remove(product);
//       if (widget.cartItems[category]?.isEmpty ?? false) {
//         widget.cartItems.remove(category);
//       }
//     });
//     _updateSubtotal();
//     Get.snackbar(
//       'Success',
//       '${product['product_name']} removed from cart.',
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double screenHeight = MediaQuery.of(context).size.height;
//     final CartController cartController = Get.find<CartController>();
//     final AddressController addressController = Get.find<AddressController>();

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text(
//           'Checkout',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//           textAlign: TextAlign.center,
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.orangeAccent[700]),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(screenWidth * 0.04),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildSectionTitle('Selected Items', screenWidth),
//               widget.cartItems.isEmpty
//                   ? const Center(
//                       child: Text(
//                         'No selected items',
//                         style: TextStyle(fontSize: 16, color: Colors.grey),
//                       ),
//                     )
//                   : Column(
//                       children: widget.cartItems.entries.map((entry) {
//                         final category = entry.key;
//                         final products = entry.value;
//                         return ExpansionTile(
//                           title: Text(
//                             category,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                           children: products.map((product) {
//                             return Card(
//                               elevation: 2,
//                               margin: const EdgeInsets.symmetric(
//                                   horizontal: 8, vertical: 4),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: ListTile(
//                                 contentPadding: const EdgeInsets.all(8),
//                                 leading: product['image_url'] != null
//                                     ? ClipRRect(
//                                         borderRadius: BorderRadius.circular(8),
//                                         child: Image.network(
//                                           product['image_url'],
//                                           width: 50,
//                                           height: 50,
//                                           fit: BoxFit.cover,
//                                           errorBuilder:
//                                               (context, error, stackTrace) =>
//                                                   const Icon(Icons.broken_image),
//                                         ),
//                                       )
//                                     : const Icon(Icons.image, size: 50),
//                                 title: Text(
//                                   product['product_name'],
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 subtitle: Text(
//                                   'Weight: ${product['weight']} kg\nPrice: Rs. ${product['total_price'].toStringAsFixed(2)}',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.grey[600],
//                                   ),
//                                 ),
//                                 trailing: IconButton(
//                                   icon: Icon(
//                                     Icons.delete,
//                                     color: Colors.redAccent,
//                                   ),
//                                   onPressed: () {
//                                     _deleteProduct(category, product);
//                                   },
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         );
//                       }).toList(),
//                     ),
//               SizedBox(height: screenHeight * 0.02),
//               _buildSectionTitle('Delivery Option', screenWidth),
//               _buildDeliveryOption(
//                 'Delivery',
//                 'FREE (Rs. 50 if applicable)',
//                 _selectedDeliveryOption == 'Delivery',
//                 () => setState(() => _selectedDeliveryOption = 'Delivery'),
//                 screenWidth,
//                 screenHeight,
//               ),
//               if (_selectedDeliveryOption == 'Delivery') ...[
//                 SizedBox(height: screenHeight * 0.02),
//                 _buildSectionTitle('Select Delivery Address', screenWidth),
//                 _buildAddressDropdown(
//                   screenWidth,
//                   screenHeight,
//                   addressController,
//                 ),
//               ],
//               SizedBox(height: screenHeight * 0.02),
//               _buildSectionTitle('Payment Method', screenWidth),
//               _buildPaymentMethodSection(
//                 screenWidth,
//                 screenHeight,
//               ),
//               SizedBox(height: screenHeight * 0.02),
//               _buildSectionTitle('Order Summary', screenWidth),
//               _buildOrderSummary(screenWidth),
//               SizedBox(height: screenHeight * 0.03),
//               ElevatedButton(
//                 onPressed: _isLoading
//                     ? null
//                     : () async {
//                         final selectedAddress = addressController.addresses
//                             .firstWhereOrNull(
//                                 (address) => address.id == _selectedAddressId);
//                         if (_selectedDeliveryOption == 'Delivery' &&
//                             selectedAddress == null) {
//                           Get.snackbar(
//                             'Error',
//                             'Please select a delivery address.',
//                             snackPosition: SnackPosition.BOTTOM,
//                             backgroundColor: Colors.red,
//                             colorText: Colors.white,
//                           );
//                           return;
//                         }
//                         if (widget.cartItems.isEmpty) {
//                           Get.snackbar(
//                             'Error',
//                             'No items selected. Please select items to proceed.',
//                             snackPosition: SnackPosition.BOTTOM,
//                             backgroundColor: Colors.red,
//                             colorText: Colors.white,
//                           );
//                           return;
//                         }
//                         final confirm = await showDialog<bool>(
//                           context: context,
//                           builder: (context) => AlertDialog(
//                             title: const Text('Confirm Order'),
//                             content: const Text(
//                               'Are you sure you want to place this order?',
//                             ),
//                             actions: [
//                               TextButton(
//                                 onPressed: () => Navigator.pop(context, false),
//                                 child: const Text('Cancel'),
//                               ),
//                               ElevatedButton(
//                                 onPressed: () => Navigator.pop(context, true),
//                                 child: const Text('Confirm'),
//                               ),
//                             ],
//                           ),
//                         );
//                         if (confirm != true) return;
//                         setState(() => _isLoading = true);
//                         try {
//                           final fullName = selectedAddress?.fullName ?? '';
//                           final address = selectedAddress != null
//                               ? '${selectedAddress.flatHouseNo}, ${selectedAddress.area}, ${selectedAddress.street}, ${selectedAddress.cityTown}, ${selectedAddress.pincode}'
//                               : '';
//                           final phoneNumber =
//                               selectedAddress?.mobileNumber ?? '';
//                           final paymentMethod = _isOnlinePayment
//                               ? _selectedOnlinePaymentMethod
//                               : _selectedPaymentMethod;

//                           bool success = await cartController.placeOrder(
//                             fullName: fullName,
//                             address: address,
//                             phoneNumber: phoneNumber,
//                             subtotal: _dynamicSubtotal,
//                             tax: tax,
//                             deliveryFee: deliveryFee,
//                             total: total,
//                             paymentMethod: paymentMethod,
//                           );

//                           setState(() => _isLoading = false);
//                           if (success) {
//                             Get.snackbar(
//                               'Success',
//                               'Order placed successfully! Your order has been stored.',
//                               snackPosition: SnackPosition.TOP,
//                               duration: const Duration(seconds: 2),
//                               backgroundColor: Colors.green,
//                               colorText: Colors.white,
//                             );
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     const OrderStatusPage(isSuccess: true),
//                               ),
//                             );
//                           } else {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => OrderStatusPage(
//                                   isSuccess: false,
//                                   onTryAgain: () => Navigator.pop(context),
//                                 ),
//                               ),
//                             );
//                           }
//                         } catch (e) {
//                           setState(() => _isLoading = false);
//                           Get.snackbar(
//                             'Error',
//                             'Failed to place order: $e',
//                             snackPosition: SnackPosition.BOTTOM,
//                             backgroundColor: Colors.red,
//                             colorText: Colors.white,
//                           );
//                         }
//                       },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.orangeAccent[700],
//                   padding: EdgeInsets.symmetric(
//                     vertical: screenHeight * 0.02,
//                     horizontal: screenWidth * 0.1,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   elevation: 5,
//                 ),
//                 child: _isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : Text(
//                         'Checkout Rs.${total.toStringAsFixed(2)}',
//                         style: TextStyle(
//                           fontSize: screenWidth * 0.045,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: NavigationMenu(
//         currentIndex: 2,
//         onTap: (index) {
//           if (index == 0) {
//             Navigator.popUntil(context, (route) => route.isFirst);
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title, double screenWidth) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
//       child: Text(
//         title,
//         style: TextStyle(
//           fontSize: screenWidth * 0.045,
//           fontWeight: FontWeight.bold,
//           color: Colors.black87,
//         ),
//       ),
//     );
//   }

//   Widget _buildDeliveryOption(
//     String title,
//     String subtitle,
//     bool isSelected,
//     VoidCallback onTap,
//     double screenWidth,
//     double screenHeight,
//   ) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
//         padding: EdgeInsets.all(screenWidth * 0.04),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 1,
//               blurRadius: 5,
//               offset: const Offset(0, 2),
//             ),
//           ],
//           border: Border.all(
//             color: isSelected ? Colors.orangeAccent[700]! : Colors.transparent,
//             width: 2,
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.04,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 Text(
//                   subtitle,
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.035,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//             Radio<String>(
//               value: title,
//               groupValue: _selectedDeliveryOption,
//               onChanged: (value) =>
//                   setState(() => _selectedDeliveryOption = value!),
//               activeColor: Colors.orangeAccent[700],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAddressDropdown(
//     double screenWidth,
//     double screenHeight,
//     AddressController addressController,
//   ) {
//     return Obx(() {
//       final addresses = addressController.addresses;
//       if (addresses.isEmpty) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: EdgeInsets.all(screenWidth * 0.04),
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.1),
//                     spreadRadius: 1,
//                     blurRadius: 5,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: const Text(
//                 'No addresses available',
//                 style: TextStyle(color: Colors.grey, fontSize: 16),
//               ),
//             ),
//             SizedBox(height: screenHeight * 0.01),
//             TextButton.icon(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const AddressPage()),
//                 );
//               },
//               icon: Icon(Icons.add, color: Colors.orangeAccent[700]),
//               label: Text(
//                 'Add New Address',
//                 style:
//                     TextStyle(color: Colors.orangeAccent[700], fontSize: 14),
//               ),
//             ),
//           ],
//         );
//       }

//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 5,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//               border: Border.all(color: Colors.grey[300]!, width: 1),
//             ),
//             child: DropdownButton<int>(
//               value: _selectedAddressId,
//               hint: const Text('Select an address'),
//               isExpanded: true,
//               underline: const SizedBox(),
//               items: addresses.map((address) {
//                 return DropdownMenuItem<int>(
//                   value: address.id,
//                   child: Text(
//                     '${address.fullName}, ${address.flatHouseNo}, ${address.area}, ${address.cityTown}',
//                     style: TextStyle(
//                       fontSize: screenWidth * 0.04,
//                       color: Colors.black87,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedAddressId = value;
//                 });
//               },
//             ),
//           ),
//           SizedBox(height: screenHeight * 0.01),
//           TextButton.icon(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const AddressPage()),
//               );
//             },
//             icon: Icon(Icons.add, color: Colors.orangeAccent[700]),
//             label: Text(
//               'Add New Address',
//               style: TextStyle(color: Colors.orangeAccent[700], fontSize: 14),
//             ),
//           ),
//         ],
//       );
//     });
//   }

//   Widget _buildPaymentMethodSection(double screenWidth, double screenHeight) {
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: () {
//             setState(() {
//               _selectedPaymentMethod = 'Cash on Delivery';
//               _isOnlinePayment = false;
//             });
//           },
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 300),
//             margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
//             padding: EdgeInsets.all(screenWidth * 0.04),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 5,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//               border: Border.all(
//                 color: _selectedPaymentMethod == 'Cash on Delivery' &&
//                         !_isOnlinePayment
//                     ? Colors.orangeAccent[700]!
//                     : Colors.transparent,
//                 width: 2,
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.money,
//                         size: screenWidth * 0.06, color: Colors.black87),
//                     SizedBox(width: screenWidth * 0.02),
//                     Text(
//                       'Cash on Delivery',
//                       style: TextStyle(
//                         fontSize: screenWidth * 0.04,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Radio<String>(
//                   value: 'Cash on Delivery',
//                   groupValue: _isOnlinePayment ? '' : _selectedPaymentMethod,
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedPaymentMethod = value!;
//                       _isOnlinePayment = false;
//                     });
//                   },
//                   activeColor: Colors.orangeAccent[700],
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Row(
//           children: [
//             Checkbox(
//               value: _isOnlinePayment,
//               onChanged: (value) {
//                 setState(() {
//                   _isOnlinePayment = value!;
//                   if (_isOnlinePayment) {
//                     _selectedPaymentMethod = _selectedOnlinePaymentMethod;
//                   } else {
//                     _selectedPaymentMethod = 'Cash on Delivery';
//                   }
//                 });
//               },
//               activeColor: Colors.orangeAccent[700],
//             ),
//             const Text(
//               'Pay Online',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//           ],
//         ),
//         if (_isOnlinePayment)
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
//             margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 5,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//               border: Border.all(color: Colors.grey[300]!, width: 1),
//             ),
//             child: DropdownButton<String>(
//               value: _selectedOnlinePaymentMethod,
//               isExpanded: true,
//               underline: const SizedBox(),
//               items: ['UPI', 'Debit Card', 'Credit Card'].map((method) {
//                 return DropdownMenuItem<String>(
//                   value: method,
//                   child: Row(
//                     children: [
//                       Icon(
//                         method == 'UPI'
//                             ? Icons.payment
//                             : method == 'Debit Card'
//                                 ? Icons.credit_card
//                                 : Icons.credit_score,
//                         color: Colors.orangeAccent[700],
//                       ),
//                       SizedBox(width: screenWidth * 0.02),
//                       Text(
//                         method,
//                         style: TextStyle(
//                           fontSize: screenWidth * 0.04,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedOnlinePaymentMethod = value!;
//                   _selectedPaymentMethod = value;
//                 });
//               },
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildOrderSummary(double screenWidth) {
//     return Container(
//       padding: EdgeInsets.all(screenWidth * 0.04),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           _buildSummaryRow('Subtotal', _dynamicSubtotal, screenWidth),
//           _buildSummaryRow('Tax (0.4%)', tax, screenWidth),
//           _buildSummaryRow(
//             _selectedDeliveryOption == 'Delivery' ? 'Delivery Fee' : 'Pick Up',
//             deliveryFee,
//             screenWidth,
//           ),
//           Divider(color: Colors.grey[300]),
//           _buildSummaryRow('Total:', total, screenWidth, isTotal: true),
//         ],
//       ),
//     );
//   }

//   Widget _buildSummaryRow(
//     String title,
//     double amount,
//     double screenWidth, {
//     bool isTotal = false,
//   }) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: screenWidth * 0.01),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: screenWidth * 0.04,
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//               color: isTotal ? Colors.black87 : Colors.grey[600],
//             ),
//           ),
//           Text(
//             'Rs.${amount.toStringAsFixed(2)}',
//             style: TextStyle(
//               fontSize: screenWidth * 0.04,
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//               color: isTotal ? Colors.black87 : Colors.grey[600],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
















// import 'package:cashfree_pg/cashfree_payment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:valuebuyin/controllers/address_controller.dart';
import 'package:valuebuyin/nav_bar.dart';
import 'package:valuebuyin/pages/address/address_page.dart';
import 'package:valuebuyin/pages/adress/address_page.dart';
import 'package:valuebuyin/pages/cart/cart_controller.dart';
import 'package:valuebuyin/pages/order_status_page.dart';
import 'package:valuebuyin/services/payment_service.dart';
import 'package:uuid/uuid.dart';

class CheckoutPage extends StatefulWidget {
  final Map<String, List<Map<String, dynamic>>> cartItems;
  final double subtotal;

  const CheckoutPage({
    required this.cartItems,
    required this.subtotal,
    super.key,
  });

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _selectedDeliveryOption = 'Delivery';
  String _selectedPaymentMethod = 'Cash on Delivery';
  bool _isOnlinePayment = false;
  String _selectedOnlinePaymentMethod = 'UPI';
  bool _isLoading = false;
  double _dynamicSubtotal = 0.0;
  int? _selectedAddressId;
  final PaymentService _paymentService = PaymentService();

  double get tax => _dynamicSubtotal * 0.004;
  double get deliveryFee => _selectedDeliveryOption == 'Delivery' ? 50.0 : 0.0;
  double get total => _dynamicSubtotal + tax + deliveryFee;
  
  get CashfreePayment => null;

  @override
  void initState() {
    super.initState();
    Get.find<AddressController>().fetchAddresses();
    _dynamicSubtotal = widget.subtotal;
    final addressController = Get.find<AddressController>();
    addressController.fetchAddresses().then((_) {
      final addresses = addressController.addresses;
      if (addresses.isNotEmpty) {
        setState(() {
          final defaultAddress = addressController.getDefaultAddress() ?? addresses[0];
          _selectedAddressId = defaultAddress.id;
        });
      }
    });
    _updateSubtotal();
  }

  void _updateSubtotal() {
    double newSubtotal = 0.0;
    widget.cartItems.forEach((category, products) {
      newSubtotal += products.fold(
        0,
        (sum, product) => sum + (product['total_price'] as double),
      );
    });
    setState(() {
      _dynamicSubtotal = newSubtotal;
    });
  }

  void _deleteProduct(String category, Map<String, dynamic> product) {
    final cartController = Get.find<CartController>();
    cartController.removeFromCart(category, product);
    setState(() {
      widget.cartItems[category]?.remove(product);
      if (widget.cartItems[category]?.isEmpty ?? false) {
        widget.cartItems.remove(category);
      }
    });
    _updateSubtotal();
    Get.snackbar(
      'Success',
      '${product['product_name']} removed from cart.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Future<void> _initiateCashfreePayment({
    required String fullName,
    required String phoneNumber,
    required String address,
  }) async {
    try {
      final orderId = 'ORD_${Uuid().v4()}';
      final customerId = Get.find<CartController>().supabase.auth.currentUser?.id ?? 'guest';
      final userEmail = Get.find<CartController>().supabase.auth.currentUser?.email ?? 'default@example.com';
      final customerEmail = userEmail.isNotEmpty ? userEmail : 'default@example.com';
      final customerPhone = phoneNumber;

      print('Initiating Cashfree payment for order: $orderId');

      final paymentSession = await _paymentService.createPaymentSession(
        orderId: orderId,
        amount: total,
        customerId: customerId,
        customerEmail: customerEmail,
        customerPhone: customerPhone,
      );

      final paymentSessionId = paymentSession['payment_session_id'];

      print('Payment session ID: $paymentSessionId');

      final result = await CashfreePayment.initializeWebPayment(
        paymentSessionId: paymentSessionId,
        environment: 'SANDBOX',
        onSuccess: (data) async {
          print('Payment successful: $data');
          final success = await Get.find<CartController>().placeOrder(
            fullName: fullName,
            address: address,
            phoneNumber: phoneNumber,
            subtotal: _dynamicSubtotal,
            tax: tax,
            deliveryFee: deliveryFee,
            total: total,
            paymentMethod: _selectedOnlinePaymentMethod,
          );

          if (success) {
            Get.snackbar(
              'Success',
              'Payment and order placed successfully!',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const OrderStatusPage(isSuccess: true),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderStatusPage(
                  isSuccess: false,
                  onTryAgain: () => Navigator.pop(context),
                ),
              ),
            );
          }
        },
        onFailure: (data) {
          print('Payment failed: $data');
          Get.snackbar(
            'Payment Failed',
            'Payment was not successful: ${data['error']}',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderStatusPage(
                isSuccess: false,
                onTryAgain: () => Navigator.pop(context),
              ),
            ),
          );
        },
      );

      if (result == null) {
        Get.snackbar(
          'Error',
          'Failed to initialize payment.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error in _initiateCashfreePayment: $e');
      Get.snackbar(
        'Error',
        'Payment initiation failed: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final CartController cartController = Get.find<CartController>();
    final AddressController addressController = Get.find<AddressController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.orangeAccent[700]),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Selected Items', screenWidth),
              widget.cartItems.isEmpty
                  ? const Center(
                      child: Text(
                        'No selected items',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : Column(
                      children: widget.cartItems.entries.map((entry) {
                        final category = entry.key;
                        final products = entry.value;
                        return ExpansionTile(
                          title: Text(
                            category,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          children: products.map((product) {
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(8),
                                leading: product['image_url'] != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          product['image_url'],
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(Icons.broken_image),
                                        ),
                                      )
                                    : const Icon(Icons.image, size: 50),
                                title: Text(
                                  product['product_name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  'Weight: ${product['weight']} kg\nPrice: Rs. ${product['total_price'].toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () {
                                    _deleteProduct(category, product);
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }).toList(),
                    ),
              SizedBox(height: screenHeight * 0.02),
              _buildSectionTitle('Delivery Option', screenWidth),
              _buildDeliveryOption(
                'Delivery',
                'FREE (Rs. 50 if applicable)',
                _selectedDeliveryOption == 'Delivery',
                () => setState(() => _selectedDeliveryOption = 'Delivery'),
                screenWidth,
                screenHeight,
              ),
              if (_selectedDeliveryOption == 'Delivery') ...[
                SizedBox(height: screenHeight * 0.02),
                _buildSectionTitle('Select Delivery Address', screenWidth),
                _buildAddressDropdown(
                  screenWidth,
                  screenHeight,
                  addressController,
                ),
              ],
              SizedBox(height: screenHeight * 0.02),
              _buildSectionTitle('Payment Method', screenWidth),
              _buildPaymentMethodSection(
                screenWidth,
                screenHeight,
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildSectionTitle('Order Summary', screenWidth),
              _buildOrderSummary(screenWidth),
              SizedBox(height: screenHeight * 0.03),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        final selectedAddress = addressController.addresses
                            .firstWhereOrNull(
                                (address) => address.id == _selectedAddressId);
                        if (_selectedDeliveryOption == 'Delivery' &&
                            selectedAddress == null) {
                          Get.snackbar(
                            'Error',
                            'Please select a delivery address.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return;
                        }
                        if (widget.cartItems.isEmpty) {
                          Get.snackbar(
                            'Error',
                            'No items selected. Please select items to proceed.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return;
                        }
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Order'),
                            content: const Text(
                              'Are you sure you want to place this order?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Confirm'),
                              ),
                            ],
                          ),
                        );
                        if (confirm != true) return;
                        setState(() => _isLoading = true);
                        try {
                          final fullName = selectedAddress?.fullName ?? '';
                          final address = selectedAddress != null
                              ? '${selectedAddress.flatHouseNo}, ${selectedAddress.area}, ${selectedAddress.street}, ${selectedAddress.cityTown}, ${selectedAddress.pincode}'
                              : '';
                          final phoneNumber =
                              selectedAddress?.mobileNumber ?? '';

                          if (_isOnlinePayment) {
                            await _initiateCashfreePayment(
                              fullName: fullName,
                              phoneNumber: phoneNumber,
                              address: address,
                            );
                          } else {
                            final success = await cartController.placeOrder(
                              fullName: fullName,
                              address: address,
                              phoneNumber: phoneNumber,
                              subtotal: _dynamicSubtotal,
                              tax: tax,
                              deliveryFee: deliveryFee,
                              total: total,
                              paymentMethod: _selectedPaymentMethod,
                            );

                            setState(() => _isLoading = false);
                            if (success) {
                              Get.snackbar(
                                'Success',
                                'Order placed successfully!',
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const OrderStatusPage(isSuccess: true),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderStatusPage(
                                    isSuccess: false,
                                    onTryAgain: () => Navigator.pop(context),
                                  ),
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          setState(() => _isLoading = false);
                          Get.snackbar(
                            'Error',
                            'Failed to process order: $e',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent[700],
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.02,
                    horizontal: screenWidth * 0.1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Checkout Rs.${total.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationMenu(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      child: Text(
        title,
        style: TextStyle(
          fontSize: screenWidth * 0.045,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildDeliveryOption(
    String title,
    String subtitle,
    bool isSelected,
    VoidCallback onTap,
    double screenWidth,
    double screenHeight,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: isSelected ? Colors.orangeAccent[700]! : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            Radio<String>(
              value: title,
              groupValue: _selectedDeliveryOption,
              onChanged: (value) =>
                  setState(() => _selectedDeliveryOption = value!),
              activeColor: Colors.orangeAccent[700],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressDropdown(
    double screenWidth,
    double screenHeight,
    AddressController addressController,
  ) {
    return Obx(() {
      final addresses = addressController.addresses;
      if (addresses.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(screenWidth * 0.04),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                'No addresses available',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddressPage()),
                );
              },
              icon: Icon(Icons.add, color: Colors.orangeAccent[700]),
              label: Text(
                'Add New Address',
                style:
                    TextStyle(color: Colors.orangeAccent[700], fontSize: 14),
              ),
            ),
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            child: DropdownButton<int>(
              value: _selectedAddressId,
              hint: const Text('Select an address'),
              isExpanded: true,
              underline: const SizedBox(),
              items: addresses.map((address) {
                return DropdownMenuItem<int>(
                  value: address.id,
                  child: Text(
                    '${address.fullName}, ${address.flatHouseNo}, ${address.area}, ${address.cityTown}',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedAddressId = value;
                });
              },
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddressPage()),
              );
            },
            icon: Icon(Icons.add, color: Colors.orangeAccent[700]),
            label: Text(
              'Add New Address',
              style: TextStyle(color: Colors.orangeAccent[700], fontSize: 14),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildPaymentMethodSection(double screenWidth, double screenHeight) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedPaymentMethod = 'Cash on Delivery';
              _isOnlinePayment = false;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
            padding: EdgeInsets.all(screenWidth * 0.04),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: _selectedPaymentMethod == 'Cash on Delivery' &&
                        !_isOnlinePayment
                    ? Colors.orangeAccent[700]!
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.money,
                        size: screenWidth * 0.06, color: Colors.black87),
                    SizedBox(width: screenWidth * 0.02),
                    Text(
                      'Cash on Delivery',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Radio<String>(
                  value: 'Cash on Delivery',
                  groupValue: _isOnlinePayment ? '' : _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                      _isOnlinePayment = false;
                    });
                  },
                  activeColor: Colors.orangeAccent[700],
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            Checkbox(
              value: _isOnlinePayment,
              onChanged: (value) {
                setState(() {
                  _isOnlinePayment = value!;
                  if (_isOnlinePayment) {
                    _selectedPaymentMethod = _selectedOnlinePaymentMethod;
                  } else {
                    _selectedPaymentMethod = 'Cash on Delivery';
                  }
                });
              },
              activeColor: Colors.orangeAccent[700],
            ),
            const Text(
              'Pay Online',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        if (_isOnlinePayment)
          Container(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            child: DropdownButton<String>(
              value: _selectedOnlinePaymentMethod,
              isExpanded: true,
              underline: const SizedBox(),
              items: ['UPI', 'Debit Card', 'Credit Card'].map((method) {
                return DropdownMenuItem<String>(
                  value: method,
                  child: Row(
                    children: [
                      Icon(
                        method == 'UPI'
                            ? Icons.payment
                            : method == 'Debit Card'
                                ? Icons.credit_card
                                : Icons.credit_score,
                        color: Colors.orangeAccent[700],
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Text(
                        method,
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedOnlinePaymentMethod = value!;
                  _selectedPaymentMethod = value;
                });
              },
            ),
          ),
      ],
    );
  }

  Widget _buildOrderSummary(double screenWidth) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow('Subtotal', _dynamicSubtotal, screenWidth),
          _buildSummaryRow('Tax (0.4%)', tax, screenWidth),
          _buildSummaryRow(
            _selectedDeliveryOption == 'Delivery' ? 'Delivery Fee' : 'Pick Up',
            deliveryFee,
            screenWidth,
          ),
          Divider(color: Colors.grey[300]),
          _buildSummaryRow('Total:', total, screenWidth, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String title,
    double amount,
    double screenWidth, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black87 : Colors.grey[600],
            ),
          ),
          Text(
            'Rs.${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black87 : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}