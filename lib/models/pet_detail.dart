import 'package:fureverhome/models/pet_image.dart';

class PetDetail {
  final int id;
  final String petName;
  final String petType;
  final int typeId;
  final String petBreed;
  final int breedId;
  final int age;
  final String gender;
  final bool isVaccinated;
  final bool isSpayed;
  final bool isKidFriendly;
  final String description;
  final String location;
  final int userId; 
  final List<PetImage> images;
  final DateTime? createdAt;

  const PetDetail({
    required this.id,
    required this.petName,
    required this.typeId,
    required this.breedId,
    required this.age,
    required this.gender,
    required this.isVaccinated,
    required this.isSpayed,
    required this.isKidFriendly,
    required this.description,
    required this.location,
    required this.userId, 
    this.petType = '',
    this.petBreed = '',
    this.images = const [],
    this.createdAt,
  });

  PetDetail copyWith({
    int? id,
    String? petName,
    String? petType,
    int? typeId,
    String? petBreed,
    int? breedId,
    int? age,
    String? gender,
    bool? isVaccinated,
    bool? isSpayed,
    bool? isKidFriendly,
    String? description,
    String? location,
    int? userId, 
    List<PetImage>? images,
    DateTime? createdAt,
  }) {
    return PetDetail(
      id: id ?? this.id,
      petName: petName ?? this.petName,
      petType: petType ?? this.petType,
      typeId: typeId ?? this.typeId,
      petBreed: petBreed ?? this.petBreed,
      breedId: breedId ?? this.breedId,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      isVaccinated: isVaccinated ?? this.isVaccinated,
      isSpayed: isSpayed ?? this.isSpayed,
      isKidFriendly: isKidFriendly ?? this.isKidFriendly,
      description: description ?? this.description,
      location: location ?? this.location,
      userId: userId ?? this.userId,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pet_name': petName,
      'type_id': typeId,
      'breed_id': breedId,
      'age': age,
      'gender': gender,
      'is_vaccinated': isVaccinated ? 1 : 0,
      'is_spayed': isSpayed ? 1 : 0,
      'is_kid_friendly': isKidFriendly ? 1 : 0,
      'description': description,
      'location': location,
      'user_id': userId,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory PetDetail.fromMap(Map<String, dynamic> map) {
    return PetDetail(
      id: map['id'],
      petName: map['pet_name'],
      typeId: map['type_id'],
      breedId: map['breed_id'],
      age: map['age'],
      gender: map['gender'],
      isVaccinated: map['is_vaccinated'] == 1,
      isSpayed: map['is_spayed'] == 1,
      isKidFriendly: map['is_kid_friendly'] == 1,
      description: map['description'],
      location: map['location'],
      userId: map['user_id'], // 🔹
      images: [],
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : null,
    );
  }
}
