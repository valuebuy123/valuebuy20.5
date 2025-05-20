// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:valuebuyin/controllers/address_controller.dart';
// import 'package:valuebuyin/models/address.dart';
// import 'package:valuebuyin/nav_bar.dart';

// class EditAddressPage extends StatelessWidget {
//   final int index;

//   const EditAddressPage({required this.index, super.key});

//   @override
//   Widget build(BuildContext context) {
//     final AddressController addressController = Get.find<AddressController>();
//     final Address address = addressController.addresses[index];
//     final TextEditingController nameController = TextEditingController(text: address.fullName);
//     final TextEditingController streetController = TextEditingController(text: address.street);
//     final TextEditingController cityController = TextEditingController(text: address.cityTown);
//     final TextEditingController postalCodeController = TextEditingController(text: address.postalCode);
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
//           'Edit Address',
//           style: TextStyle(color: Colors.black, fontSize: 20),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(screenWidth * 0.04),
//         child: Column(
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: InputDecoration(
//                 labelText: 'Name',
//                 labelStyle: TextStyle(fontSize: screenWidth * 0.04),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//             SizedBox(height: screenHeight * 0.02),
//             TextField(
//               controller: streetController,
//               decoration: InputDecoration(
//                 labelText: 'Street',
//                 labelStyle: TextStyle(fontSize: screenWidth * 0.04),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//             SizedBox(height: screenHeight * 0.02),
//             TextField(
//               controller: cityController,
//               decoration: InputDecoration(
//                 labelText: 'City',
//                 labelStyle: TextStyle(fontSize: screenWidth * 0.04),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//             SizedBox(height: screenHeight * 0.02),
//             TextField(
//               controller: postalCodeController,
//               decoration: InputDecoration(
//                 labelText: 'Postal Code',
//                 labelStyle: TextStyle(fontSize: screenWidth * 0.04),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//             const Spacer(),
//             ElevatedButton(
//               onPressed: () {
//                 if (nameController.text.isEmpty ||
//                     streetController.text.isEmpty ||
//                     cityController.text.isEmpty ||
//                     postalCodeController.text.isEmpty) {
//                   Get.snackbar('Error', 'Please fill all fields',
//                       snackPosition: SnackPosition.BOTTOM);
//                   return;
//                 }
//                 addressController.updateAddress(
//                   index,
//                   Address(
//                     fullName: nameController.text,
//                     street: streetController.text,
//                     flatHouseNo: streetController.text,
//                     area: '',
//                     landmark: '',
//                     cityTown: cityController.text,
//                     pincode: postalCodeController.text,
//                     mobileNumber: '',
//                   ),
//                 );
//                 Get.back();
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orangeAccent[700],
//                 padding: EdgeInsets.symmetric(
//                   horizontal: screenWidth * 0.1,
//                   vertical: screenHeight * 0.02,
//                 ),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//               ),
//               child: Text(
//                 'Update Address',
//                 style: TextStyle(fontSize: screenWidth * 0.04),
//               ),
//             ),
//             SizedBox(height: screenHeight * 0.02),
//           ],
//         ),
//       ),
//       bottomNavigationBar: const NavigationMenu(currentIndex: 3), // Same as Profile
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:valuebuyin/controllers/address_controller.dart';
// import 'package:valuebuyin/models/address.dart';
// import 'package:valuebuyin/nav_bar.dart';

// class EditAddressPage extends StatelessWidget {
//   final int index;

//   const EditAddressPage({required this.index, super.key});

//   @override
//   Widget build(BuildContext context) {
//     final AddressController addressController = Get.find<AddressController>();
//     final Address address = addressController.addresses[index];
//     final TextEditingController fullNameController = TextEditingController(
//       text: address.fullName,
//     );
//     final TextEditingController mobileNumberController = TextEditingController(
//       text: address.mobileNumber,
//     );
//     final TextEditingController flatHouseNoController = TextEditingController(
//       text: address.flatHouseNo,
//     );
//     final TextEditingController areaController = TextEditingController(
//       text: address.area,
//     );
//     final TextEditingController streetController = TextEditingController(
//       text: address.street,
//     );
//     final TextEditingController landmarkController = TextEditingController(
//       text: address.landmark,
//     );
//     final TextEditingController pincodeController = TextEditingController(
//       text: address.pincode,
//     );
//     final TextEditingController cityTownController = TextEditingController(
//       text: address.cityTown,
//     );
//     final RxBool isDefault = address.isDefault.obs;

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
//           'Edit Address',
//           style: TextStyle(color: Colors.black, fontSize: 20),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(screenWidth * 0.04),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               _buildTextField(fullNameController, 'Full Name', screenWidth),
//               SizedBox(height: screenHeight * 0.02),
//               _buildTextField(
//                 mobileNumberController,
//                 'Mobile Number',
//                 screenWidth,
//                 keyboardType: TextInputType.phone,
//               ),
//               SizedBox(height: screenHeight * 0.02),
//               _buildTextField(
//                 flatHouseNoController,
//                 'Flat/House No.',
//                 screenWidth,
//               ),
//               SizedBox(height: screenHeight * 0.02),
//               _buildTextField(areaController, 'Area', screenWidth),
//               SizedBox(height: screenHeight * 0.02),
//               _buildTextField(streetController, 'Street', screenWidth),
//               SizedBox(height: screenHeight * 0.02),
//               _buildTextField(landmarkController, 'Landmark', screenWidth),
//               SizedBox(height: screenHeight * 0.02),
//               _buildTextField(
//                 pincodeController,
//                 'Pincode',
//                 screenWidth,
//                 keyboardType: TextInputType.number,
//               ),
//               SizedBox(height: screenHeight * 0.02),
//               _buildTextField(cityTownController, 'City/Town', screenWidth),
//               SizedBox(height: screenHeight * 0.02),
//               Obx(
//                 () => Row(
//                   children: [
//                     Checkbox(
//                       value: isDefault.value,
//                       onChanged: (value) => isDefault.value = value!,
//                       activeColor: Colors.orangeAccent[700],
//                     ),
//                     Text(
//                       'Make this my default address',
//                       style: TextStyle(fontSize: screenWidth * 0.04),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: screenHeight * 0.03),
//               ElevatedButton(
//                 onPressed: () {
//                   if (fullNameController.text.isEmpty ||
//                       mobileNumberController.text.isEmpty ||
//                       flatHouseNoController.text.isEmpty ||
//                       areaController.text.isEmpty ||
//                       streetController.text.isEmpty ||
//                       pincodeController.text.isEmpty ||
//                       cityTownController.text.isEmpty) {
//                     Get.snackbar(
//                       'Error',
//                       'Please fill all fields',
//                       snackPosition: SnackPosition.BOTTOM,
//                     );
//                     return;
//                   }
//                   final updatedAddress = Address(
//                     fullName: fullNameController.text,
//                     mobileNumber: mobileNumberController.text,
//                     flatHouseNo: flatHouseNoController.text,
//                     area: areaController.text,
//                     street: streetController.text,
//                     landmark: landmarkController.text,
//                     pincode: pincodeController.text,
//                     cityTown: cityTownController.text,
//                     isDefault: isDefault.value,
//                   );
//                   addressController.updateAddress(index, updatedAddress);
//                   Navigator.pop(context);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.orangeAccent[700],
//                   padding: EdgeInsets.symmetric(
//                     horizontal: screenWidth * 0.1,
//                     vertical: screenHeight * 0.02,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 child: Text(
//                   'Update Address',
//                   style: TextStyle(fontSize: screenWidth * 0.04),
//                 ),
//               ),
//               SizedBox(height: screenHeight * 0.02),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: const NavigationMenu(currentIndex: 3),
//     );
//   }

//   Widget _buildTextField(
//     TextEditingController controller,
//     String label,
//     double screenWidth, {
//     TextInputType? keyboardType,
//   }) {
//     return TextField(
//       controller: controller,
//       keyboardType: keyboardType ?? TextInputType.text,
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: TextStyle(fontSize: screenWidth * 0.04),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(color: Colors.orangeAccent[700]!, width: 2),
//         ),
//       ),
//     );
//   }
// }









import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:valuebuyin/controllers/address_controller.dart';
import 'package:valuebuyin/models/address.dart';

class EditAddressPage extends StatefulWidget {
  final Address address;

  const EditAddressPage({super.key, required this.address, required int index});

  @override
  _EditAddressPageState createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final _controllerFullName = TextEditingController();
  final _controllerMobileNumber = TextEditingController();
  final _controllerFlatHouseNo = TextEditingController();
  final _controllerArea = TextEditingController();
  final _controllerStreet = TextEditingController();
  final _controllerLandmark = TextEditingController();
  final _controllerPincode = TextEditingController();
  final _controllerCityTown = TextEditingController();
  var _isDefault = false.obs;

  @override
  void initState() {
    super.initState();
    _controllerFullName.text = widget.address.fullName;
    _controllerMobileNumber.text = widget.address.mobileNumber;
    _controllerFlatHouseNo.text = widget.address.flatHouseNo;
    _controllerArea.text = widget.address.area;
    _controllerStreet.text = widget.address.street;
    _controllerLandmark.text = widget.address.landmark;
    _controllerPincode.text = widget.address.pincode;
    _controllerCityTown.text = widget.address.cityTown;
    _isDefault.value = widget.address.isDefault;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final addressController = Get.find<AddressController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.orangeAccent[700]),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Address',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _controllerFullName,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: _controllerMobileNumber,
                  decoration: const InputDecoration(labelText: 'Mobile Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: _controllerFlatHouseNo,
                  decoration: const InputDecoration(labelText: 'Flat/House No'),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: _controllerArea,
                  decoration: const InputDecoration(labelText: 'Area'),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: _controllerStreet,
                  decoration: const InputDecoration(labelText: 'Street'),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: _controllerLandmark,
                  decoration: const InputDecoration(labelText: 'Landmark'),
                ),
                TextFormField(
                  controller: _controllerPincode,
                  decoration: const InputDecoration(labelText: 'Pincode'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: _controllerCityTown,
                  decoration: const InputDecoration(labelText: 'City/Town'),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                Obx(() => CheckboxListTile(
                      title: const Text('Set as Default'),
                      value: _isDefault.value,
                      onChanged: (value) => _isDefault.value = value ?? false,
                    )),
                SizedBox(height: screenWidth * 0.04),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final updatedAddress = Address(
                        id: widget.address.id,
                        fullName: _controllerFullName.text.trim(),
                        mobileNumber: _controllerMobileNumber.text.trim(),
                        flatHouseNo: _controllerFlatHouseNo.text.trim(),
                        area: _controllerArea.text.trim(),
                        street: _controllerStreet.text.trim(),
                        landmark: _controllerLandmark.text.trim(),
                        pincode: _controllerPincode.text.trim(),
                        cityTown: _controllerCityTown.text.trim(),
                        isDefault: _isDefault.value,
                      );
                      await addressController.updateAddress(widget.address.id!, updatedAddress);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent[700],
                    padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02, horizontal: screenWidth * 0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text(
                    'Save Changes',
                    style: TextStyle(fontSize: screenWidth * 0.045, color: Colors.white),
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