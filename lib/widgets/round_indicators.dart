import 'package:flutter/material.dart';

class RoundIndicators extends StatelessWidget {
  final int totalRounds;
  final int completedRounds;

  const RoundIndicators({
    super.key,
    required this.totalRounds,
    required this.completedRounds,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalRounds, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index < completedRounds ? Colors.green : Colors.grey[600],
            ),
          ),
        );
      }),
    );
  }
}
