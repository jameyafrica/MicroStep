// lib/features/tasks/domain/micro_step.dart

// Pure Dart only — no Flutter imports here. This class must be usable and
// testable without ever touching the UI framework.

class MicroStep {
  
  final String description;   // what the step actually is, e.g. "put dishes in sink"
  final int taskId;           // the Task this MicroStep belongs to (a reference, not a copy)

  
  DateTime dueDate;           // when this step should be done by
  int estimatedDuration;      // how long the step is expected to take, in minutes
  bool isCompleted;           // whether the user has finished this step

  // Constructor: this is how a MicroStep object gets created.
  // 'required' means the caller MUST supply a value for that field 
  // Dart won't let you forget one and accidentally create a broken object.
  MicroStep({
    required this.description,
    required this.taskId,
    required this.dueDate,
    required this.estimatedDuration,
    this.isCompleted = false, // default value: a new step starts NOT completed
  });
}