import 'dart:typed_data';

class PetImage {
  final int id;
  final int petId;
  final Uint8List image;
  final int position;

  const PetImage({
    required this.id,
    required this.petId,
    required this.image,
    required this.position,
  });

  PetImage copyWith({
    int? id,
    int? petId,
    Uint8List? image,
    int? position,
  }) {
    return PetImage(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      image: image ?? this.image,
      position: position ?? this.position,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pet_id': petId,
      'image': image,
      'position': position,
    };
  }

  factory PetImage.fromMap(Map<String, dynamic> map) {
    return PetImage(
      id: map['id'],
      petId: map['pet_id'],
      image: map['image'],
      position: map['position'],
    );
  }
}
