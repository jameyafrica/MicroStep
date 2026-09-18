import 'package:flutter/foundation.dart';
import '../../domain/task.dart';
import '../../data/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];
  List<Task> get tasks => List.unmodifiable(_tasks);

  // The one way this provider talks to the database - it never touches
  // sqflite or DatabaseService directly, only through this repository.
  final TaskRepository _repository = TaskRepository();

  // Now async - callers CAN await it (e.g. to know when it's truly
  // done), but there's nothing meaningful to hand back, hence Future<void>.
  Future<void> addTask(Task task) async {
    // Step 1: write to disk first, and actually wait for it to finish -
    // per ADR-0002, the UI must never show "saved" before it's real.
    final id = await _repository.insertTask(task);

    // Step 2: task.id was null (this Task was never saved before).
    // Task.id is final, so we can't just mutate it - we build a new
    // Task that's identical except it now carries the real id the
    // database just assigned.
    final savedTask = Task(
      id: id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
    );

    // Step 3: only now update in-memory state, with the correctly-id'd
    // object, not the original null-id one.
    _tasks.add(savedTask);

    // Step 4: only now tell listeners something changed.
    notifyListeners();
  }
}