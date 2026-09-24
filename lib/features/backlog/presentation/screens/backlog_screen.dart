import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../tasks/presentation/providers/task_provider.dart';
import '../providers/backlog_provider.dart';

class BacklogScreen extends StatefulWidget {
  const BacklogScreen({super.key});

  @override
  State<BacklogScreen> createState() => _BacklogScreenState();
}

class _BacklogScreenState extends State<BacklogScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final taskProvider = context.read<TaskProvider>();
      await taskProvider.loadTasks();
      if (mounted) {
        // BacklogProvider shields the full list down to immediate
        // tasks only - fed from TaskProvider's already-loaded list,
        // per BacklogProvider's own design (it doesn't source its own data).
        context.read<BacklogProvider>().updateFromTasks(taskProvider.tasks);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final immediateTasks = context.watch<BacklogProvider>().immediateTasks;

    return Scaffold(
      appBar: AppBar(title: const Text('Today')),
      body: immediateTasks.isEmpty
          ? const Center(child: Text('Nothing due today'))
          : ListView.builder(
              itemCount: immediateTasks.length,
              itemBuilder: (context, index) {
                final task = immediateTasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                );
              },
            ),
    );
  }
}