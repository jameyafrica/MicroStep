import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/tasks/presentation/providers/task_provider.dart';
import 'features/tasks/presentation/providers/micro_step_provider.dart';
void main() {
  runApp(
    // MultiProvider hosts multiple ChangeNotifiers at once - needed now
    // that MicroStepProvider joins TaskProvider as shared app state.
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TaskProvider()),
        ChangeNotifierProvider(create: (context) => MicroStepProvider()),
        ChangeNotifierProvider(create: (context) => BacklogProvider()),
      ],
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