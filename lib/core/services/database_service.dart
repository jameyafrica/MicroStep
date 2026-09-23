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

        // Runs a second raw SQL statement to build the microsteps table,
        // created in the same onCreate call so both tables exist together
        // from the very first app launch on a fresh install.
        // INTEGER PRIMARY KEY - matches MicroStep.id (to be added next),
        // same auto-managed uniqueness as tasks.id.
        // TEXT - matches description (Dart String).
        // taskId INTEGER - the foreign key linking a MicroStep back to
        // the Task it belongs to; matches MicroStep.taskId (Dart int).
        // No FOREIGN KEY constraint declared here - sqflite/SQLite would
        // support it, but enforcing it isn't required by the acceptance
        // criteria for Issue #9, so it's left out rather than added
        // speculatively.
        // dueDate INTEGER - same milliseconds-since-epoch pattern as
        // tasks.dueDate, for the same reason (no native DateTime type).
        // estimatedDuration INTEGER - matches MicroStep.estimatedDuration
        // (Dart int, minutes).
        // isCompleted INTEGER - SQLite has no native boolean type, so
        // this stores 0 (false) or 1 (true), matching MicroStep.isCompleted
        // (Dart bool). This mirrors the same workaround dueDate already
        // uses for DateTime.
        await db.execute('''
          CREATE TABLE microsteps(
            id INTEGER PRIMARY KEY,
            description TEXT,
            taskId INTEGER,
            dueDate INTEGER,
            estimatedDuration INTEGER,
            isCompleted INTEGER
          )
        ''');
      },
    );
    return _database!;
  }
}