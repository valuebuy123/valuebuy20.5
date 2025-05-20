// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:valuebuyin/models/address.dart';

// class AddressController extends GetxController {
//   final supabase = Supabase.instance.client;
//   final RxList<Address> addresses = <Address>[].obs;
//   late RealtimeChannel _subscription;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchAddresses();
//     _subscribeToRealtime();
//   }

//   @override
//   void onClose() {
//     supabase.removeChannel(_subscription);
//     super.onClose();
//   }

//   void _subscribeToRealtime() {
//     final userId = supabase.auth.currentUser?.id;
//     if (userId == null) return;

//     _subscription = supabase
//         .channel('address_changes')
//         .onPostgresChanges(
//           event: PostgresChangeEvent.all,
//           schema: 'public',
//           table: 'address',
//           filter: PostgresChangeFilter(
//             type: PostgresChangeFilterType.eq,
//             column: 'user_id',
//             value: userId,
//           ),
//           callback: (payload) {
//             fetchAddresses();
//           },
//         )
//         .subscribe();
//   }

//   Future<void> fetchAddresses() async {
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) {
//         addresses.clear();
//         return;
//       }

//       final response = await supabase
//           .from('address')
//           .select(
//             'id, full_name, mobile_number, flat_house_no, area, street, landmark, pin_code, city_town, is_default',
//           )
//           .eq('user_id', userId)
//           .order('created_at', ascending: false);

//       if (response is List) {
//         addresses.assignAll(response.map((address) => Address.fromMap(address)).toList());
//       } else {
//         addresses.clear();
//       }
//     } catch (e) {
//       addresses.clear();
//     }
//   }

//   Future<bool> addAddress(Address address) async {
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) throw Exception('User not logged in');

//       if (address.fullName.isEmpty || address.mobileNumber.isEmpty || address.flatHouseNo.isEmpty ||
//           address.area.isEmpty || address.street.isEmpty || address.pincode.isEmpty || address.cityTown.isEmpty) {
//         throw Exception('All required fields must be filled');
//       }

//       if (address.isDefault) {
//         await supabase
//             .from('address')
//             .update({'is_default': false})
//             .eq('user_id', userId)
//             .eq('is_default', true);
//       }

//       await supabase.from('address').insert({
//         'user_id': userId,
//         'full_name': address.fullName,
//         'mobile_number': address.mobileNumber,
//         'flat_house_no': address.flatHouseNo,
//         'area': address.area,
//         'street': address.street,
//         'landmark': address.landmark,
//         'pin_code': address.pincode,
//         'city_town': address.cityTown,
//         'is_default': address.isDefault,
//       }).select();

//       await fetchAddresses();
//       return true;
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to save address: $e', backgroundColor: Colors.red, colorText: Colors.white);
//       return false;
//     }
//   }

//   Future<bool> updateAddress(int id, Address updatedAddress) async {
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) throw Exception('User not logged in');

//       if (updatedAddress.isDefault) {
//         await supabase
//             .from('address')
//             .update({'is_default': false})
//             .eq('user_id', userId)
//             .eq('is_default', true);
//       }

//       await supabase.from('address').update({
//         'full_name': updatedAddress.fullName,
//         'mobile_number': updatedAddress.mobileNumber,
//         'flat_house_no': updatedAddress.flatHouseNo,
//         'area': updatedAddress.area,
//         'street': updatedAddress.street,
//         'landmark': updatedAddress.landmark,
//         'pin_code': updatedAddress.pincode,
//         'city_town': updatedAddress.cityTown,
//         'is_default': updatedAddress.isDefault,
//       }).eq('id', id).eq('user_id', userId);

//       await fetchAddresses();
//       Get.snackbar('Success', 'Address updated successfully', backgroundColor: Colors.green, colorText: Colors.white);
//       return true;
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to update address: $e', backgroundColor: Colors.red, colorText: Colors.white);
//       return false;
//     }
//   }

