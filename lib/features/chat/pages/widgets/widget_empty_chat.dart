import 'package:flutter/material.dart';

class WidgetEmptyChat extends StatelessWidget {
  const WidgetEmptyChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.android,
            size: 100,
            color: Colors.black,
          ),
          const SizedBox(height: 16),
          Text(
            'What can I help you with?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}