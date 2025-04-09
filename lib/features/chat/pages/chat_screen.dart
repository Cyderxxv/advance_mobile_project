import 'package:chatbot_ai/features/chat/bloc/chat_bloc.dart';
import 'package:chatbot_ai/features/chat/bloc/chat_event.dart';
import 'package:chatbot_ai/features/chat/bloc/chat_state.dart';
import 'package:chatbot_ai/features/chat/data/chat_input_model.dart';
import 'package:chatbot_ai/features/chat/pages/widgets/widget_empty_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/widget_chat_message.dart';
import 'widgets/widget_chat_input.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatBloc _chatBloc = ChatBloc();
  final ScrollController _scrollController = ScrollController();
  final List<WidgetChatMessage> _messages = [];
  bool _isLoading = false;

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _chatBloc,
      child: BlocListener<ChatBloc, ChatState>(
        bloc: _chatBloc,
        listener: (context, state) {
          if(state is StateChatMessageSent) { 
            if (state.isLoading) {
              setState(() {
                _isLoading = true;
              });
            } else {
              setState(() {
                _isLoading = false;
                _messages.add(WidgetChatMessage(
                  text: state.message?.message?? '',
                  isUser: false,
                  timestamp: DateTime.now(),
                ));
            _scrollToBottom();
              });
            }
        }},
        child: Scaffold(
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
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.message),
                          title: const Text('Add Test Message'),
                          onTap: () {
                            Navigator.pop(context);
                            
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
              if (_messages.isEmpty)
                const Expanded(
                  child: WidgetEmptyChat(),
                )
              else
                const SizedBox.shrink(),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) => _messages[index],
                ),
              ),
              if (_isLoading)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                onSubmitted: (text) {
                  if (text.isNotEmpty) {
                    setState(() {
                      _messages.add(
                        WidgetChatMessage(
                          text: text,
                          isUser: true,
                          timestamp: DateTime.now(),
                        ),
                      );
                    });
                    _chatBloc.add(EventChat(
                      content: ChatInputModel(
                        content: text,
                        files: [],
                        metadata: null,
                        assistant: null,
                      ),
                    ));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
