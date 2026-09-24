class MicroStep {
  final int? id;
  final String description;
  final int taskId;
  DateTime dueDate;
  int estimatedDuration; // minutes
  bool isCompleted;

  MicroStep({
    this.id,
    required this.description,
    required this.taskId,
    required this.dueDate,
    required this.estimatedDuration,
    this.isCompleted = false,
  });

  // Same pattern as Task.fromMap() - reconstructs a MicroStep from a
  // database row. id is non-nullable here because a row read back from
  // SQLite always has a real assigned id.
  MicroStep.fromMap(Map<String, dynamic> map)
      : id = map['id'] as int,
        description = map['description'] as String,
        taskId = map['taskId'] as int,
        dueDate = DateTime.fromMillisecondsSinceEpoch(map['dueDate'] as int),
        estimatedDuration = map['estimatedDuration'] as int,
        // SQLite has no bool type - 1 means true, anything else false.
        isCompleted = (map['isCompleted'] as int) == 1;

  Map<String, dynamic> toMap() {
    return {
      // Omit id when null so a fresh insert lets SQLite auto-assign one.
      if (id != null) 'id': id,
      'description': description,
      'taskId': taskId,
      'dueDate': dueDate.millisecondsSinceEpoch,
      'estimatedDuration': estimatedDuration,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }
}