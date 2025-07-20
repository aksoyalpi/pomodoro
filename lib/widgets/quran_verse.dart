import 'package:flutter/material.dart';

class QuranVerse extends StatelessWidget {
  const QuranVerse({super.key});

  String _getRandomVerse() {
    // Add more verses as needed
    const verses = [
      '"Indeed, with hardship comes ease." (94:5)',
      '"And seek help through patience and prayer." (2:153)',
      '"Allah does not burden a soul beyond that it can bear." (2:286)',
      '"So remember Me; I will remember you." (2:152)',
    ];
    return verses[DateTime.now().millisecond % verses.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Text(
        _getRandomVerse(),
        style: const TextStyle(
          fontSize: 24,
          fontStyle: FontStyle.italic,
          color: Colors.white70,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
