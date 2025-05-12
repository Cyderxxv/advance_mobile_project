import 'package:chatbot_ai/features/assistant/bloc/assistant_bloc.dart';
import 'package:chatbot_ai/features/assistant/bloc/assistant_event.dart';
import 'package:chatbot_ai/features/assistant/bloc/assistant_state.dart';
import 'package:chatbot_ai/features/assistant/data/assistant_model.dart';
import 'package:chatbot_ai/features/assistant/pages/assistant_edit.dart';
import 'package:chatbot_ai/features/chat/pages/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatbot_ai/features/chat/data/chat_input_model.dart';

class AssistantDetailPage extends StatefulWidget {
  final String assistantId;
  final AssistantBloc bloc;
  const AssistantDetailPage(
      {super.key, required this.assistantId, required this.bloc});

  @override
  State<AssistantDetailPage> createState() => _AssistantDetailPageState();
}

class _AssistantDetailPageState extends State<AssistantDetailPage> {
  AssistantModel? assistant;
  StateGetAssistantKnowledge knowledgeState = StateGetAssistantKnowledge();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    widget.bloc.add(EventGetAssistantDetail(assistantId: widget.assistantId));
    widget.bloc.add(EventGetAssistantKnowledge(
        assistantId: widget.assistantId,
        currentState: knowledgeState));
  }
void _updateAssistantWithKnowledge() {
  if (assistant != null && knowledgeState.data.isNotEmpty) {
    assistant = assistant!.copyWith(knowledgeBases: knowledgeState.data);
  }
}

@override
Widget build(BuildContext context) {
  return BlocProvider(
    create: (context) => widget.bloc,
    child: BlocListener<AssistantBloc, AssistantState>(
      bloc: widget.bloc,
      listener: (context, state) {
        if (state is StateGetAssistantDetail) {
          setState(() {
            assistant = state.assistant;
            isLoading = false;
          });
          _updateAssistantWithKnowledge();
        }
        if (state is StateGetAssistantKnowledge) {
          setState(() {
            knowledgeState = state;
          });
          _updateAssistantWithKnowledge();
        }
      
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF6F7FB),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Assistant Detail',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 0.5,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: assistant == null
                    ? null
                    : () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditAssistantPage(
                              bloc: widget.bloc,
                              onEditAssistant: (
                                item,
                              ) =>
                                  setState(() {
                                assistant = item.copyWith(
                                  knowledgeBases: knowledgeState.data,
                                );
                              }),
                              assistant: assistant!,
                            ),
                          ),
                        );
                      },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: assistant == null
                    ? null
                    : () {
                        widget.bloc.add(EventDeleteAssistant(
                            assistantId: assistant!.id ?? ''));
                      },
              ),
            ],
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : assistant == null
                  ? const Center(child: Text('Assistant not found'))
                  : Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 24),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: const Icon(Icons.smart_toy,
                                          color: Colors.white, size: 28),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'Assistant Details',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 28),
                                const Text(
                                  'Assistant Name',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Colors.black87),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Text(
                                    assistant!.assistantName ?? '-',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black87),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Description',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Colors.black87),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Text(
                                    assistant!.description ?? '-',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black87),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Instructions',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Colors.black87),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Text(
                                    assistant!.instructions ?? '-',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black87),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Knowledge Base',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Colors.black87),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: (assistant != null &&
                                          assistant!.knowledgeBases != null &&
                                          assistant!.knowledgeBases!.isNotEmpty)
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: assistant!.knowledgeBases!
                                              .map<Widget>((kb) => Text(
                                                    '- ${kb.knowledgeName ?? '-'}',
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black87),
                                                  ))
                                              .toList(),
                                        )
                                      : const Text(
                                          '-',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87),
                                        ),
                                ),
                                const SizedBox(height: 20),
                                Center(
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.chat_bubble_outline),
                                    label: const Text('Chat with this Assistant'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: assistant == null
                                        ? null
                                        : () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => ChatScreen(
                                                  initialPrompt: '',
                                                  conversationId: null,
                                                  assistant: assistant == null ? null :
                                                    Assistant(
                                                      model: 'knowledge-base',
                                                      name: assistant!.assistantName ?? '-',
                                                      id: assistant!.id ?? '',
                                                    ),
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
