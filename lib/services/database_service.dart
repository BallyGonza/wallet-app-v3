import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:template_app/data/models/user/user_model.dart';

class DatabaseService {
  static Database? _database;
  static const String _databaseName = 'wallet_app.db';
  static const int _databaseVersion = 1;

  // Table names
  static const String _usersTable = 'users';

  // User table columns
  static const String _columnId = 'id';
  static const String _columnName = 'name';

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_usersTable (
        $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $_columnName TEXT NOT NULL
      )
    ''');
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < newVersion) {
      // Add migration logic here when needed
    }
  }

  // User operations
  static Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await db.insert(
      _usersTable,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<UserModel?> getUser(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _usersTable,
      where: '$_columnId = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  static Future<List<UserModel>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_usersTable);

    return List.generate(maps.length, (i) {
      return UserModel.fromMap(maps[i]);
    });
  }

  static Future<int> updateUser(UserModel user) async {
    final db = await database;
    return await db.update(
      _usersTable,
      user.toMap(),
      where: '$_columnId = ?',
      whereArgs: [user.id],
    );
  }

  static Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      _usersTable,
      where: '$_columnId = ?',
      whereArgs: [id],
    );
  }

  static Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  // Initialize the database (call this in main.dart)
  static Future<void> initialize() async {
    await database;
  }
}
