import 'package:chatbot_ai/features/chat/bloc/chat_bloc.dart';
import 'package:chatbot_ai/features/chat/bloc/chat_event.dart';
import 'package:chatbot_ai/features/chat/bloc/chat_state.dart';
import 'package:chatbot_ai/features/chat/data/chat_input_model.dart';
import 'package:chatbot_ai/features/chat/pages/widgets/widget_empty_chat.dart';
import 'package:chatbot_ai/features/history/bloc/history_bloc.dart';
import 'package:chatbot_ai/features/history/bloc/history_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatbot_ai/cores/network/dio_network.dart';
import 'package:chatbot_ai/cores/store/store.dart';
import 'widgets/widget_chat_message.dart';
import 'widgets/widget_chat_input.dart';
import 'package:dio/dio.dart';
import 'package:chatbot_ai/features/history/bloc/history_event.dart';

class ChatScreen extends StatefulWidget {
  final String? initialPrompt;
  final String? conversationId;
  final Assistant? assistant;
  const ChatScreen({super.key, this.initialPrompt, this.conversationId, this.assistant});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatBloc _chatBloc = ChatBloc();
  final HistoryBloc _historyBloc = HistoryBloc();
  final ScrollController _scrollController = ScrollController();
  final List<WidgetChatMessage> _messages = [];
  bool _isLoading = false;
  String _selectedModel = 'gpt-4o-mini';
  final List<String> _availableModels = [
    'gpt-4o-mini',
    'gpt-4o',
    'gemini-1.5-flash',
  ];

  final Map<String, Map<String, String>> _modelInfo = {
    'gpt-4o-mini': {
      'model': 'gpt-4o-mini',
      'name': 'GPT-4o Mini',
      'id': 'gpt-4o-mini',
    },
    'gpt-4o': {
      'model': 'gpt-4o',
      'name': 'GPT-3.5 Turbo',
      'id': 'gpt-4o',
    },
    'gemini-1.5-flash': {
      'model': 'dify',
      'name': 'Gemini 1.5 Flash',
      'id': 'gemini-1.5-flash-latest',
    },
  };

  @override
  void initState() {
    super.initState();

    if (widget.conversationId != null) {
      _historyBloc.add(EventGetConversationsHistory(
        conversationId: widget.conversationId!,
        assistantModel: 'dify',
      ));
    } else if (widget.initialPrompt != null &&
        widget.initialPrompt!.isNotEmpty) {
      _messages.add(
        WidgetChatMessage(
          text: widget.initialPrompt!,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _chatBloc.add(EventChat(
        content: ChatInputModel(
          content: widget.initialPrompt!,
          files: [],
          metadata: null,
          assistant: null,
        ),
      ));
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _chatBloc,
        ),
        BlocProvider(
          create: (context) => _historyBloc,
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ChatBloc, ChatState>(
            bloc: _chatBloc,
            listener: (context, state) {
              if (state is StateChatMessageSent) {
                if (state.isLoading) {
                  setState(() {
                    _isLoading = true;
                  });
                } else {
                  setState(() {
                    _isLoading = false;
                    final message = state.message?.message;
                    if (message != null && message.isNotEmpty) {
                      if (_messages.isNotEmpty && !_messages.last.isUser) {
                        _messages.removeLast();
                      }
                      _messages.add(WidgetChatMessage(
                        text: message,
                        isUser: false,
                        timestamp: DateTime.now(),
                      ));
                      _scrollToBottom();
                    }
                  });
                }
              }
            },
          ),
          BlocListener<HistoryBloc, HistoryState>(
            bloc: _historyBloc,
            listener: (context, state) {
              // TODO: implement listener
              if(state is StateGetConversationsHistory) {
                print('StateGetConversationsHistory: ${state.isLoading}');
                if (state.isLoading == true) {
                  setState(() {
                    _isLoading = true;
                  });
                } else {
                  
                    _isLoading = false;
                    if (state.messages != null) {
                      print('okokokokokok');
                      _messages.clear(); // Clear previous messages before adding history
                      for (var message in state.messages!) {
                        _messages.add(
                          WidgetChatMessage(
                            text: message.query ?? '',
                            isUser: true,
                            timestamp: DateTime.now(),
                          ),
                        );
                        _messages.add(
                          WidgetChatMessage(
                            text: message.answer ?? '',
                            isUser: false,
                            timestamp: DateTime.now(),
                          ),
                        );
                      }
                      _scrollToBottom();
                    }
                  setState(() {
                    print('Messages length: ${_messages.length}');
                  });
                }
              }
            },
          ),
        ],
        child: Scaffold(
          resizeToAvoidBottomInset: true,
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
              PopupMenuButton<String>(
                icon: const Icon(Icons.memory, color: Colors.black),
                tooltip: 'Select Model',
                onSelected: (String model) {
                  setState(() {
                    _selectedModel = model;
                  });
                },
                itemBuilder: (context) => _availableModels
                    .map((model) => PopupMenuItem<String>(
                          value: model,
                          child: Row(
                            children: [
                              if (_selectedModel == model)
                                const Icon(Icons.check,
                                    color: Colors.black, size: 18),
                              if (_selectedModel == model)
                                const SizedBox(width: 6),
                              Text(model),
                            ],
                          ),
                        ))
                    .toList(),
              ),
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
                          leading: const Icon(Icons.save),
                          title: const Text('Create Private Prompt'),
                          onTap: () {
                            Navigator.pop(context);
                            if (_messages.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'No chat content to create prompt')),
                              );
                              return;
                            }

                            final firstUserMessage = _messages.firstWhere(
                              (msg) => msg.isUser,
                              orElse: () => _messages.first,
                            );

                            // Show dialog for title input
                            final titleController = TextEditingController();
                            final contentController = TextEditingController();
                            final descriptionController =
                                TextEditingController();

                            // Set default content to first user message
                            contentController.text = firstUserMessage.text;

                            showDialog<String>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Create Private Prompt'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: titleController,
                                        decoration: const InputDecoration(
                                          labelText: 'Prompt Title *',
                                          hintText:
                                              'Enter a title for your prompt',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      TextField(
                                        controller: contentController,
                                        maxLines: 3,
                                        decoration: const InputDecoration(
                                          labelText: 'Prompt Content *',
                                          hintText:
                                              'Enter the content for your prompt',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      TextField(
                                        controller: descriptionController,
                                        maxLines: 2,
                                        decoration: const InputDecoration(
                                          labelText: 'Description (Optional)',
                                          hintText:
                                              'Enter a description for your prompt',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (titleController.text.isNotEmpty &&
                                          contentController.text.isNotEmpty) {
                                        Navigator.pop(context);
                                        try {
                                          final token = StoreData.instant.token;
                                          if (token.isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Authentication required')),
                                            );
                                            return;
                                          }

                                          final headers = {
                                            'x-jarvis-guid':
                                                '361331f8-fc9b-4dfe-a3f7-6d9a1e8b289b',
                                            'Authorization': 'Bearer //',
                                            'Content-Type': 'application/json',
                                          };

                                          final response =
                                              await DioNetwork.instant.dio.post(
                                            '/prompts',
                                            data: {
                                              'title': titleController.text,
                                              'content': contentController.text,
                                              'description': descriptionController
                                                      .text.isNotEmpty
                                                  ? descriptionController.text
                                                  : 'Created from chat conversation',
                                              'isPublic': false,
                                            },
                                            options: Options(
                                              headers: headers,
                                            ),
                                          );

                                          if (response.statusCode == 200) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Private prompt created successfully')),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Error: //${response.data?['message'] ?? 'Failed to create prompt'}')),
                                            );
                                          }
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Error: ${e.toString()}')),
                                          );
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Title and content are required')),
                                        );
                                      }
                                    },
                                    child: const Text('Create'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
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
                Padding(
                  padding: EdgeInsets.only(
                    left: 16.0, 
                    bottom: MediaQuery.of(context).viewInsets.bottom > 0 
                      ? 8.0 
                      : MediaQuery.of(context).padding.bottom + 8.0,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_messages.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('No chat content to create prompt')),
                          );
                          return;
                        }

