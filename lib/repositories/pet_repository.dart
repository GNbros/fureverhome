import 'package:fureverhome/services/database_service.dart';
import 'package:fureverhome/models/pet_detail.dart';
import 'package:fureverhome/models/pet_image.dart';

class PetRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Insert a new pet along with its images
  Future<int> insertPet(PetDetail pet, List<PetImage> images) async {
    final db = await _dbHelper.database;

    return await db.transaction((txn) async {
      final petId = await txn.insert('pet_details', pet.toMap());

      for (var i = 0; i < images.length; i++) {

        await txn.insert('pet_images', images[i].copyWith(petId: petId, position: i + 1).toMap());
      }

      return petId;
    });
  }
  
  // Fetch all pets
  Future<List<PetDetail>> getAllPets() async {
    final db = await _dbHelper.database;

    // Fetch part
    final List<Map<String, dynamic>> maps = await db.query('pet_details');
    final List<Map<String, dynamic>> imageMaps = await db.query(
      'pet_images',
      where: 'position = ?',
      whereArgs: [1],
      orderBy: 'pet_id ASC',
    );

    // Create a list of PetImage objects from the imageMaps
    final List<PetImage> petImages = imageMaps.map((map) => PetImage.fromMap(map)).toList();
    final List<PetDetail> pets = List.generate(maps.length, (i) {
      final pet = PetDetail.fromMap(maps[i]);
      // Find the corresponding image for the pet
      final image = petImages.firstWhere((img) => img.petId == pet.id);
      // Return a new PetDetail object with the image
      return pet.copyWith(images: [image]);
    });
    
    // Return the list of pets with their images
    return pets;
  }

  // Fetch pet images by pet ID
  Future<List<PetImage>> getPetImages(int petId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'pet_images',
      where: 'pet_id = ?',
      whereArgs: [petId],
      orderBy: 'position ASC',
    );
    return List.generate(maps.length, (i) => PetImage.fromMap(maps[i]));
  }

  // Fetch a pet by its ID (including its images)
  Future<PetDetail?> getPet(int petId) async {
    final db = await _dbHelper.database;

    // Fetch pet details
    final List<Map<String, dynamic>> petMaps = await db.query(
      'pet_details',
      where: 'id = ?',
      whereArgs: [petId],
    );

    if (petMaps.isEmpty) return null;

    final petDetail = PetDetail.fromMap(petMaps.first);

    // Fetch pet images
    final List<Map<String, dynamic>> imageMaps = await db.query(
      'pet_images',
      where: 'pet_id = ?',
      whereArgs: [petId],
      orderBy: 'position ASC',
    );

    final petImages = imageMaps.map((map) => PetImage.fromMap(map)).toList();

    // Return pet detail along with its images
    return petDetail.copyWith(images: petImages);
  }

  // Delete a pet by its ID (also deletes related images)
  Future<int> deletePet(int petId) async {
    final db = await _dbHelper.database;

    // Begin a transaction to delete the pet and its associated images
    return await db.transaction((txn) async {
      // Delete pet images first (to avoid foreign key constraint errors)
      await txn.delete(
        'pet_images',
        where: 'pet_id = ?',
        whereArgs: [petId],
      );

      // Delete the pet itself
      return await txn.delete(
        'pet_details',
        where: 'id = ?',
        whereArgs: [petId],
      );
    });
  }

  // Update an existing pet's details
  Future<int> updatePet(PetDetail pet) async {
    final db = await _dbHelper.database;

    // Update pet details
    int result = await db.update(
      'pet_details',
      pet.toMap(),
      where: 'id = ?',
      whereArgs: [pet.id],
    );

    // If pet update is successful, update images
    if (result > 0) {
      for (var i = 0; i < pet.images.length; i++) {
        await db.update(
          'pet_images',
          pet.images[i].toMap(),
          where: 'pet_id = ? AND position = ?',
          whereArgs: [pet.id, i + 1],
        );
      }
    }

    return result;
  }

}
