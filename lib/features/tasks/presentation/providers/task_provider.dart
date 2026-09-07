// ChangeNotifier lives here, not in material.dart, because it has
// no rendering logic - it's just the "hold listeners, notify them" tool.
import 'package:flutter/foundation.dart';
// Task comes from domain/ - two folders up from presentation/providers/.
import '../../domain/task.dart';

// Extending ChangeNotifier inherits its built-in listener-tracking
// and notifyListeners() method, so we don't write that machinery ourselves.
class TaskProvider extends ChangeNotifier {
  // The shared data. Leading underscore = private to this file, so no
  // outside code can mutate this list directly and skip notifyListeners().
  // final = this variable always points at the same List object;
  // we mutate what's inside it, we never reassign it to a new list.
  final List<Task> _tasks = [];

  // Public read-only access. List.unmodifiable wraps _tasks so outside
  // code can look but can't call .add()/.remove() on it directly -
  // every change MUST go through addTask() below.
  List<Task> get tasks => List.unmodifiable(_tasks);

  // The only way to add a Task from outside this class.
  void addTask(Task task) {
    // Mutate the real internal list.
    _tasks.add(task);
    // Broadcast to every widget currently listening: "rebuild now."
    notifyListeners();
  }
}