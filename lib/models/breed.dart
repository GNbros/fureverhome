class Breed {
  final int id;
  final int typeId;
  final String name;

  const Breed({required this.id, required this.typeId, required this.name});

  factory Breed.fromMap(Map<String, dynamic> map) {
    return Breed(
      id: map['id'],
      typeId: map['type_id'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type_id': typeId,
      'name': name,
    };
  }
}
