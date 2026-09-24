import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/task.dart';
import '../providers/micro_step_provider.dart';
import 'add_micro_step_screen.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;
  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Loads only this task's micro-steps, per
    // MicroStepProvider.loadMicroStepsForTask's design.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MicroStepProvider>().loadMicroStepsForTask(widget.task.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filters the shared micro-step list down to this task's own steps -
    // MicroStepProvider holds micro-steps for whichever task(s) have
    // been loaded, not just this one.
    final steps = context
        .watch<MicroStepProvider>()
        .microSteps
        .where((step) => step.taskId == widget.task.id)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(widget.task.title)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(widget.task.description),
          ),
          Expanded(
            child: steps.isEmpty
                ? const Center(child: Text('No micro-steps yet'))
                : ListView.builder(
                    itemCount: steps.length,
                    itemBuilder: (context, index) {
                      final step = steps[index];
                      return CheckboxListTile(
                        title: Text(step.description),
                        value: step.isCompleted,
                        onChanged: (_) {}, // wired properly in a later pass
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddMicroStepScreen(taskId: widget.task.id!),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}