                        final firstUserMessage = _messages.firstWhere(
                          (msg) => msg.isUser,
                          orElse: () => _messages.first,
                        );

                        // Show dialog for title input
                        final titleController = TextEditingController();
                        final contentController = TextEditingController();
                        final descriptionController = TextEditingController();

                        // Set default content to first user message
                        contentController.text = firstUserMessage.text;

                        showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Create Private Prompt'),
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: titleController,
                                    decoration: const InputDecoration(
                                      labelText: 'Prompt Title *',
                                      hintText: 'Enter a title for your prompt',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: contentController,
                                    maxLines: 3,
                                    decoration: const InputDecoration(
                                      labelText: 'Prompt Content *',
                                      hintText:
                                          'Enter the content for your prompt',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: descriptionController,
                                    maxLines: 2,
                                    decoration: const InputDecoration(
                                      labelText: 'Description (Optional)',
                                      hintText:
                                          'Enter a description for your prompt',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  if (titleController.text.isNotEmpty &&
                                      contentController.text.isNotEmpty) {
                                    Navigator.pop(context);
                                    try {
                                      final token = StoreData.instant.token;
                                      if (token.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Authentication required')),
                                        );
                                        return;
                                      }

                                      final headers = {
                                        'x-jarvis-guid':
                                            '361331f8-fc9b-4dfe-a3f7-6d9a1e8b289b',
                                        'Authorization': 'Bearer ',
                                        'Content-Type': 'application/json',
                                      };

                                      final response =
                                          await DioNetwork.instant.dio.post(
                                        '/prompts',
                                        data: {
                                          'title': titleController.text,
                                          'content': contentController.text,
                                          'description': descriptionController
                                                  .text.isNotEmpty
                                              ? descriptionController.text
                                              : 'Created from chat conversation',
                                          'isPublic': false,
                                        },
                                        options: Options(
                                          headers: headers,
                                        ),
                                      );

                                      if (response.statusCode == 200) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Private prompt created successfully')),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Error: ${response.data?['message'] ?? 'Failed to create prompt'}')),
                                        );
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('Error: ${e.toString()}')),
                                      );
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Title and content are required')),
                                    );
                                  }
                                },
                                child: const Text('Create'),
                              ),
                            ],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Create Private Prompt',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
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
                      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                      final assistantToUse = widget.assistant ?? Assistant(
                        model: _modelInfo[_selectedModel]!['model']!,
                        name: _modelInfo[_selectedModel]!['name']!,
                        id: _modelInfo[_selectedModel]!['id']!,
                      );
                      _chatBloc.add(EventChat(
                        content: ChatInputModel(
                          content: text,
                          files: [],
                          metadata: null,
                          assistant: assistantToUse,
                          headers: {
                            'x-jarvis-guid':
                                '361331f8-fc9b-4dfe-a3f7-6d9a1e8b289b',
                          },
                        ),
                      ));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
