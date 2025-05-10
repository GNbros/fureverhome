import 'package:fureverhome/models/pet_detail.dart';
import 'package:fureverhome/models/pet_image.dart';
import 'package:fureverhome/models/pet_type.dart';
import 'package:fureverhome/models/breed.dart';
import 'package:fureverhome/repositories/pet_repository.dart';

class PetService {
  final PetRepository _petRepository = PetRepository();

  // Fetch all pets
  Future<List<PetDetail>> getAllPets() async {
    // Any additional logic, for example, filtering or sorting
    return await _petRepository.getAllPets();
  }

  // Fetch pet images by pet ID
  Future<List<PetImage>> getPetImages(int petId) async {
    // Any additional logic, for example, filtering or sorting
    return await _petRepository.getPetImages(petId);
  }

  // Fetch a pet by its ID (including its images)
  Future<PetDetail?> getPetDetails(int petId) async {
    // Any additional logic, for example, logging, validation, etc.
    return await _petRepository.getPet(petId);
  }

  // Add a new pet
  Future<int> addNewPet(PetDetail pet, List<PetImage> images) async {
    // Any business logic for adding a pet, like validation
    if (pet.age < 0) {
      throw Exception('Age cannot be negative');
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
    return await _petRepository.updatePet(pet);
  }

  // Get all pet types
  Future<List<PetType>> getAllPetTypes() async {
    return await _petRepository.getPetTypes();
  }

  // Get breeds based on a specific pet type
  Future<List<Breed>> getBreedsByType(int typeId) async {
    return await _petRepository.getPetBreeds(typeId);
  }
}
