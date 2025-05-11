import 'package:chatbot_ai/features/assistant/data/assistant_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatbot_ai/features/assistant/bloc/assistant_bloc.dart';
import 'package:chatbot_ai/features/assistant/bloc/assistant_event.dart';
import 'package:chatbot_ai/features/assistant/pages/assistant_create.dart';
import 'package:chatbot_ai/features/assistant/bloc/assistant_state.dart';

class AssistantItemCard extends StatefulWidget {
  const AssistantItemCard({super.key, required this.item, required this.bloc, required this.onDeleteAssistant});
  final AssistantModel item;
  final AssistantBloc bloc;
  final Function() onDeleteAssistant;

  @override
  State<AssistantItemCard> createState() => _AssistantItemCardState();
}

class _AssistantItemCardState extends State<AssistantItemCard> {
  late AssistantModel updatedItem;
  @override
  void initState() {
    updatedItem = widget.item;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => widget.bloc,
      child: BlocListener<AssistantBloc, AssistantState>(
        bloc: widget.bloc,
        listener: (context, state) {
          if(state is StateUpdateAssistant) {
            if (state.isSuccess == true) {
              if(widget.item.id == state.assistant?.id) {
                setState(() {
                updatedItem = state.assistant ?? updatedItem;
                });
              } 
            }
          }
          if (state is StateDeleteAssistant) {
            if (state.isSuccess == true) {
              if(widget.item.id == state.assistantantId) {
              widget.onDeleteAssistant.call(); 
              }
            }
          }
        },
        child:  Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.smart_toy, color: Colors.deepPurple),
                title: Text(updatedItem.assistantName ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(updatedItem.description ?? ''),
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
                              bloc: widget.bloc,
                              onCreateAssistant: () {
                               
                              },
                              assistantId: updatedItem.id,
                              assistantName: updatedItem.assistantName,
                              description: updatedItem.description,
                              instructions: updatedItem.instructions,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        updatedItem.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        widget.bloc.add(
                            EventFavoriteAssistant(
                                assistantId: updatedItem.id ?? ''));
                                setState(() {
                                  updatedItem.isFavorite = !updatedItem.isFavorite;
                                });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        widget.bloc.add(
                            EventDeleteAssistant(assistantId: updatedItem.id ?? ' '));
                      },
                    ),
                  ],
                ),
              ),
            ))
    );
  }
}