//   Future<bool> deleteAddress(int id) async {
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) throw Exception('User not logged in');

//       await supabase.from('address').delete().eq('id', id).eq('user_id', userId);
//       await fetchAddresses();
//       Get.snackbar('Success', 'Address deleted successfully', backgroundColor: Colors.green, colorText: Colors.white);
//       return true;
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to delete address: $e', backgroundColor: Colors.red, colorText: Colors.white);
//       return false;
//     }
//   }

//   Address? getDefaultAddress() {
//     return addresses.firstWhereOrNull((address) => address.isDefault);
//   }
// }










import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:valuebuyin/models/address.dart';

class AddressController extends GetxController {
  final supabase = Supabase.instance.client;
  final RxList<Address> addresses = <Address>[].obs;
  late RealtimeChannel _subscription;

  get isLoading => null;

  @override
  void onInit() {
    super.onInit();
    fetchAddresses();
    _subscribeToRealtime();
  }

  @override
  void onClose() {
    supabase.removeChannel(_subscription);
    super.onClose();
  }

  void _subscribeToRealtime() {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    _subscription = supabase
        .channel('address_changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'address',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            fetchAddresses();
          },
        )
        .subscribe();
  }

  Future<void> fetchAddresses() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        addresses.clear();
        return;
      }

      final response = await supabase
          .from('address')
          .select(
            'id, full_name, mobile_number, flat_house_no, area, street, landmark, pin_code, city_town, is_default',
          )
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      if (response is List) {
        addresses.assignAll(response.map((address) => Address.fromMap(address)).toList());
      } else {
        addresses.clear();
      }
    } catch (e) {
      addresses.clear();
    }
  }

  Future<bool> addAddress(Address address) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      if (address.fullName.isEmpty || address.mobileNumber.isEmpty || address.flatHouseNo.isEmpty ||
          address.area.isEmpty || address.street.isEmpty || address.pincode.isEmpty || address.cityTown.isEmpty) {
        throw Exception('All required fields must be filled');
      }

      if (address.isDefault) {
        await supabase
            .from('address')
            .update({'is_default': false})
            .eq('user_id', userId)
            .eq('is_default', true);
      }

      await supabase.from('address').insert({
        'user_id': userId,
        'full_name': address.fullName,
        'mobile_number': address.mobileNumber,
        'flat_house_no': address.flatHouseNo,
        'area': address.area,
        'street': address.street,
        'landmark': address.landmark,
        'pin_code': address.pincode,
        'city_town': address.cityTown,
        'is_default': address.isDefault,
      }).select();

      await fetchAddresses();
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to save address: $e', backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
  }

  Future<bool> updateAddress(int id, Address updatedAddress) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      if (updatedAddress.isDefault) {
        await supabase
            .from('address')
            .update({'is_default': false})
            .eq('user_id', userId)
            .eq('is_default', true);
      }

      await supabase.from('address').update({
        'full_name': updatedAddress.fullName,
        'mobile_number': updatedAddress.mobileNumber,
        'flat_house_no': updatedAddress.flatHouseNo,
        'area': updatedAddress.area,
        'street': updatedAddress.street,
        'landmark': updatedAddress.landmark,
        'pin_code': updatedAddress.pincode,
        'city_town': updatedAddress.cityTown,
        'is_default': updatedAddress.isDefault,
      }).eq('id', id).eq('user_id', userId);

      await fetchAddresses();
      Get.snackbar('Success', 'Address updated successfully', backgroundColor: Colors.green, colorText: Colors.white);
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update address: $e', backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
  }

  Future<bool> deleteAddress(int id) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      await supabase.from('address').delete().eq('id', id).eq('user_id', userId);
      await fetchAddresses();
      Get.snackbar('Success', 'Address deleted successfully', backgroundColor: Colors.green, colorText: Colors.white);
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete address: $e', backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
  }

  Address? getDefaultAddress() {
    return addresses.firstWhereOrNull((address) => address.isDefault);
  }
}