import '../../../core/services/database_service.dart';
import '../domain/micro_step.dart';

class MicroStepRepository {
  Future<int> insertMicroStep(MicroStep step) async {
    final db = await DatabaseService.instance.database;
    final id = await db.insert('microsteps', step.toMap());
    return id;
  }

  Future<MicroStep?> getMicroStepById(int id) async {
    final db = await DatabaseService.instance.database;

    final results = await db.query(
      'microsteps',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isEmpty) {
      return null;
    }

    return MicroStep.fromMap(results.first);
  }

  // The acceptance-criteria-mandated lookup: every MicroStep belonging
  // to one Task. Filters on the taskId foreign key column rather than
  // the primary key, so it can return zero, one, or many rows.
  Future<List<MicroStep>> getMicroStepsByTaskId(int taskId) async {
    final db = await DatabaseService.instance.database;

    final results = await db.query(
      'microsteps',
      where: 'taskId = ?',
      whereArgs: [taskId],
    );

    return results.map((map) => MicroStep.fromMap(map)).toList();
  }
}