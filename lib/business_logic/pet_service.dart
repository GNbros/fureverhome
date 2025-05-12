import 'dart:typed_data';

import 'package:fureverhome/models/pet_detail.dart';
import 'package:fureverhome/models/pet_image.dart';
import 'package:fureverhome/models/pet_type.dart';
import 'package:fureverhome/models/breed.dart';
import 'package:fureverhome/repositories/pet_repository.dart';
import 'package:fureverhome/repositories/pet_breed_repository.dart';
import 'package:fureverhome/repositories/pet_type_repository.dart';

class PetService {
  // Private constructor
  PetService._internal();

  // Singleton instance
  static final PetService _instance = PetService._internal();

  // Factory constructor returns the same instance
  factory PetService() => _instance;

  final PetRepository _petRepository = PetRepository();
  final PetBreedRepository _petBreedRepository = PetBreedRepository();
  final PetTypeRepository _petTypeRepository = PetTypeRepository();

  // Search for pets
  Future<List<PetDetail>> searchPets({
    String? name,
    int? typeId,
    int? breedId,
    String? gender,
    bool? isVaccinated,
    bool? isSpayed,
    bool? isKidFriendly,
    int? age,
  }) async {

    final pet = await _petRepository.searchPets(
      name: name,
      typeId: typeId,
      breedId: breedId,
      gender: gender,
      isVaccinated: isVaccinated,
      isSpayed: isSpayed,
      isKidFriendly: isKidFriendly,
      age: age,
    );
    final petBreeds = await _petBreedRepository.getAllBreeds();
    final petTypes = await _petTypeRepository.getPetTypes();

    return await _petRepository.mapTypeBreed(pet, petBreeds, petTypes);
  }

  // Pet detail
  // Fetch all pets
  Future<List<PetDetail>> getAllPets() async {
    // Any additional logic, for example, filtering or sorting
    final pet = await _petRepository.getAllPets();
    final petBreeds = await _petBreedRepository.getAllBreeds();
    final petTypes = await _petTypeRepository.getPetTypes();
    return await _petRepository.mapTypeBreed(pet, petBreeds, petTypes);
  }

  // Fetch pet images by pet ID
  Future<List<PetImage>> getPetImages(int petId) async {
    // Any additional logic, for example, filtering or sorting
    return await _petRepository.getPetImages(petId);
  }

  // Fetch a pet by its ID (including its images)
  Future<PetDetail?> getPetDetails(int petId) async {
    // Any additional logic, for example, logging, validation, etc.
    final pet = await _petRepository.getPet(petId);

    if (pet == null) {
      return null;
    }
    final petBreeds = await _petBreedRepository.getBreedById(pet.breedId);
    final petTypes = await _petTypeRepository.getPetTypeById(pet.typeId);

    if (petBreeds == null || petTypes == null) {
      return null;
    }

    return await _petRepository
        .mapTypeBreed([pet], [petBreeds], [petTypes])
        .then((mappedPets) => mappedPets.isNotEmpty ? mappedPets[0] : null);
  }

  // Add a new pet
  Future<int> addNewPet(PetDetail pet, List<Uint8List> images) async {
    // Any business logic for adding a pet, like validation
    if (pet.age < 0) {
      throw Exception('Age cannot be negative');
    }
    // Ensure images are not empty
    if (images.isEmpty) {
      throw Exception(
        'At least one image is required or the first image must be at position 1',
      );
    }

    return await _petRepository.insertPet(pet, images);
  }

  // Delete a pet
  Future<int> deletePet(int petId) async {
    // Any business logic, e.g., checking for dependencies or constraints
    return await _petRepository.deletePet(petId);
  }

  // Update pet details
  Future<int> updatePetDetails(PetDetail pet) async {
    // Business validation or processing before updating
    if (pet.age < 0) {
      throw Exception('Age cannot be negative');
    }
    // Ensure images are not empty
    if (pet.images[0].position != 1) {
      throw Exception(
        'At least one image is required or the first image must be at position 1',
      );
    }

    return await _petRepository.updatePet(pet);
  }

  // Fetch all bulk pet details based on ID
  Future<List<PetDetail>> getBulkPetDetails(List<int> petIds) async {
    // Any additional logic, for example, filtering or sorting
    return await _petRepository.getBulkPets(petIds);
  }

  // Pet type
  // Get all pet types
  Future<List<PetType>> getAllPetTypes() async {
    return await _petTypeRepository.getPetTypes();
  }

  // Get breeds based on a specific pet type
  Future<List<Breed>> getBreedsByType(int typeId) async {
    return await _petBreedRepository.getPetBreeds(typeId);
  }

  // Add a new pet type
  Future<int> addNewPetType(PetType petType) async {
    return await _petTypeRepository.insertPetType(petType);
  }

  // Update an existing pet type
  Future<int> updatePetType(PetType petType) async {
    return await _petTypeRepository.updatePetType(petType);
  }

  // Delete a pet type
  Future<int> deletePetType(int typeId) async {
    return await _petTypeRepository.deletePetType(typeId);
  }

  // Pet breed
  // Get all breeds based on a specific pet type
  Future<List<Breed>> getAllBreeds(int typeId) async {
    return await _petBreedRepository.getPetBreeds(typeId);
  }

  // Add a new breed
  Future<int> addNewBreed(Breed breed) async {
    return await _petBreedRepository.insertBreed(breed);
  }

  // Update an existing breed
  Future<int> updateBreed(Breed breed) async {
    return await _petBreedRepository.updateBreed(breed);
  }

  // Delete a breed
  Future<int> deleteBreed(int breedId) async {
    return await _petBreedRepository.deleteBreed(breedId);
  }

  Future<List<PetDetail>> getPetsCreatedByUser(int userId) async {
  return await _petRepository.getPetsByUserId(userId);
  }   
}
