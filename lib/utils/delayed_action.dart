import 'dart:async';
import 'dart:ui';

class DelayedAction {
  factory DelayedAction() => _instance;

  DelayedAction._internal();

  static final DelayedAction _instance = DelayedAction._internal();

  static Timer? _timer;

  static void run(
    VoidCallback action, {
    Duration duration = const Duration(microseconds: 250),
  }) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }
}
