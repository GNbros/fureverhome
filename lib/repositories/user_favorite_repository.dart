import 'package:fureverhome/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class FavoritesRepository {
    final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> addFavorite(int userId, int petId) async {
    final db = await _dbHelper.database;
    await db.insert('user_favorites', {
      'user_id': userId,
      'pet_id': petId,
    }, conflictAlgorithm: ConflictAlgorithm.ignore); // Avoid duplicates
  }

  Future<void> removeFavorite(int userId, int petId) async {
    final db = await _dbHelper.database;
    await db.delete('user_favorites',
        where: 'user_id = ? AND pet_id = ?', whereArgs: [userId, petId]);
  }

  Future<List<int>> getFavoritePetIds(int userId) async {
    final db = await _dbHelper.database;
    final result = await db.query('user_favorites',
        columns: ['pet_id'], where: 'user_id = ?', whereArgs: [userId]);

    return result.map((row) => row['pet_id'] as int).toList();
  }

  // Future<bool> isFavorite(int userId, int petId) async {
  //   final db = await _dbHelper.database;
  //   final result = await db.query('user_favorites',
  //       where: 'user_id = ? AND pet_id = ?', whereArgs: [userId, petId]);
  //   return result.isNotEmpty;
  // }
}
