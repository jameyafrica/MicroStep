import 'dart:async';

// Self-contained, no Provider (per ADR-0001: timer is explicitly
// excluded from shared state - it's local to whichever screen uses it).
//
// StreamController<int> broadcasts the remaining seconds on every tick.
// The UI listens via StreamBuilder and rebuilds only the timer display,
// not the whole screen, each time a new value is added to the stream.
class FocusTimerController {
  final int totalSeconds;
  late int _remainingSeconds;
  Timer? _timer;

  // StreamController.broadcast() allows multiple listeners (e.g. if
  // more than one widget wants timer updates); a plain StreamController
  // only allows exactly one listener, which is riskier if the UI
  // structure changes later.
  final _controller = StreamController<int>.broadcast();
  Stream<int> get onTick => _controller.stream;

  FocusTimerController({required this.totalSeconds}) {
    _remainingSeconds = totalSeconds;
  }

  // Single-tap start: begins a periodic Timer that fires once per
  // second, decrements the count, and pushes the new value into the
  // stream so any listening widget updates automatically.
  void start() {
    _timer?.cancel(); // guard against double-start creating two timers
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        _controller.close();
        return;
      }
      _remainingSeconds--;
      _controller.add(_remainingSeconds);
    });
  }

  // Must be called when the owning widget is disposed, or the Timer
  // and StreamController leak and keep running in the background.
  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}