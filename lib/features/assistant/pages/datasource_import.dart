import 'package:chatbot_ai/features/assistant/pages/slack_import.dart';
import 'package:flutter/material.dart';
import 'confluence_import.dart';
import 'package:chatbot_ai/features/assistant/bloc/knowledge_bloc.dart';

class DatasourceImportPage extends StatelessWidget {
  final String knowledgeId;
  final VoidCallback? onAddUnit;
  final VoidCallback? onAddConfluence;
  final VoidCallback? onAddSlack;
  const DatasourceImportPage({Key? key, required this.knowledgeId, this.onAddUnit, this.onAddConfluence, this.onAddSlack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Import Datasource', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Add Knowledge Unit', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: onAddUnit ?? () {
                    Navigator.pushNamed(context, '/blank');
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Add Knowledge Unit Confluence', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: onAddConfluence ?? () {
                    final bloc = KnowledgeBloc(); // hoặc lấy từ context nếu đã được cung cấp
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConfluenceImportPage(
                          knowledgeId: knowledgeId,
                          bloc: bloc,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Add Knowledge Unit Slack', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: onAddSlack ?? () {
                    final bloc = KnowledgeBloc(); // hoặc lấy từ context nếu đã được cung cấp
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SlackImportPage(
                          knowledgeId: knowledgeId,
                          bloc: bloc,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
