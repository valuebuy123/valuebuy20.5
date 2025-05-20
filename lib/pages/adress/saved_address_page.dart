


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:valuebuyin/controllers/address_controller.dart';
import 'package:valuebuyin/pages/adress/address_page.dart';
import 'package:valuebuyin/pages/adress/edit_address_page.dart';

class SavedAddressPage extends StatelessWidget {
  const SavedAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final AddressController addressController = Get.find<AddressController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.orangeAccent[700]),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Saved Addresses',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Expanded(
                child: addressController.addresses.isEmpty
                    ? const Center(
                        child: Text(
                          'No addresses saved yet.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: addressController.addresses.length,
                        itemBuilder: (context, index) {
                          final address = addressController.addresses[index];
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: EdgeInsets.symmetric(
                              vertical: screenWidth * 0.02,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(screenWidth * 0.04),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        address.fullName,
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit, color: Colors.orangeAccent[700]),
                                            onPressed: () {
                                              Get.to(() => EditAddressPage(address: address, index: index));
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete, color: Colors.red),
                                            onPressed: () async {
                                              await addressController.deleteAddress(address.id!);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: screenWidth * 0.01),
                                  Text(
                                    '${address.flatHouseNo}, ${address.area}, ${address.street}',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.035,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    '${address.cityTown}, ${address.pincode}',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.035,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    'Mobile: ${address.mobileNumber}',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.035,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  if (address.landmark.isNotEmpty)
                                    Text(
                                      'Landmark: ${address.landmark}',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.035,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  if (address.isDefault)
                                    Container(
                                      margin: EdgeInsets.only(top: screenWidth * 0.01),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.02,
                                        vertical: screenWidth * 0.01,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.orangeAccent[100],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        'Default Address',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.035,
                                          color: Colors.orangeAccent[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            ElevatedButton(
              onPressed: () {
                Get.to(() => const AddressPage());
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
              ),
              child: Text(
                'Add New Address',
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}