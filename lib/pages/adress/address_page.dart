// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:valuebuyin/controllers/address_controller.dart';
// import 'package:valuebuyin/models/address.dart';
// import 'package:valuebuyin/nav_bar.dart';


// class SavedAddressPage extends StatelessWidget {
//   const SavedAddressPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double screenHeight = MediaQuery.of(context).size.height;
//     final AddressController addressController = Get.find<AddressController>();

//     // Fetch addresses when the page is loaded
//     addressController.fetchAddresses();

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.orangeAccent[700]),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Saved Addresses',
//           style: TextStyle(color: Colors.black, fontSize: 20),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(screenWidth * 0.04),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Obx(
//               () => Expanded(
//                 child:
//                     addressController.addresses.isEmpty
//                         ? const Center(child: Text('No addresses saved yet.'))
//                         : ListView.builder(
//                           itemCount: addressController.addresses.length,
//                           itemBuilder: (context, index) {
//                             final address = addressController.addresses[index];
//                             return Card(
//                               margin: EdgeInsets.symmetric(
//                                 vertical: screenWidth * 0.02,
//                               ),
//                               child: Padding(
//                                 padding: EdgeInsets.all(screenWidth * 0.04),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       address.fullName,
//                                       style: TextStyle(
//                                         fontSize: screenWidth * 0.04,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     Text(
//                                       '${address.flatHouseNo}, ${address.area}, ${address.street}',
//                                       style: TextStyle(
//                                         fontSize: screenWidth * 0.035,
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                     Text(
//                                       '${address.cityTown}, ${address.pincode}',
//                                       style: TextStyle(
//                                         fontSize: screenWidth * 0.035,
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                     Text(
//                                       'Mobile: ${address.mobileNumber}',
//                                       style: TextStyle(
//                                         fontSize: screenWidth * 0.035,
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                     if (address.landmark.isNotEmpty)
//                                       Text(
//                                         'Landmark: ${address.landmark}',
//                                         style: TextStyle(
//                                           fontSize: screenWidth * 0.035,
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//               ),
//             ),
//             SizedBox(height: screenHeight * 0.02),
//             ElevatedButton(
//               onPressed: () {
//                 Get.to(() => const AddressPage());
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orangeAccent[700],
//                 padding: EdgeInsets.symmetric(
//                   vertical: screenHeight * 0.02,
//                   horizontal: screenWidth * 0.1,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//               ),
//               child: Text(
//                 'Add New Address',
//                 style: TextStyle(
//                   fontSize: screenWidth * 0.045,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
















import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:valuebuyin/controllers/address_controller.dart';
import 'package:valuebuyin/models/address.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AddressController addressController = Get.find<AddressController>();
    final formKey = GlobalKey<FormState>();
    final TextEditingController fullNameController = TextEditingController();
    final TextEditingController mobileNumberController = TextEditingController();
    final TextEditingController flatHouseNoController = TextEditingController();
    final TextEditingController areaController = TextEditingController();
    final TextEditingController streetController = TextEditingController();
    final TextEditingController landmarkController = TextEditingController();
    final TextEditingController pincodeController = TextEditingController();
    final TextEditingController cityTownController = TextEditingController();
    final RxBool isDefault = false.obs;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.orangeAccent[700]),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Address',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: fullNameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Full Name is required' : null,
                ),
                TextFormField(
                  controller: mobileNumberController,
                  decoration: const InputDecoration(labelText: 'Mobile Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value!.isEmpty ? 'Mobile Number is required' : null,
                ),
                TextFormField(
                  controller: flatHouseNoController,
                  decoration: const InputDecoration(labelText: 'Flat/House No'),
                  validator: (value) =>
                      value!.isEmpty ? 'Flat/House No is required' : null,
                ),
                TextFormField(
                  controller: areaController,
                  decoration: const InputDecoration(labelText: 'Area'),
                  validator: (value) =>
                      value!.isEmpty ? 'Area is required' : null,
                ),
                TextFormField(
                  controller: streetController,
                  decoration: const InputDecoration(labelText: 'Street'),
                  validator: (value) =>
                      value!.isEmpty ? 'Street is required' : null,
                ),
                TextFormField(
                  controller: landmarkController,
                  decoration: const InputDecoration(labelText: 'Landmark'),
                ),
                TextFormField(
                  controller: pincodeController,
                  decoration: const InputDecoration(labelText: 'Pincode'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Pincode is required' : null,
                ),
                TextFormField(
                  controller: cityTownController,
                  decoration: const InputDecoration(labelText: 'City/Town'),
                  validator: (value) =>
                      value!.isEmpty ? 'City/Town is required' : null,
                ),
                Obx(
                  () => CheckboxListTile(
                    title: const Text('Set as Default'),
                    value: isDefault.value,
                    onChanged: (value) => isDefault.value = value ?? false,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final address = Address(
                        fullName: fullNameController.text.trim(),
                        mobileNumber: mobileNumberController.text.trim(),
                        flatHouseNo: flatHouseNoController.text.trim(),
                        area: areaController.text.trim(),
                        street: streetController.text.trim(),
                        landmark: landmarkController.text.trim(),
                        pincode: pincodeController.text.trim(),
                        cityTown: cityTownController.text.trim(),
                        isDefault: isDefault.value, id: 0, // Replace 0 with an appropriate default value if needed
                      );
                      bool success = await addressController.addAddress(address);
                      if (success) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent[700],
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 30,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Save Address',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}