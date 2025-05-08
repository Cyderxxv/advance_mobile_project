import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {
  final Function(String) onSubmitted;

  const ChatInput({
    super.key,
    required this.onSubmitted,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;
  bool _showSuggestions = false;
  final List<Map<String, String>> _promptSuggestions = [
    {
      'title': 'Learn code',
      'description': 'Help me learn programming concepts'
    },
    {'title': 'Story generator', 'description': 'Generate a creative story'},
    {
      'title': 'Grammar corrector',
      'description': 'Check and correct my grammar'
    },
    {'title': 'Resume editing', 'description': 'Help improve my resume'},
    {'title': 'Math solver', 'description': 'Solve math problems'},
    {
      'title': 'Language translator',
      'description': 'Translate text to another language'
    },
    {
      'title': 'Recipe generator',
      'description': 'Suggest recipes based on ingredients'
    },
    {'title': 'Travel planner', 'description': 'Plan my travel itinerary'},
  ];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
      _showSuggestions = false;
    });
    widget.onSubmitted(text.trim());
  }

  void _handleTextChanged(String text) {
    setState(() {
      _isComposing = text.isNotEmpty;
      _showSuggestions = text == '/';
    });
  }

  void _selectSuggestion(String title) {
    setState(() {
      _textController.text = title;
      _showSuggestions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_showSuggestions)
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: ListView.builder(
                  itemCount: _promptSuggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = _promptSuggestions[index];
                    return ListTile(
                      title: Text(suggestion['title']!),
                      subtitle: Text(
                        suggestion['description']!,
                        style: const TextStyle(fontSize: 12),
                      ),
                      onTap: () => _selectSuggestion(suggestion['title']!),
                    );
                  },
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    onPressed: () {
                      // Handle attachment
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      onChanged: _handleTextChanged,
                      onSubmitted: _isComposing ? _handleSubmitted : null,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
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
                    onPressed: _isComposing
                        ? () => _handleSubmitted(_textController.text)
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}