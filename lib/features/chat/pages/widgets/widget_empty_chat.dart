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
            size: 50,
            color: Colors.black,
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Hello! How can I assist you today?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}