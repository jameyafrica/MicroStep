import 'package:flutter/foundation.dart';
import '../../../tasks/domain/task.dart';
import '../../domain/backlog_filter.dart';

// Wraps BacklogFilter with ChangeNotifier so the UI can react when the
// underlying task list changes. Takes the full task list as input
// rather than owning its own TaskRepository - it shields an existing
// list, it doesn't source its own data.
class BacklogProvider extends ChangeNotifier {
  List<Task> _immediateTasks = [];
  List<Task> get immediateTasks => List.unmodifiable(_immediateTasks);

  void updateFromTasks(List<Task> allTasks) {
    _immediateTasks = BacklogFilter.immediateTasks(allTasks);
    notifyListeners();
  }
}