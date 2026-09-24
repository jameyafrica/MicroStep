import 'package:flutter/foundation.dart';
import '../../domain/micro_step.dart';
import '../../data/micro_step_repository.dart';

class MicroStepProvider extends ChangeNotifier {
  final List<MicroStep> _microSteps = [];
  List<MicroStep> get microSteps => List.unmodifiable(_microSteps);

  final MicroStepRepository _repository = MicroStepRepository();

  Future<void> addMicroStep(MicroStep step) async {
    final id = await _repository.insertMicroStep(step);

    final saved = MicroStep(
      id: id,
      description: step.description,
      taskId: step.taskId,
      dueDate: step.dueDate,
      estimatedDuration: step.estimatedDuration,
      isCompleted: step.isCompleted,
    );

    _microSteps.add(saved);
    notifyListeners();
  }

  // Loads only the micro-steps belonging to one task, since the UI
  // shows micro-steps in the context of a specific Task's detail
  // screen, not as one global list.
  Future<void> loadMicroStepsForTask(int taskId) async {
    final loaded = await _repository.getMicroStepsByTaskId(taskId);
    _microSteps
      ..removeWhere((s) => s.taskId == taskId)
      ..addAll(loaded);
    notifyListeners();
  }

  Future<void> updateMicroStep(MicroStep step) async {
    await _repository.updateMicroStep(step);
    final index = _microSteps.indexWhere((s) => s.id == step.id);
    if (index != -1) {
      _microSteps[index] = step;
      notifyListeners();
    }
  }

  Future<void> removeMicroStep(int id) async {
    await _repository.deleteMicroStep(id);
    _microSteps.removeWhere((s) => s.id == id);
    notifyListeners();
  }
}