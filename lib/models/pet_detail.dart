import 'package:fureverhome/models/pet_image.dart';

class PetDetail {
  final int id;
  final String petName;
  final int typeId;
  final int breedId;
  final int age;
  final String gender;
  final bool isVaccinated;
  final bool isSpayed;
  final bool isKidFriendly;
  final String description;
  final String location;
  final List<PetImage> images;  // Added images field


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
    this.images = const [],  // Initialize with an empty list
  });

  // CopyWith method to create a new instance with modified properties
  PetDetail copyWith({
    int? id,
    String? petName,
    int? typeId,
    int? breedId,
    int? age,
    String? gender,
    bool? isVaccinated,
    bool? isSpayed,
    bool? isKidFriendly,
    String? description,
    String? location,
    List<PetImage>? images,  // Add images to copyWith
  }) {
    return PetDetail(
      id: id ?? this.id,
      petName: petName ?? this.petName,
      typeId: typeId ?? this.typeId,
      breedId: breedId ?? this.breedId,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      isVaccinated: isVaccinated ?? this.isVaccinated,
      isSpayed: isSpayed ?? this.isSpayed,
      isKidFriendly: isKidFriendly ?? this.isKidFriendly,
      description: description ?? this.description,
      location: location ?? this.location,
      images: images ?? this.images,  // If no images provided, use current ones
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
      images: [],  // Initialize with an empty list
    );
  }
}
