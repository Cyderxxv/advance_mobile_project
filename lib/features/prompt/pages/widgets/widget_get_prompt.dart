import 'package:flutter/material.dart';

class WidgetGetPrompt extends StatefulWidget {
  final Function(String) onPromptSubmitted;

  const WidgetGetPrompt({super.key, required this.onPromptSubmitted});

  @override
  State<WidgetGetPrompt> createState() => _WidgetGetPromptState();
}

class _WidgetGetPromptState extends State<WidgetGetPrompt> {
  final TextEditingController _promptController = TextEditingController();
  bool _isComposing = false;

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  void _handlePromptSubmission() {
    final text = _promptController.text.trim();
    if (text.isNotEmpty) {
      widget.onPromptSubmitted(text);
      _promptController.clear();
      setState(() {
        _isComposing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _promptController,
              onChanged: (text) {
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              decoration: InputDecoration(
                hintText: 'Type your prompt...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            color: _isComposing ? Colors.black : Colors.grey,
            onPressed: _isComposing ? _handlePromptSubmission : null,
          ),
        ],
      ),
    );
  }
}