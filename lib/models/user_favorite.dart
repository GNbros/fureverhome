class Favorite {
  final int userId;  // User ID of the person who favorited the pet
  final int petId;   // Pet ID of the pet that was favorited

  const Favorite({
    required this.userId,
    required this.petId,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'pet_id': petId,
    };
  }

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      userId: map['user_id'],
      petId: map['pet_id'],
    );
  }
}
