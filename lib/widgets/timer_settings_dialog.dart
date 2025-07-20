import 'package:flutter/material.dart';

class TimerSettingsDialog extends StatefulWidget {
  final int workDuration;
  final int breakDuration;
  final int totalRounds;
  final bool autoStartBreak;
  final bool autoStartRounds;
  final Function(int workMinutes, int breakMinutes, int rounds, bool autoBreak, bool autoRounds)
  onSave;

  const TimerSettingsDialog({
    super.key,
    required this.workDuration,
    required this.breakDuration,
    required this.totalRounds,
    required this.autoStartBreak,
    required this.autoStartRounds,
    required this.onSave,
  });

  @override
  State<TimerSettingsDialog> createState() => _TimerSettingsDialogState();
}

class _TimerSettingsDialogState extends State<TimerSettingsDialog> {
  late TextEditingController _workController;
  late TextEditingController _breakController;
  late TextEditingController _roundsController;
  late bool _autoStartBreak;
  late bool _autoStartRounds;

  @override
  void initState() {
    super.initState();
    _workController = TextEditingController(
      text: (widget.workDuration ~/ 60).toString(),
    );
    _breakController = TextEditingController(
      text: (widget.breakDuration ~/ 60).toString(),
    );
    _roundsController = TextEditingController(
      text: widget.totalRounds.toString(),
    );
    _autoStartBreak = widget.autoStartBreak;
    _autoStartRounds = widget.autoStartRounds;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Timer Settings'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _workController,
            decoration: const InputDecoration(
              labelText: 'Work Duration (minutes)',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _breakController,
            decoration: const InputDecoration(
              labelText: 'Break Duration (minutes)',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _roundsController,
            decoration: const InputDecoration(labelText: 'Number of Rounds'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Auto-start breaks'),
              const Spacer(),
              Switch(
                value: _autoStartBreak,
                onChanged: (value) => setState(() => _autoStartBreak = value),
              ),
            ],
          ),
          Row(
            children: [
              const Text('Auto-start next round'),
              const Spacer(),
              Switch(
                value: _autoStartRounds,
                onChanged: (value) => setState(() => _autoStartRounds = value),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final workMinutes = int.tryParse(_workController.text) ?? 25;
            final breakMinutes = int.tryParse(_breakController.text) ?? 5;
            final rounds = int.tryParse(_roundsController.text) ?? 4;
            widget.onSave(workMinutes, breakMinutes, rounds, _autoStartBreak, _autoStartRounds);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
