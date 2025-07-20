import 'package:flutter/material.dart';
import 'screens/timer_screen.dart';

void main() {
  runApp(const PomodoroApp());
}

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro Timer',
      theme: ThemeData(primarySwatch: Colors.red, brightness: Brightness.dark),
      home: const TimerScreen(),
    );
  }
}
