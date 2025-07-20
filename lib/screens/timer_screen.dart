import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import '../widgets/timer_display.dart';
import '../widgets/timer_controls.dart';
import '../widgets/quran_verse.dart';
import '../widgets/timer_settings_dialog.dart';
import '../widgets/round_indicators.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  TimerScreenState createState() => TimerScreenState();
}

class TimerScreenState extends State<TimerScreen>
    with SingleTickerProviderStateMixin {
  static int workDuration = 25 * 60; // 25 minutes
  static int breakDuration = 5 * 60; // 5 minutes

  late Timer _timer;
  int _secondsRemaining = workDuration;
  bool _isRunning = false;
  bool _isWorkTime = true;

  late AnimationController _animationController;
  late Animation<double> _timerPositionAnimation;
  late Animation<double> _controlsPositionAnimation;
  late Animation<double> _timerOpacityAnimation;
  late Animation<double> _verseOpacityAnimation;

  static int totalRounds = 4;
  int _completedRounds = 0;
  bool _autoStartBreak = true;
  bool _autoStartRounds = false;

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _timerPositionAnimation =
        Tween<double>(
          begin: 0.4, // Center position
          end: 0.15, // Top position
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    _controlsPositionAnimation =
        Tween<double>(
          begin: 0.6, // Initial position (60% from top)
          end: 0.85, // Bottom position (85% from top)
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    _verseOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _timerOpacityAnimation = Tween<double>(begin: 1.0, end: 0.6).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _toggleTimer() {
    setState(() {
      if (_isRunning) {
        _timer.cancel();
        _animationController.reverse();
      } else {
        _timer = Timer.periodic(const Duration(seconds: 1), _timerCallback);
        _animationController.forward();
      }
      _isRunning = !_isRunning;
    });
  }

  void _playSound(bool isWorkEnd) async {
    await _audioPlayer.play(
      AssetSource(isWorkEnd ? 'sounds/work_end.mp3' : 'sounds/break_end.mp3'),
    );
  }

  void _timerCallback(Timer timer) {
    setState(() {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
      } else {
        _timer.cancel();
        if (_isWorkTime) {
          _playSound(true);
          _completedRounds++;
          if (_autoStartBreak) {
            _isWorkTime = false;
            _secondsRemaining = breakDuration;
            _timer = Timer.periodic(const Duration(seconds: 1), _timerCallback);
          } else {
            _isRunning = false;
            _isWorkTime = false;
            _secondsRemaining = breakDuration;
            _animationController.reverse();
          }
        } else {
          _playSound(false);
          if (_autoStartRounds && _completedRounds < totalRounds) {
            _isWorkTime = true;
            _secondsRemaining = workDuration;
            _timer = Timer.periodic(const Duration(seconds: 1), _timerCallback);
          } else {
            _isRunning = false;
            _isWorkTime = true;
            _secondsRemaining = workDuration;
            _animationController.reverse();
          }
        }
      }
    });
  }

  void _resetTimer() {
    setState(() {
      _timer.cancel();
      _isRunning = false;
      _completedRounds = 0;
      _secondsRemaining = _isWorkTime ? workDuration : breakDuration;
      _animationController.reverse();
    });
  }

  void _showSettings() {
    if (_isRunning) return;

    showDialog(
      context: context,
      builder: (context) => TimerSettingsDialog(
        workDuration: workDuration,
        breakDuration: breakDuration,
        totalRounds: totalRounds,
        autoStartBreak: _autoStartBreak,
        autoStartRounds: _autoStartRounds,
        onSave: (workMinutes, breakMinutes, rounds, autoBreak, autoRounds) {
          setState(() {
            workDuration = workMinutes * 60;
            breakDuration = breakMinutes * 60;
            totalRounds = rounds;
            _autoStartBreak = autoBreak;
            _autoStartRounds = autoRounds;
            _secondsRemaining = _isWorkTime ? workDuration : breakDuration;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Stack(
            children: [
              // Timer Section
              Positioned(
                top:
                    MediaQuery.of(context).size.height *
                    _timerPositionAnimation.value,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: _timerOpacityAnimation.value,
                  child: Column(
                    children: [
                      RoundIndicators(
                        totalRounds: totalRounds,
                        completedRounds: _completedRounds,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _isWorkTime ? 'Work Time' : 'Break Time',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: _showSettings,
                        child: TimerDisplay(
                          secondsRemaining: _secondsRemaining,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Verse Section (Always centered)
              Positioned(
                top: MediaQuery.of(context).size.height * 0.4,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: _verseOpacityAnimation.value,
                  child: const Center(child: QuranVerse()),
                ),
              ),

              // Controls Section
              Positioned(
                top:
                    MediaQuery.of(context).size.height *
                    _controlsPositionAnimation.value,
                left: 0,
                right: 0,
                child: TimerControls(
                  isRunning: _isRunning,
                  onStartStop: _toggleTimer,
                  onReset: _resetTimer,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
