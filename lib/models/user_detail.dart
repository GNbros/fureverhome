import 'dart:typed_data';

class UserDetail {
  final int? id;
  final String firebaseUid;
  final String name;
  final String phone;
  final String address;
  final Uint8List? profilePicture; // Add this

  UserDetail({
    this.id,
    required this.firebaseUid,
    required this.name,
    required this.phone,
    required this.address,
    this.profilePicture,
  });

  factory UserDetail.fromMap(Map<String, dynamic> map) {
    return UserDetail(
      id: map['id'],
      firebaseUid: map['firebase_uid'],
      name: map['name'],
      phone: map['phone'],
      address: map['address'],
      profilePicture: map['profile_picture'], // BLOB as Uint8List
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firebase_uid': firebaseUid,
      'name': name,
      'phone': phone,
      'address': address,
      'profile_picture': profilePicture,
    };
  }
}
