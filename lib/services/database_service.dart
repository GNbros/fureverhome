import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String path = join(documentsDir.path, 'pet_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute("PRAGMA foreign_keys = ON");
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      firebase_uid TEXT NOT NULL UNIQUE,
      name TEXT NOT NULL,
      phone TEXT NOT NULL,
      address TEXT NOT NULL,
      profile_picture BLOB
    );
    ''');

    await db.execute('''
      CREATE TABLE pet_types (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE breeds (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        FOREIGN KEY (type_id) REFERENCES pet_types(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE pet_details (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pet_name TEXT NOT NULL,
        type_id INTEGER NOT NULL,
        breed_id INTEGER NOT NULL,
        age INTEGER NOT NULL,
        gender TEXT NOT NULL,
        is_vaccinated INTEGER NOT NULL,
        is_spayed INTEGER NOT NULL,
        is_kid_friendly INTEGER NOT NULL,
        description TEXT NOT NULL,
        location TEXT NOT NULL,
        user_id INTEGER NOT NULL,
        FOREIGN KEY (type_id) REFERENCES pet_types(id),
        FOREIGN KEY (breed_id) REFERENCES breeds(id),
        FOREIGN KEY (user_id) REFERENCES users(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE pet_images (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pet_id INTEGER NOT NULL,
        image BLOB NOT NULL,
        position INTEGER,
        FOREIGN KEY (pet_id) REFERENCES pet_details(id) ON DELETE CASCADE
      );
    ''');
  }

  // Optional: method to close database
  Future close() async {
    final db = await database;
    db.close();
  }
}
