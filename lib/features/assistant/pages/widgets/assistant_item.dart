import 'package:flutter/material.dart';

class AssistantItem {
  final String id;
  final String assistantName;
  final String description;

  AssistantItem({
    required this.id,
    required this.assistantName,
    required this.description,
  });

  factory AssistantItem.fromJson(Map<String, dynamic> json) {
    return AssistantItem(
      id: json['id'] ?? '',
      assistantName: json['assistantName'] ?? '',
      description: json['description'] ?? '',
    );
  }

  factory AssistantItem.fromAssistantModel(dynamic model) {
    return AssistantItem(
      id: model.id ?? '',
      assistantName: model.assistantName ?? '',
      description: model.description ?? '',
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
      ),
    );
  }
}