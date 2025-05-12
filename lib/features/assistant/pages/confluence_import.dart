import 'package:chatbot_ai/features/assistant/bloc/knowledge_bloc.dart';
import 'package:chatbot_ai/features/assistant/bloc/knowledge_event.dart';
import 'package:chatbot_ai/features/assistant/bloc/knowledge_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfluenceImportPage extends StatefulWidget {
  const ConfluenceImportPage({
    super.key,
    this.name,
    this.wikiUrl,
    this.token,
    this.username,
    required this.bloc,
    required this.knowledgeId,
  });

  final String? name;
  final String? wikiUrl;
  final String? token;
  final String? username;
  final String knowledgeId;
  final KnowledgeBloc bloc;

  @override
  State<ConfluenceImportPage> createState() => _CreateKnowledgePageState();
}

class _CreateKnowledgePageState extends State<ConfluenceImportPage> {
  void onImportKBFromConfluence(BuildContext context, String name, String wikiUrl, String username, String token) async {
    widget.bloc.add(EventImportKBFromConfluence(
      name: name,
      wikiUrl: wikiUrl,
      username: username,
      token: token,
      knowledgeId: widget.knowledgeId,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: widget.name);
    final usernameController =
        TextEditingController(text: widget.username);
    final tokenController = TextEditingController(text: widget.token);
    final wikiUrlController = TextEditingController(text: widget.wikiUrl);
    return BlocProvider(
      create: (context) => widget.bloc,
      child: BlocListener<KnowledgeBloc, KnowledgeState>(
        bloc: widget.bloc,
        listener: (context, state) {
          if (state is StateImportKBFromConfluence) {
            if ((state.isSuccess ?? false)) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message ?? 'Success'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message ?? 'Failed'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF6F7FB),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF7C3AED)), // Purple
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              widget.knowledgeId != ''
                  ? 'Import Confluence'
                  : 'Create KB',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 0.5,
              ),
            ),
            centerTitle: true,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF7C3AED), // Purple
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(Icons.smart_toy,
                                color: Colors.white, size: 28),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Confluence Import',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'Name',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'Enter name',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 14),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Username',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: usernameController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Enter username',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 14),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Wiki URL',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: wikiUrlController,
                        decoration: InputDecoration(
                          hintText: 'Enter wiki URL',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 14),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Token',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: tokenController,
                        decoration: InputDecoration(
                          hintText: 'Enter token',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 14),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 200),
                          tween: Tween(begin: 1.0, end: 1.0),
                          builder: (context, scale, child) {
                            return Transform.scale(
                              scale: scale,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF7C3AED), // Purple
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 2,
                                ),
                                onPressed: () {
                                  print('Dispatching EventUpdateAssistant'); // Debug log
                                  onImportKBFromConfluence(
                                    context,
                                    nameController.text,
                                    wikiUrlController.text,
                                    usernameController.text,
                                    tokenController.text,
                                  );
                                },
                                child: const Text(
                                  'Save',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.2),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
