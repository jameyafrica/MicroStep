import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  void initState() {
    super.initState();
    // Tasks live in the database, not in memory, until loaded - this
    // triggers that load once when the screen first mounts.
    // addPostFrameCallback avoids calling notifyListeners() during
    // the initial build, which Flutter disallows.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    // watch() rebuilds this widget whenever TaskProvider calls
    // notifyListeners() - e.g. after loadTasks() or addTask() completes.
    final tasks = context.watch<TaskProvider>().tasks;

    return Scaffold(
      appBar: AppBar(title: const Text('My Tasks')),
      body: tasks.isEmpty
          ? const Center(child: Text('No tasks yet'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                );
              },
            ),
    );
  }
}