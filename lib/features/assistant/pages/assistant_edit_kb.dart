import 'package:flutter/material.dart';
import 'package:chatbot_ai/features/assistant/pages/widgets/knowledge_item.dart';
import 'package:chatbot_ai/features/assistant/data/knowledge_model.dart';
import 'package:chatbot_ai/features/assistant/bloc/knowledge_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'assistant_add_kb.dart';
import 'package:chatbot_ai/features/assistant/bloc/assistant_bloc.dart';
import 'package:chatbot_ai/features/assistant/domain/assistant_repo.dart';

class AssistantEditKBPage extends StatefulWidget {
  final List<KnowledgeModel> knowledgeBases;
  final Set<String> selectedKBs;
  final void Function(Set<String>)? onSelectionChanged;

  const AssistantEditKBPage({
    Key? key,
    required this.knowledgeBases,
    required this.selectedKBs,
    this.onSelectionChanged,
  }) : super(key: key);

  @override
  State<AssistantEditKBPage> createState() => _AssistantEditKBPageState();
}

class _AssistantEditKBPageState extends State<AssistantEditKBPage> {
  late Set<String> _selectedKBs;

  @override
  void initState() {
    super.initState();
    _selectedKBs = Set<String>.from(widget.selectedKBs);
  }

  void _removeKB(String kbId) async {
    final assistantId = ModalRoute.of(context)?.settings.arguments as String?;
    if (assistantId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Assistant ID not found')));
      return;
    }
    try {
      final response = await AssistantRepo.instant.removeKnowledgeFromAssistant(
        assistantId: assistantId,
        knowledgeId: kbId,
      );
      if (response != null && response.statusCode == 204) {
        setState(() {
          _selectedKBs.remove(kbId);
          widget.knowledgeBases.removeWhere((kb) => kb.id == kbId);
          widget.onSelectionChanged?.call(_selectedKBs);
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Knowledge base removed successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to remove knowledge base')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error removing knowledge base')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final assistantId = ModalRoute.of(context)?.settings.arguments as String?;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Assistant Knowledge Bases', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: widget.knowledgeBases.length,
        separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF0F0F0)),
        itemBuilder: (context, index) {
          final kb = widget.knowledgeBases[index];
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
                    onPressed: () {
                      _removeKB(kb.id ?? '');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Icon(Icons.delete),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (_) => AssistantBloc(),
                child: AssistantAddKBPage(
                  usedKBIds: _selectedKBs,
                  assistantId: assistantId,
                  onAdd: (kbId) {
                    setState(() {
                      _selectedKBs.add(kbId);
                      widget.onSelectionChanged?.call(_selectedKBs);
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          );
        },
        child: const Icon(Icons.add, size: 32),
        tooltip: 'Add Knowledge Base',
      ),
    );
  }
}
