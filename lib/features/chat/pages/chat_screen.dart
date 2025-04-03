import 'package:flutter/material.dart';
import 'widgets/chat_message.dart';
import 'widgets/chat_input.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _addInitialMessages();
  }

  void _addInitialMessages() {
    Future.delayed(const Duration(milliseconds: 500), () {
      _addMessage(
        'Hello! I' 'm ByMax, your AI assistant. How can I help you today?',
        false,
      );
    });
  }

  void _addMessage(String text, bool isUser) {
    debugPrint('Adding message: $text, isUser: $isUser');
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: isUser,
        timestamp: DateTime.now(),
      ));
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSubmitted(String text) async {
    if (text.isEmpty) {
      debugPrint('User submitted an empty message');
      return;
    }

    debugPrint('User submitted message: $text');
    _addMessage(text, true);
    setState(() => _isTyping = true);

    try {
      debugPrint('Sending message to API: $text');
      // final botResponse = await ApiService.getBotResponse(text);
      // _addMessage(botResponse, false);
    } catch (e) {
      debugPrint('Error getting bot response: $e');
      _addMessage('Error: Unable to get response', false);
    } finally {
      setState(() => _isTyping = false);
      debugPrint('Finished processing message: $text');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.black,
              child: Icon(Icons.android, color: Colors.white, size: 20),
            ),
            SizedBox(width: 8),
            Text(
              'ByMax',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.delete),
                      title: const Text('Clear Chat'),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          _messages.clear();
                        });
                        _addInitialMessages();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.message),
                      title: const Text('Add Test Message'),
                      onTap: () {
                        Navigator.pop(context);
                        _addMessage(
                            'This is a test message from ByMax.', false);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _messages[index],
            ),
          ),
          if (_isTyping)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.centerLeft,
              child: const Text(
                'ByMax is typing...',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
          ChatInput(
            onSubmitted: (_handleSubmitted),
          ),
        ],
      ),
    );
  }
}
