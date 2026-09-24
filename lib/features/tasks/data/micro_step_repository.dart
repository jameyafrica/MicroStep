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

  Future<List<MicroStep>> getMicroStepsByTaskId(int taskId) async {
    final db = await DatabaseService.instance.database;

    final results = await db.query(
      'microsteps',
      where: 'taskId = ?',
      whereArgs: [taskId],
    );

    return results.map((map) => MicroStep.fromMap(map)).toList();
  }

  Future<void> updateMicroStep(MicroStep step) async {
    assert(step.id != null, 'updateMicroStep() requires a non-null id');

    final db = await DatabaseService.instance.database;

    await db.update(
      'microsteps',
      step.toMap(),
      where: 'id = ?',
      whereArgs: [step.id],
    );
  }

  Future<void> deleteMicroStep(int id) async {
    final db = await DatabaseService.instance.database;

    await db.delete(
      'microsteps',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}