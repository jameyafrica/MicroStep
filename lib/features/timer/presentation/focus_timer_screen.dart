import 'package:flutter/material.dart';
import '../domain/focus_timer_controller.dart';

class FocusTimerScreen extends StatefulWidget {
  const FocusTimerScreen({super.key});

  @override
  State<FocusTimerScreen> createState() => _FocusTimerScreenState();
}

class _FocusTimerScreenState extends State<FocusTimerScreen> {
  // 25 minutes, a standard focus-session length - hardcoded for now,
  // no settings screen exists yet to make this configurable.
  late final FocusTimerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FocusTimerController(totalSeconds: 25 * 60);
  }

  @override
  void dispose() {
    // Prevents the Timer/StreamController leak mentioned in
    // FocusTimerController - always dispose what you initState.
    _controller.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Focus Timer')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // StreamBuilder rebuilds only this widget subtree each time
            // FocusTimerController pushes a new tick - not the whole screen.
            StreamBuilder<int>(
              stream: _controller.onTick,
              initialData: _controller.totalSeconds,
              builder: (context, snapshot) {
                return Text(
                  _formatTime(snapshot.data ?? 0),
                  style: Theme.of(context).textTheme.displayLarge,
                );
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _controller.start,
              child: const Text('Start Focus Session'),
            ),
          ],
        ),
      ),
    );
  }
}