import 'package:chatbot_ai/features/assistant/data/assistant_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatbot_ai/features/assistant/bloc/assistant_bloc.dart';
import 'package:chatbot_ai/features/assistant/bloc/assistant_event.dart';
import 'package:chatbot_ai/features/assistant/pages/assistant_create.dart';
import 'package:chatbot_ai/features/assistant/bloc/assistant_state.dart';

class AssistantItem {
  final String id;
  final String assistantName;
  final String description;
  bool isFavorite; // Added isFavorite property

  AssistantItem({
    required this.id,
    required this.assistantName,
    required this.description,
    this.isFavorite = false, // Default to false
  });

  factory AssistantItem.fromJson(Map<String, dynamic> json) {
    return AssistantItem(
      id: json['id'] ?? '',
      assistantName: json['assistantName'] ?? '',
      description: json['description'] ?? '',
      isFavorite: json['isFavorite'] ?? false, // Parse isFavorite from JSON
    );
  }

  factory AssistantItem.fromAssistantModel(dynamic model) {
    return AssistantItem(
      id: model.id ?? '',
      assistantName: model.assistantName ?? '',
      description: model.description ?? '',
      isFavorite: model.isFavorite ?? false, // Parse isFavorite from model
    );
  }
}

class AssistantItemCard extends StatelessWidget {
  final AssistantItem item;
  const AssistantItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssistantBloc, AssistantState>(
      builder: (context, state) {
        final updatedItem = (state is StateGetAssistants)
            ? AssistantItem.fromAssistantModel(
                state.data.firstWhere((assistant) => assistant.id == item.id, orElse: () => AssistantModel(id: item.id, assistantName: item.assistantName, description: item.description, isFavorite: item.isFavorite)))
            : item;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.smart_toy, color: Colors.deepPurple),
            title: Text(updatedItem.assistantName,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(updatedItem.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateAssistantPage(
                          onCreateAssistant: () {},
                          assistantId: updatedItem.id,
                          assistantName: updatedItem.assistantName,
                          description: updatedItem.description,
                          instructions: '', // Add instructions if available
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    updatedItem.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    context.read<AssistantBloc>().add(EventFavoriteAssistant(assistantId: updatedItem.id));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}