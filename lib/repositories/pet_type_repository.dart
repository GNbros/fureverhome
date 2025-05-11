import 'package:fureverhome/services/database_service.dart';
import 'package:fureverhome/models/pet_type.dart';

class PetTypeRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Fetch all pet types
  Future<List<PetType>> getPetTypes() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> typeMaps = await db.query('pet_types');
    return List.generate(typeMaps.length, (i) {
      return PetType.fromMap(typeMaps[i]);
    });
  }

  // Create a new pet type
  Future<int> insertPetType(PetType petType) async {
    final db = await _dbHelper.database;
    return await db.insert('pet_types', petType.toMap());
  }

  // Update an existing pet type
  Future<int> updatePetType(PetType petType) async {
    final db = await _dbHelper.database;
    return await db.update(
      'pet_types',
      petType.toMap(),
      where: 'id = ?',
      whereArgs: [petType.id],
    );
  }

  // Delete a pet type
  Future<int> deletePetType(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'pet_types',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Fetch a pet type by ID
  Future<PetType?> getPetTypeById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'types',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return PetType.fromMap(maps.first);
    }
    return null;
  }
}
