import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static DatabaseService? _instance;

  DatabaseService._internal();

  static DatabaseService get instance {
    _instance ??= DatabaseService._internal();
    return _instance!;
  }

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await openDatabase(
      'microstep.db',
      // version 1 - SQLite tracks a schema version number; needed
      // any time we define onCreate, so future changes can be migrated.
      version: 1,
      // onCreate only runs the very first time the database file
      // is created - not on every app launch, only once ever.
      onCreate: (db, version) async {
        // Runs a single raw SQL statement to build the tasks table.
        // INTEGER PRIMARY KEY - matches Task.id, auto-manages uniqueness.
        // TEXT - matches title/description (Dart String).
        // INTEGER - stores dueDate as milliseconds since epoch,
        // since SQLite has no native DateTime type.
        await db.execute('''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY,
            title TEXT,
            description TEXT,
            dueDate INTEGER
          )
        ''');
      },
    );
    return _database!;
  }
}