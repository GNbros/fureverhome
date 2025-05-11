class PetType {
  final int id;
  final String name;

  const PetType({required this.id, required this.name});

  factory PetType.fromMap(Map<String, dynamic> map) {
    return PetType(id: map['id'], name: map['name']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }
}
