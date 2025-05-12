import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:fureverhome/services/database_service.dart';
import 'package:fureverhome/models/pet_detail.dart';
import 'package:fureverhome/models/pet_image.dart';
import 'package:fureverhome/models/pet_type.dart';
import 'package:fureverhome/models/breed.dart';

class PetRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Insert a new pet along with its images
  Future<int> insertPet(PetDetail pet, List<Uint8List> imageBlobs) async {
  final db = await _dbHelper.database;

  return await db.transaction((txn) async {
    final petId = await txn.insert('pet_details', pet.toMap());

    for (var i = 0; i < imageBlobs.length; i++) {
      await txn.insert('pet_images', {
        'pet_id': petId,
        'image': imageBlobs[i],
        'position': i + 1,
      });
    }
    return petId;
    });
  }
  
  // Fetch all pets
  Future<List<PetDetail>> getAllPets() async {
    final db = await _dbHelper.database;

    // Fetch part
    final List<Map<String, dynamic>> maps = await db.query(
      'pet_details',
      orderBy: 'id DESC',
      );
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

  // Fetch bulk pet details by IDs
  Future<List<PetDetail>> getBulkPets(List<int> petIds) async {
    final db = await _dbHelper.database;

    // Fetch pet details
    final List<Map<String, dynamic>> petMaps = await db.query(
      'pet_details',
      where: 'id IN (${petIds.join(',')})',
    );

    // Fetch pet images only position 1
    final List<Map<String, dynamic>> imageMaps = await db.query(
      'pet_images',
      where: 'pet_id IN (${petIds.join(',')}) AND position = ?',
      whereArgs: [1],
      orderBy: 'pet_id ASC',
    );
    
    // Create a map of pet images for quick lookup
    final Map<int, List<PetImage>> petImagesMap = {};
    for (var map in imageMaps) {
      final image = PetImage.fromMap(map);
      if (!petImagesMap.containsKey(image.petId)) {
        petImagesMap[image.petId] = [];
      }
      petImagesMap[image.petId]!.add(image);
    }

    // Create a list of PetDetail objects with their images
    return List.generate(petMaps.length, (i) {
      final pet = PetDetail.fromMap(petMaps[i]);
      return pet.copyWith(images: petImagesMap[pet.id] ?? []);
    });
  }

  // Search
  Future<List<PetDetail>> searchPets({
    String? name,
    int? typeId,
    int? breedId,
    String? gender,
    bool? isVaccinated,
    bool? isSpayed,
    bool? isKidFriendly,
    int? age,
    String order = 'DESC',
  }) async {
  final db = await _dbHelper.database;

  final whereClauses = <String>[];
  final whereArgs = <dynamic>[];

  if (name != null && name.isNotEmpty) {
    whereClauses.add("pet_name LIKE ?");
    whereArgs.add('%$name%');
  }
  if (typeId != null) {
    whereClauses.add("type_id = ?");
    whereArgs.add(typeId);
  }
  if (breedId != null) {
    whereClauses.add("breed_id = ?");
    whereArgs.add(breedId);
  }
  if (gender != null && gender.isNotEmpty) {
    whereClauses.add("gender = ?");
    whereArgs.add(gender);
  }
  if (isVaccinated != null) {
    whereClauses.add("is_vaccinated = ?");
    whereArgs.add(isVaccinated ? 1 : 0);
  }
  if (isSpayed != null) {
    whereClauses.add("is_spayed = ?");
    whereArgs.add(isSpayed ? 1 : 0);
  }
  if (isKidFriendly != null) {
    whereClauses.add("is_kid_friendly = ?");
    whereArgs.add(isKidFriendly ? 1 : 0);
  }
  if (age != null) {
    whereClauses.add("age = ?");
    whereArgs.add(age);
  }

  final whereString = whereClauses.isNotEmpty ? 'WHERE ${whereClauses.join(' AND ')}' : '';

  final result = await db.rawQuery('''
    SELECT * FROM pet_details
    $whereString
    ORDER BY datetime(created_at) $order
  ''', whereArgs);

      final List<Map<String, dynamic>> imageMaps = await db.query(
      'pet_images',
      where: 'position = ?',
      whereArgs: [1],
      orderBy: 'pet_id ASC',
    );

    // Create a list of PetImage objects from the imageMaps
    final List<PetImage> petImages = imageMaps.map((map) => PetImage.fromMap(map)).toList();
    final List<PetDetail> pets = List.generate(result.length, (i) {
      final pet = PetDetail.fromMap(result[i]);
      // Find the corresponding image for the pet
      final image = petImages.firstWhere((img) => img.petId == pet.id);
      // Return a new PetDetail object with the image
      return pet.copyWith(images: [image]);
    });
  
  return pets;
}

  // helper function to get pet types and breeds
  Future<List<PetDetail>> mapTypeBreed(List<PetDetail> pet, List<Breed> petBreeds, List<PetType> petTypes) async {
    
    for (var i = 0; i < pet.length; i++) {
      final type = petTypes.firstWhere((type) => type.id == pet[i].typeId);
      final breed = petBreeds.firstWhere((breed) => breed.id == pet[i].breedId);
      
      pet[i] = pet[i].copyWith(petType: type.name, petBreed: breed.name);
    }
    return pet;
  }

  // Fetch all pets created by a specific user
Future<List<PetDetail>> getPetsByUserId(int userId) async {
  final db = await _dbHelper.database;


  Future<List<PetType>> getAllTypes() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('pet_types');
    return maps.map((map) => PetType.fromMap(map)).toList();
  }

  Future<List<Breed>> getAllBreeds() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('breeds');
    return maps.map((map) => Breed.fromMap(map)).toList();
  }

  // Fetch all pets created by the user
  final List<Map<String, dynamic>> maps = await db.query(
    'pet_details',
    where: 'user_id = ?', // Assuming 'user_id' is the column storing the creator's ID
    whereArgs: [userId],
    orderBy: 'id DESC', // Order by pet ID (descending)
  );

  final List<Map<String, dynamic>> imageMaps = await db.query(
    'pet_images',
    where: 'position = ?',
    whereArgs: [1],
    orderBy: 'pet_id ASC',
  );

  // Create a list of PetImage objects from the imageMaps
  final List<PetImage> petImages = imageMaps.map((map) => PetImage.fromMap(map)).toList();

  // Create a list of PetDetail objects with the corresponding images
  final List<PetDetail> pets = List.generate(maps.length, (i) {
    final pet = PetDetail.fromMap(maps[i]);
    final image = petImages.firstWhere((img) => img.petId == pet.id);
    return pet.copyWith(images: [image]);
  });

  final breeds = await getAllBreeds();
  final types = await getAllTypes();
  return await mapTypeBreed(pets, breeds, types);
}

}
