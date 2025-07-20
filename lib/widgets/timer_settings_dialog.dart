import 'package:flutter/material.dart';

class TimerSettingsDialog extends StatefulWidget {
  final int workDuration;
  final int breakDuration;
  final int totalRounds;
  final bool autoStartBreak;
  final bool autoStartRounds;
  final Function(
    int workMinutes,
    int breakMinutes,
    int rounds,
    bool autoBreak,
    bool autoRounds,
  )
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
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Timer Settings',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField(
              context,
              controller: _workController,
              label: 'Work Duration',
              suffix: 'min',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              context,
              controller: _breakController,
              label: 'Break Duration',
              suffix: 'min',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              context,
              controller: _roundsController,
              label: 'Number of Rounds',
              suffix: 'rounds',
            ),
            const SizedBox(height: 24),
            _buildSwitch(
              context,
              'Auto-start breaks',
              _autoStartBreak,
              (value) => setState(() => _autoStartBreak = value),
            ),
            const SizedBox(height: 16),
            _buildSwitch(
              context,
              'Auto-start rounds',
              _autoStartRounds,
              (value) => setState(() => _autoStartRounds = value),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    final workMinutes =
                        int.tryParse(_workController.text) ?? 25;
                    final breakMinutes =
                        int.tryParse(_breakController.text) ?? 5;
                    final rounds = int.tryParse(_roundsController.text) ?? 4;
                    widget.onSave(
                      workMinutes,
                      breakMinutes,
                      rounds,
                      _autoStartBreak,
                      _autoStartRounds,
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String suffix,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(color: Theme.of(context).colorScheme.primary),
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
        ),
        suffixStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
        ),
      ),
    );
  }

  Widget _buildSwitch(
    BuildContext context,
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }
}
