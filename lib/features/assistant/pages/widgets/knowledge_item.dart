import 'package:chatbot_ai/features/assistant/data/knowledge_model.dart';
import 'package:chatbot_ai/features/assistant/pages/knowledge_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatbot_ai/features/assistant/bloc/knowledge_bloc.dart';
import 'package:chatbot_ai/features/assistant/bloc/knowledge_state.dart';

class KnowledgeItemCard extends StatefulWidget {
  const KnowledgeItemCard({super.key, required this.item, required this.bloc, required this.onDeleteAssistant});
  final KnowledgeModel item;
  final KnowledgeBloc bloc;
  final Function() onDeleteAssistant;

  @override
  State<KnowledgeItemCard> createState() => _KnowledgeItemCardState();
}

class _KnowledgeItemCardState extends State<KnowledgeItemCard> {
  late KnowledgeModel updatedItem;
  @override
  void initState() {
    updatedItem = widget.item;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => widget.bloc,
      child: BlocListener<KnowledgeBloc, KnowledgeState>(
        bloc: widget.bloc,
        listener: (context, state) {
          if(state is StateUpdateKnowledge) {
            if (state.isSuccess == true) {
              if(widget.item.id == state.knowledge?.id) {
                setState(() {
                updatedItem = state.knowledge ?? updatedItem;
                });
              } 
            }
          }
          if (state is StateDeleteKnowledge) {
            if (state.isSuccess == true) {
              if(widget.item.id == state.knowledgeId) {
              widget.onDeleteAssistant.call(); 
              }
            }
          }
        },
        child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KnowledgeDetailPage(
                        knowledgeId: updatedItem.id ?? '',
                        bloc: widget.bloc,
                      ),
                    ),
                  );
                },
                leading: const Icon(Icons.book_online_outlined, color: Colors.deepPurple),
                title: Text(updatedItem.knowledgeName ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(updatedItem.description ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  ],
                ),
              ),
            ))
    );
  }
}
