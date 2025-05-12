import 'package:chatbot_ai/features/assistant/bloc/knowledge_bloc.dart';
import 'package:chatbot_ai/features/assistant/bloc/knowledge_event.dart';
import 'package:chatbot_ai/features/assistant/bloc/knowledge_state.dart';
import 'package:chatbot_ai/features/assistant/data/knowledge_model.dart';
import 'package:chatbot_ai/features/assistant/pages/knowledge_create.dart';
import 'package:chatbot_ai/features/assistant/pages/knowledge_datasource.dart';
import 'package:chatbot_ai/features/assistant/pages/datasource_import.dart';
import 'package:flutter/material.dart';

class KnowledgeDetailPage extends StatefulWidget {
  final String knowledgeId;
  final KnowledgeBloc bloc;
  const KnowledgeDetailPage({super.key, required this.knowledgeId, required this.bloc});

  @override
  State<KnowledgeDetailPage> createState() => _KnowledgeDetailPageState();
}

class _KnowledgeDetailPageState extends State<KnowledgeDetailPage> {
  KnowledgeModel? knowledge;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  void _fetchDetail() async {
    widget.bloc.stream.listen((state) {
      if (state is StateGetKnowledges) {
        final found = state.data.firstWhere(
          (a) => a.id == widget.knowledgeId,
          orElse: () => KnowledgeModel(id: widget.knowledgeId),
        );
        setState(() {
          knowledge = found;
          isLoading = false;
        });
      }
      if (state is StateDeleteKnowledge && state.isSuccess == true) {
        Navigator.pop(context, true); // Return true to indicate deletion
      }
    });
    widget.bloc.add(EventGetKnowledges(currentState: StateGetKnowledges()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Knowledge Detail',
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
            onPressed: knowledge == null
                ? null
                : () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateKnowledgePage(
                          bloc: widget.bloc,
                          onCreateKnowledge: () => setState(() {}),
                          knowledgeId: knowledge!.id,
                          knowledgeName: knowledge!.knowledgeName,
                          description: knowledge!.description,
                        ),
                      ),
                    );
                  },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: knowledge == null
                ? null
                : () {
                    widget.bloc.add(EventDeleteKnowledge(id: knowledge!.id ?? ''));
                  },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : knowledge == null
              ? const Center(child: Text('KB not found'))
              : Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.storage),
                                  label: const Text('View Datasources'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF7C3AED), // Violet
                                    foregroundColor: Colors.white,
                                    textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 0,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => KnowledgeDatasourcePage(
                                          knowledgeId: knowledge!.id ?? '',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF7C3AED),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: const Icon(Icons.smart_toy, color: Colors.white, size: 28),
                                  ),
                                  const SizedBox(width: 14),
                                  const Text(
                                    'KB Details',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF22223B)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 28),
                              const Text(
                                'KB Name',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Colors.black87),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.08),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  knowledge!.knowledgeName ?? '-',
                                  style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
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
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.08),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  knowledge!.description ?? '-',
                                  style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7C3AED), // Violet
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DatasourceImportPage(
                knowledgeId: knowledge!.id ?? '',
              ),
            ),
          );
        },
        child: const Icon(Icons.add, size: 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
      ),
    );
  }
}
