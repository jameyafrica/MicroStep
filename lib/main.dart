import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/tasks/presentation/providers/task_provider.dart';

void main() {
  runApp(
    // ChangeNotifierProvider makes one TaskProvider instance available
    // to every widget below it in the tree, via context.read<TaskProvider>()
    // or context.watch<TaskProvider>(). "create:" runs once, the first
    // time it's needed, and builds that single shared instance.
    ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: const MicroStepApp(),
    ),
  );
}

class MicroStepApp extends StatelessWidget {
  const MicroStepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MicroStep',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('MicroStep — Foundation Ready'),
        ),
      ),
    );
  }
}