import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatbot_ai/features/assistant/bloc/assistant_bloc.dart';
import 'package:chatbot_ai/features/assistant/bloc/assistant_event.dart';

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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.smart_toy, color: Colors.deepPurple),
        title: Text(item.assistantName,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(item.description),
        trailing: IconButton(
          icon: Icon(
            item.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
          ),
          onPressed: () {
            final bloc = BlocProvider.of<AssistantBloc>(context);
            bloc.add(EventFavoriteAssistant(assistantId: item.id));
          },
        ),
      ),
    );
  }
}