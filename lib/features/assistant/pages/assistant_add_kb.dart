import 'package:flutter/material.dart';
import 'package:chatbot_ai/features/assistant/data/knowledge_model.dart';
import 'package:chatbot_ai/features/assistant/pages/widgets/knowledge_item.dart';
import 'package:chatbot_ai/features/assistant/bloc/knowledge_bloc.dart';
import 'package:chatbot_ai/features/assistant/domain/knowledge_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatbot_ai/features/assistant/bloc/assistant_bloc.dart';
import 'package:chatbot_ai/features/assistant/bloc/assistant_event.dart';
import 'package:chatbot_ai/features/assistant/bloc/assistant_state.dart';
import 'dart:async';

class AssistantAddKBPage extends StatefulWidget {
  final Set<String> usedKBIds;
  final void Function(String kbId)? onAdd;
  final String? assistantId;

  const AssistantAddKBPage({
    Key? key,
    required this.usedKBIds,
    this.onAdd,
    this.assistantId,
  }) : super(key: key);

  @override
  State<AssistantAddKBPage> createState() => _AssistantAddKBPageState();
}

class _AssistantAddKBPageState extends State<AssistantAddKBPage> {
  late Future<List<KnowledgeModel>> _futureKBs;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _futureKBs = _fetchKnowledges();
  }

  Future<List<KnowledgeModel>> _fetchKnowledges() async {
    final response = await KnowledgeRepo.instant.getKnowledges();
    if (response == null || response.data == null) {
      throw Exception('Failed to load knowledge bases');
    }
    final data = response.data['data'] ?? [];
    return List<KnowledgeModel>.from(
      data.map((e) => KnowledgeModel.fromJson(e)),
    );
  }

  void _importKnowledge(String kbId) async {
    if (widget.assistantId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Assistant ID not found')));
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final bloc = BlocProvider.of<AssistantBloc>(context);
    StreamSubscription? subscription;
    subscription = bloc.stream.listen((state) {
      if (state is StateImportKnowledgeToAssistant) {
        setState(() {
          _isLoading = false;
        });
        if (state.isSuccess == true) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Knowledge base added successfully')));
          widget.onAdd?.call(kbId);
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message ?? 'Failed to add knowledge base')));
        }
        subscription?.cancel();
      }
    });
    bloc.add(EventImportKnowledgeToAssistant(
      assistantId: widget.assistantId!,
      knowledgeId: kbId,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add Knowledge Base', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<KnowledgeModel>>(
              future: _futureKBs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Failed to load knowledge bases', style: TextStyle(color: Colors.red)));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No knowledge bases found.', style: TextStyle(color: Colors.black54)));
                }
                final unusedKBs = snapshot.data!.where((kb) => !widget.usedKBIds.contains(kb.id)).toList();
                if (unusedKBs.isEmpty) {
                  return const Center(child: Text('No more knowledge bases to add.', style: TextStyle(color: Colors.black54)));
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: unusedKBs.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF0F0F0)),
                  itemBuilder: (context, index) {
                    final kb = unusedKBs[index];
                    return Stack(
                      children: [
                        KnowledgeItemCard(
                          item: kb,
                          bloc: KnowledgeBloc(),
                          onDeleteAssistant: () {},
                        ),
                        Positioned(
                          right: 16,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () => _importKnowledge(kb.id ?? ''),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: const Text('Add'),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
    );
  }
}
