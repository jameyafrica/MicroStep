import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/task.dart';
import '../providers/task_provider.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  // Controllers hold the live text typed into each field so we can
  // read their values on submit without rebuilding on every keystroke.
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _dueDate = DateTime.now();

  @override
  void dispose() {
    // Controllers must be disposed to free resources - same reasoning
    // as FocusTimerController.dispose().
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _submit() async {
    if (_titleController.text.trim().isEmpty) return;

    final task = Task(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      dueDate: _dueDate,
    );

    // read(), not watch() - this is a one-off action, not something
    // this widget needs to rebuild in response to.
    await context.read<TaskProvider>().addTask(task);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text('Due: ${_dueDate.toLocal().toString().split(' ')[0]}'),
                TextButton(
                  onPressed: _pickDueDate,
                  child: const Text('Change'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Save Task'),
            ),
          ],
        ),
      ),
    );
  }
}