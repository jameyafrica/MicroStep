// lib/features/tasks/domain/task.dart

// Pure Dart only — no Flutter imports here, same rule as MicroStep.
// Task deliberately does NOT hold a List<MicroStep>. MicroSteps reference
// their Task via 'taskId' instead — a single source of truth for that
// relationship, avoiding duplicate/conflicting data (see MicroStep).

class Task {
  // 'final': set once, at creation, never reassigned — this is the
  // permanent identity of the Task, the same role taskId plays on MicroStep.
  final int id;

  // mutable fields: a user can reasonably edit these after creating a Task.
  String title;         // short, scannable label, e.g. "Clean kitchen"
  String description;   // longer explanation of what the task involves
  DateTime dueDate;      // when the task should be done by

  // Constructor: every field is required — no sensible default exists
  // for any of these (unlike MicroStep's isCompleted, which had a
  // meaningful default of 'false').
  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
  });
}