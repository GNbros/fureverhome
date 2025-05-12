import 'package:fureverhome/services/database_service.dart';
import 'package:fureverhome/models/breed.dart';

class PetBreedRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Fetch all breeds
  Future<List<Breed>> getAllBreeds() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> breedMaps = await db.query('breeds');
    return List.generate(breedMaps.length, (i) {
      return Breed.fromMap(breedMaps[i]);
    });
  }

  // Fetch a breed by ID
  Future<Breed?> getBreedById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'breeds',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Breed.fromMap(maps.first);
    }
    return null;
  }

  // Fetch breeds for a specific pet type
  Future<List<Breed>> getPetBreeds(int typeId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> breedMaps = await db.query(
      'breeds',
      where: 'type_id = ?',
      whereArgs: [typeId],
    );
    return List.generate(breedMaps.length, (i) {
      return Breed.fromMap(breedMaps[i]);
    });
  }

  // Create a new breed
  Future<int> insertBreed(Breed breed) async {
    final db = await _dbHelper.database;
    return await db.insert('breeds', breed.toMap());
  }

  // Update an existing breed
  Future<int> updateBreed(Breed breed) async {
    final db = await _dbHelper.database;
    return await db.update(
      'breeds',
      breed.toMap(),
      where: 'id = ?',
      whereArgs: [breed.id],
    );
  }

  // Delete a breed
  Future<int> deleteBreed(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'breeds',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}