import 'package:flutter/material.dart';

class WidgetEmptyChat extends StatelessWidget {
  const WidgetEmptyChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            'https://i.etsystatic.com/39426535/r/il/2cafee/5616301375/il_1080xN.5616301375_9x8r.jpg',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
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