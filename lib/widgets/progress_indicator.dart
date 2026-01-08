import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  final double progress;
  final Color color;
  final String label;

  const CustomProgressIndicator({
    super.key,
    required this.progress,
    this.color = Colors.blue,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
        const SizedBox(height: 10),
        Text('${(progress * 100).toStringAsFixed(1)}% - $label'),
      ],
    );
  }
}