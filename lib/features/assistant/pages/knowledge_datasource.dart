import 'package:flutter/material.dart';
import 'package:chatbot_ai/features/assistant/data/datasource_model.dart';
import 'package:chatbot_ai/features/assistant/pages/widgets/datasource_item.dart';
import 'package:chatbot_ai/features/assistant/domain/knowledge_repo.dart';

class KnowledgeDatasourcePage extends StatefulWidget {
  final String knowledgeId;
  const KnowledgeDatasourcePage({Key? key, required this.knowledgeId}) : super(key: key);

  @override
  State<KnowledgeDatasourcePage> createState() => _KnowledgeDatasourcePageState();
}

class _KnowledgeDatasourcePageState extends State<KnowledgeDatasourcePage> {
  bool isLoading = true;
  List<DatasourceModel> datasources = [];

  @override
  void initState() {
    super.initState();
    _fetchDatasources();
  }

  Future<void> _fetchDatasources() async {
    setState(() { isLoading = true; });
    try {
      final response = await KnowledgeRepo.instant.getDatasourcesFromKB(
        knowledgeId: widget.knowledgeId,
        limit: 50,
        offset: 0,
      );
      if (response.statusCode == 200) {
        datasources = (response.data['data'] as List?)?.map((e) => DatasourceModel.fromJson(e)).toList() ?? [];
      }
    } catch (e) {
      // ignore error, show empty
    }
    setState(() { isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Knowledge Base Datasources', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchDatasources,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : datasources.isEmpty
                ? const Center(child: Text('No datasource found', style: TextStyle(color: Colors.black54)))
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    itemCount: datasources.length,
                    itemBuilder: (context, index) {
                      return DatasourceItem(data: datasources[index]);
                    },
                  ),
      ),
    );
  }
}
