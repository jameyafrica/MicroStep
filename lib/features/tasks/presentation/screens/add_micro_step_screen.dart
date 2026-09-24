import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/micro_step.dart';
import '../providers/micro_step_provider.dart';

class AddMicroStepScreen extends StatefulWidget {
  final int taskId;
  const AddMicroStepScreen({super.key, required this.taskId});

  @override
  State<AddMicroStepScreen> createState() => _AddMicroStepScreenState();
}

class _AddMicroStepScreenState extends State<AddMicroStepScreen> {
  final _descriptionController = TextEditingController();
  int _estimatedDuration = 10; // minutes, reasonable default

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_descriptionController.text.trim().isEmpty) return;

    final step = MicroStep(
      description: _descriptionController.text.trim(),
      taskId: widget.taskId,
      dueDate: DateTime.now(),
      estimatedDuration: _estimatedDuration,
    );

    await context.read<MicroStepProvider>().addMicroStep(step);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Micro-Step')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Estimated minutes: '),
                Expanded(
                  child: Slider(
                    value: _estimatedDuration.toDouble(),
                    min: 1,
                    max: 60,
                    divisions: 59,
                    label: '$_estimatedDuration',
                    onChanged: (value) =>
                        setState(() => _estimatedDuration = value.round()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Save Micro-Step'),
            ),
          ],
        ),
      ),
    );
  }
}