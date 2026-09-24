import '../../tasks/domain/task.dart';

// Pure Dart, no Flutter imports - belongs in domain/ per the project's
// own architecture rationale (fast, isolated unit testing).
//
// "Backlog shielding" = separating tasks due today (or overdue) from
// the full task queue, so the UI can show a focused, immediate view
// instead of overwhelming the user with everything at once.
class BacklogFilter {
  static List<Task> immediateTasks(List<Task> allTasks) {
    final now = DateTime.now();
    final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return allTasks
        .where((task) => task.dueDate.isBefore(endOfToday) ||
            _isSameDay(task.dueDate, now))
        .toList();
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}