// class Address {
//   final String fullName;
//   final String mobileNumber;
//   final String flatHouseNo;
//   final String area;
//   final String street;
//   final String landmark;
//   final String pincode;
//   final String cityTown;
//   final bool isDefault;

//   Address({
//     required this.fullName,
//     required this.mobileNumber,
//     required this.flatHouseNo,
//     required this.area,
//     required this.street,
//     required this.landmark,
//     required this.pincode,
//     required this.cityTown,
//     this.isDefault = false,
//   });

//   factory Address.fromMap(Map<String, dynamic> map) {
//     return Address(
//       fullName: map['full_name'] ?? '',
//       mobileNumber: map['mobile_number'] ?? '',
//       flatHouseNo: map['flat_house_no'] ?? '',
//       area: map['area'] ?? '',
//       street: map['street'] ?? '',
//       landmark: map['landmark'] ?? '',
//       pincode: map['pin_code'] ?? '',
//       cityTown: map['city_town'] ?? '',
//       isDefault: map['is_default'] ?? false,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'full_name': fullName,
//       'mobile_number': mobileNumber,
//       'flat_house_no': flatHouseNo,
//       'area': area,
//       'street': street,
//       'landmark': landmark,
//       'pin_code': pincode,
//       'city_town': cityTown,
//       'is_default': isDefault,
//     };
//   }
// }







// class Address {
//   final int? id;
//   final String fullName;
//   final String mobileNumber;
//   final String flatHouseNo;
//   final String area;
//   final String street;
//   final String landmark;
//   final String pincode;
//   final String cityTown;
//   final bool isDefault;

//   Address({
//     this.id,
//     required this.fullName,
//     required this.mobileNumber,
//     required this.flatHouseNo,
//     required this.area,
//     required this.street,
//     required this.landmark,
//     required this.pincode,
//     required this.cityTown,
//     this.isDefault = false,
//   });

//   factory Address.fromMap(Map<String, dynamic> map) {
//     return Address(
//       id: map['id'],
//       fullName: map['full_name'] ?? '',
//       mobileNumber: map['mobile_number'] ?? '',
//     flatHouseNo: map['flat_house_no'] ?? '',
//       area: map['area'] ?? '',
//       street: map['street'] ?? '',
//       landmark: map['landmark'] ?? '',
//       pincode: map['pin_code'] ?? '',
//       cityTown: map['city_town'] ?? '',
//       isDefault: map['is_default'] ?? false,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'full_name': fullName,
//       'mobile_number': mobileNumber,
//       'flat_house_no': flatHouseNo,
//       'area': area,
//       'street': street,
//       'landmark': landmark,
//       'pin_code': pincode,
//       'city_town': cityTown,
//       'is_default': isDefault,
//     };
//   }
// }








class Address {
  final int id;
  final String fullName;
  final String mobileNumber;
  final String flatHouseNo;
  final String area;
  final String street;
  final String landmark;
  final String pincode;
  final String cityTown;
  final bool isDefault;

  Address({
    required this.id,
    required this.fullName,
    required this.mobileNumber,
    required this.flatHouseNo,
    required this.area,
    required this.street,
    required this.landmark,
    required this.pincode,
    required this.cityTown,
    required this.isDefault,
  });

  factory Address.fromMap(Map<String, dynamic> map) => Address(
    id: map['id'],
    fullName: map['full_name'],
    mobileNumber: map['mobile_number'],
    flatHouseNo: map['flat_house_no'],
    area: map['area'],
    street: map['street'] ?? '',
    landmark: map['landmark'] ?? '',
    pincode: map['pin_code'],
    cityTown: map['city_town'],
    isDefault: map['is_default'],
  );
}