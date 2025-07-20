import 'package:flutter/material.dart';

class TimerControls extends StatelessWidget {
  final bool isRunning;
  final VoidCallback onStartStop;
  final VoidCallback onReset;

  const TimerControls({
    super.key,
    required this.isRunning,
    required this.onStartStop,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(isRunning ? Icons.pause : Icons.play_arrow),
          iconSize: 48,
          onPressed: onStartStop,
        ),
        const SizedBox(width: 20),
        IconButton(
          icon: const Icon(Icons.refresh),
          iconSize: 48,
          onPressed: onReset,
        ),
      ],
    );
  }
}
