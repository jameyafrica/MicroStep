import 'package:flutter/foundation.dart';
import '../../domain/task.dart';
import '../../data/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];
  List<Task> get tasks => List.unmodifiable(_tasks);

  final TaskRepository _repository = TaskRepository();

  Future<void> addTask(Task task) async {
    final id = await _repository.insertTask(task);

    final savedTask = Task(
      id: id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
    );

    _tasks.add(savedTask);
    notifyListeners();
  }

  // Pulls every task from the database into memory. Called once when
  // the app starts (or a screen needs a full refresh) since _tasks
  // starts empty on every app launch - unlike the database, in-memory
  // state doesn't persist between runs.
  Future<void> loadTasks() async {
    final loaded = await _repository.getAllTasks();
    _tasks
      ..clear()
      ..addAll(loaded);
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    await _repository.updateTask(task);

    // Find the matching in-memory task by id and replace it, so the UI
    // reflects the change without needing a full reload from disk.
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  Future<void> removeTask(int id) async {
    await _repository.deleteTask(id);
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}