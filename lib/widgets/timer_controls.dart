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
        _buildControlButton(
          context,
          icon: isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
          onPressed: onStartStop,
        ),
        const SizedBox(width: 32),
        _buildControlButton(
          context,
          icon: Icons.refresh_rounded,
          onPressed: onReset,
          isSecondary: true,
        ),
      ],
    );
  }

  Widget _buildControlButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
    bool isSecondary = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isSecondary
            ? Theme.of(context).colorScheme.surface
            : Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Icon(
              icon,
              size: 32,
              color: isSecondary
                  ? Theme.of(context).colorScheme.primary
                  : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
