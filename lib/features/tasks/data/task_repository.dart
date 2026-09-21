
import '../../../core/services/database_service.dart';
import '../domain/task.dart';

// Sits between TaskProvider (presentation-adjacent) and DatabaseService
// (core infrastructure). Its job: translate Task objects into database
// rows and back, and run the actual CRUD operations. Nothing else in
// the app should know or care what a SQL statement looks like -
// that knowledge lives only here.
class TaskRepository {
  // Ordinary constructor - no Singleton needed. TaskRepository holds no
  // state of its own; it just borrows DatabaseService's one shared
  // connection every time it needs it. Multiple instances would all
  // talk to the same underlying database, so there's nothing to protect.

  // Inserts a new Task into the "tasks" table and returns the id
  // SQLite auto-generated for it. Future<int> because both talking to
  // the database AND getting the new id back take real time.
  Future<int> insertTask(Task task) async {
    // Ask DatabaseService for the one shared connection. This "await"
    // pauses here until we actually have a real, open Database object -
    // same connection every time, since DatabaseService guarantees
    // there's only ever one.
    final db = await DatabaseService.instance.database;

    // sqflite's insert() takes the table name and a Map<String, dynamic>
    // row - exactly what Task.toMap() produces. It runs the SQL INSERT
    // itself and returns the new row's id as an int, which is why this
    // whole method is typed to return that id back up to whoever called
    // insertTask (eventually TaskProvider).
    final id = await db.insert('tasks', task.toMap());

    return id;
  }

  // Looks up a single Task by its database id. Returns null if no row
// with that id exists - e.g. it was deleted, or the id was never real.
Future<Task?> getTaskById(int id) async {
  final db = await DatabaseService.instance.database;

  // query() returns a List<Map<String, dynamic>> - one Map per matching
  // row - even though we expect at most one row back here, since id is
  // the primary key and therefore guaranteed unique.
  final results = await db.query(
    'tasks',
    // '?' is a placeholder, not the literal value - sqflite fills it in
    // safely from whereArgs below. Never interpolate raw values directly
    // into the where string; that's how SQL injection happens.
    where: 'id = ?',
    whereArgs: [id],
  );

  // Empty list means no row matched this id at all.
  if (results.isEmpty) {
    return null;
  }

  // Exactly one match (id is the primary key, so it can't be more than
  // one) - convert that single row back into a real Task object.
  return Task.fromMap(results.first);
}
}