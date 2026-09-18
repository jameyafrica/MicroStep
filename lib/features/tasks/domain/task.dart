// lib/features/tasks/domain/task.dart

// Pure Dart only — no Flutter imports here, same rule as MicroStep.
// Task deliberately does NOT hold a List<MicroStep>. MicroSteps reference
// their Task via 'taskId' instead — a single source of truth for that
// relationship, avoiding duplicate/conflicting data (see MicroStep).

class Task {
  // 'final': set once, at creation, never reassigned — this is the
  // permanent identity of the Task, the same role taskId plays on MicroStep.
  final int? id;

  // mutable fields: a user can reasonably edit these after creating a Task.
  String title;         // short, scannable label, e.g. "Clean kitchen"
  String description;   // longer explanation of what the task involves
  DateTime dueDate;      // when the task should be done by

  // Constructor: every field is required  no sensible default exists
  // for any of these (unlike MicroStep's isCompleted, which had a
  // meaningful default of 'false').
  Task({
     this.id,
    required this.title,
    required this.description,
    required this.dueDate,
  });

  // Converts this Task into the Map<String, dynamic> shape sqflite's
// insert() and update() methods expect - basically, "this object as
// a database row."
Map<String, dynamic> toMap() {
  return {
    // Only include 'id' in the map if we actually have one. If id is
    // null (a brand-new, unsaved Task), we leave the key out entirely -
    // that tells SQLite "you decide the id," which is what makes
    // INTEGER PRIMARY KEY auto-increment actually kick in. Including
    // 'id': null explicitly would try to insert a literal NULL into
    // a primary key column instead, which is not the same thing.
    if (id != null) 'id': id,
    'title': title,
    'description': description,
    // SQLite has no DateTime type, so we store it as milliseconds
    // since epoch - a plain int - same fix we used for the schema
    // itself in DatabaseService.
    'dueDate': dueDate.millisecondsSinceEpoch,
  };
}
}                 