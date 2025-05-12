import 'package:chatbot_ai/features/assistant/bloc/assistant_bloc.dart';
import 'package:chatbot_ai/features/assistant/bloc/assistant_state.dart';
import 'package:chatbot_ai/features/assistant/bloc/assistant_event.dart';
import 'package:chatbot_ai/features/assistant/data/assistant_model.dart';
import 'package:chatbot_ai/features/assistant/domain/assistant_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'assistant_edit_kb.dart';

class EditAssistantPage extends StatefulWidget {
  final AssistantModel assistant;
  final AssistantBloc bloc;
  final Function(AssistantModel assistant) onEditAssistant;
  final String? description;
  final String? instructions;
  const EditAssistantPage({
    super.key,
    required this.assistant,
    required this.bloc,
    required this.onEditAssistant,
    this.description,
    this.instructions,
  });

  @override
  State<EditAssistantPage> createState() => _EditAssistantPageState();
}

class _EditAssistantPageState extends State<EditAssistantPage> {
  late AssistantModel assistant;
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController instructionsController;

  @override
  void initState() {
    super.initState();
    assistant = widget.assistant;
    nameController = TextEditingController(text: assistant.assistantName ?? '');
    descriptionController = TextEditingController(text: assistant.description ?? '');
    instructionsController = TextEditingController(text: assistant.instructions ?? '');
  }

  void onSaveAssistant() {
    widget.bloc.add(EventUpdateAssistant(
      assistantId: assistant.id ??'',
      assistantName: nameController.text,
      description: descriptionController.text,
      instructions: instructionsController.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => widget.bloc,
      child: BlocListener<AssistantBloc, AssistantState>(
        bloc: widget.bloc,
        listener: (context, state) {
          if (state is StateUpdateAssistant) {
            if (state.isSuccess == true) {
              widget.onEditAssistant.call(state.assistant!);
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message ?? 'Failed to update assistant'),
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
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Edit Assistant',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 0.5,
              ),
            ),
            centerTitle: true,
          ),
          body:Center(
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
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: 'Enter assistant name',
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
                              'Description',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.black87),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: descriptionController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Enter description',
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
                              'Instructions',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.black87),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: instructionsController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Enter instructions',
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
                              'Knowledge Base',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.black87),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () async {
                                final allKBs = assistant.knowledgeBases ?? [];
                                final selectedKBs = assistant.knowledgeBases?.where((e) => e.id != null).map((e) => e.id!).toSet() ?? {};
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AssistantEditKBPage(
                                      knowledgeBases: allKBs,
                                      selectedKBs: selectedKBs,
                                      onSelectionChanged: (newSelected) {
                                        // You can update state here if needed
                                      },
                                    ),
                                    settings: RouteSettings(arguments: assistant.id), // Pass assistantId here
                                  ),
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: (assistant.knowledgeBases != null &&
                                        assistant.knowledgeBases!.isNotEmpty)
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: assistant.knowledgeBases!
                                            .map<Widget>((kb) => Text(
                                                  '- ${kb.knowledgeName ?? ''}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black87),
                                                ))
                                            .toList(),
                                      )
                                    : const Text(
                                        '-',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black87),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 2,
                                ),
                                onPressed: onSaveAssistant,
                                child: const Text(
                                  'Save',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.2),
                                ),
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
