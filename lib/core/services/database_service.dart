import 'package:sqflite/sqflite.dart';

class DatabaseService {
  // A static variable belongs to the class itself, not to any one object.
  // This is where we'll store "the one true instance" once it's created.
  // It starts as null - meaning "not created yet".
  static DatabaseService? _instance;

  // A named constructor starting with an underscore is private to this file.
  // This means outside code CANNOT call `DatabaseService._internal()` -
  // in fact, outside code can't call ANY constructor on this class anymore,
  // because this is now the ONLY constructor it has, and it's private.
  // The empty body {} means it doesn't do anything yet - just exists.
  DatabaseService._internal();

  // A static getter - accessed like a property (DatabaseService.instance),
  // not called like a method. This is the ONLY way outside code can get
  // a DatabaseService now, since the constructor is private.
  static DatabaseService get instance {
    // "??=" means: if _instance is currently null, assign the right-hand
    // side to it. If it's already NOT null, do nothing and leave it as is.
    _instance ??= DatabaseService._internal();
    // Now that we've guaranteed it's been created, hand it back.
    return _instance!;
  }

  // Holds the actual open SQLite connection, once we have one.
  // Nullable, same reasoning as _instance: nothing to put here yet
  // until we actually open the file for the first time.
  Database? _database;

  // Returns a Future<Database> - "eventually gives you a Database",
  // not a Database right away, because opening a file takes real time.
  // async is valid on a getter as long as the return type is a Future.
  Future<Database> get database async {
    // If we've already opened it before, don't reopen the file -
    // just hand back the existing connection.
    if (_database != null) {
      return _database!;
    }
    // First time ever called: actually open the file. "await" pauses
    // this getter right here until sqflite finishes opening it, then
    // continues with the real Database object in hand.
    _database = await openDatabase('microstep.db');
    return _database!;
  }
}