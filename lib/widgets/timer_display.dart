import 'package:flutter/material.dart';

class TimerDisplay extends StatelessWidget {
  final int secondsRemaining;

  const TimerDisplay({super.key, required this.secondsRemaining});

  @override
  Widget build(BuildContext context) {
    final minutes = secondsRemaining ~/ 60;
    final seconds = secondsRemaining % 60;
    
    return Text(
      '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
      style: TextStyle(
        fontSize: 80,
        fontWeight: FontWeight.w300,
        letterSpacing: 4,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
