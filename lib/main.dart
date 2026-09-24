import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/tasks/presentation/providers/task_provider.dart';
import 'features/tasks/presentation/providers/micro_step_provider.dart';
import 'features/backlog/presentation/providers/backlog_provider.dart';
import 'features/tasks/presentation/screens/task_list_screen.dart';
import 'features/backlog/presentation/screens/backlog_screen.dart';
import 'features/timer/presentation/focus_timer_screen.dart';

void main() {
  runApp(
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
      home: const HomeTabs(),
    );
  }
}

// Simple bottom-nav tabbed shell so all three screens are reachable
// without a routing package - the minimum needed to demo the full
// feature set in one app run.
class HomeTabs extends StatefulWidget {
  const HomeTabs({super.key});

  @override
  State<HomeTabs> createState() => _HomeTabsState();
}

class _HomeTabsState extends State<HomeTabs> {
  int _index = 0;

  static const _screens = [
    TaskListScreen(),
    BacklogScreen(),
    FocusTimerScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'Tasks'),
          NavigationDestination(icon: Icon(Icons.today), label: 'Backlog'),
          NavigationDestination(icon: Icon(Icons.timer), label: 'Focus'),
        ],
      ),
    );
  }
}