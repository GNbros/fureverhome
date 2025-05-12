import 'package:fureverhome/services/database_service.dart';
import 'package:fureverhome/models/user_detail.dart';

class UserRepository {
    final DatabaseHelper _dbHelper = DatabaseHelper();


    Future<UserDetail?> getUserByFirebaseUid(String firebaseUid) async {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'firebase_uid = ?',
        whereArgs: [firebaseUid],
      );
      if (maps.isNotEmpty) {
        return UserDetail.fromMap(maps.first);
      }
      return null;
    }

    // Fetch user details
    Future<UserDetail?> getUserDetails(int userId) async {
        final db = await _dbHelper.database;
        final List<Map<String, dynamic>> maps = await db.query(
            'users',
            where: 'id = ?',
            whereArgs: [userId],
        );
        if (maps.isNotEmpty) {
            return UserDetail.fromMap(maps.first);
        }
        return null;
    }

    // Create a new user
    Future<int> insertUser(UserDetail user) async {
        final db = await _dbHelper.database;
        return await db.insert('users', user.toMap());
    }

    // Update an existing user
    Future<int> updateUser(UserDetail user) async {
        final db = await _dbHelper.database;
        return await db.update(
            'users',
            user.toMap(),
            where: 'id = ?',
            whereArgs: [user.id],
        );
    }

    // Delete a user
    Future<int> deleteUser(int id) async {
        final db = await _dbHelper.database;
        return await db.delete(
            'users',
            where: 'id = ?',
            whereArgs: [id],
        );
    }

}