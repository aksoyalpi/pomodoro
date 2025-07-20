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
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: Colors.teal[400]!,
          secondary: Colors.tealAccent,
          surface: Colors.grey[900]!,
          background: Colors.black,
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w300,
            letterSpacing: 1.2,
          ),
        ),
      ),
      home: const TimerScreen(),
    );
  }
}
