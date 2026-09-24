import '../../../core/services/database_service.dart';
import '../domain/micro_step.dart';

class MicroStepRepository {
  Future<int> insertMicroStep(MicroStep step) async {
    final db = await DatabaseService.instance.database;
    final id = await db.insert('microsteps', step.toMap());
    return id;
  }
}