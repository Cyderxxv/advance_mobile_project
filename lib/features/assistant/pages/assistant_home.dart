import 'package:chatbot_ai/features/assistant/pages/assistant_create.dart';
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
        title: Text(item.assistantName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(item.description),
      ),
    );
  }
}

class AssistantHomePage extends StatefulWidget {
  const AssistantHomePage({Key? key}) : super(key: key);

  @override
  State<AssistantHomePage> createState() => _AssistantHomePageState();
}

class _AssistantHomePageState extends State<AssistantHomePage> {
  final List<AssistantItem> assistants = [
    AssistantItem(
      id: 'string',
      assistantName: 'Sample Assistant',
      description: 'This is a sample assistant description.',
    ),
  ];

  // Dummy knowledge base data
  final List<Map<String, String>> knowledgeBases = [
    {
      'title': 'Knowledge Base 1',
      'description': 'Description for knowledge base 1.'
    },
    {
      'title': 'Knowledge Base 2',
      'description': 'Description for knowledge base 2.'
    },
  ];

  int _selectedTab = 0; // 0: Create Assistant, 1: Knowledge Base

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Assistants',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey, size: 22),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Search...',
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Tabs for Create Assistant and Knowledge Base
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTab = 0;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedTab == 0 ? Colors.deepPurple : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Bots',
                          style: TextStyle(
                            color: _selectedTab == 0 ? Colors.white : Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTab = 1;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedTab == 1 ? Colors.deepPurple : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Knowledge Base',
                          style: TextStyle(
                            color: _selectedTab == 1 ? Colors.white : Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: _selectedTab == 0
                    ? (assistants.isEmpty
                        ? Center(
                            child: Text(
                              'No assistants yet. Tap the + button to create one!',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          )
                        : ListView.builder(
                            itemCount: assistants.length,
                            itemBuilder: (context, index) {
                              return AssistantItemCard(item: assistants[index]);
                            },
                          ))
                    : (knowledgeBases.isEmpty
                        ? Center(
                            child: Text(
                              'No knowledge bases yet. Tap the + button to create one!',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          )
                        : ListView.builder(
                            itemCount: knowledgeBases.length,
                            itemBuilder: (context, index) {
                              final kb = knowledgeBases[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  leading: const Icon(Icons.menu_book, color: Colors.deepPurple),
                                  title: Text(kb['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  subtitle: Text(kb['description'] ?? ''),
                                ),
                              );
                            },
                          )),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          if (_selectedTab == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateAssistantPage(),
              ),
            );
          } else {
            // TODO: Implement create knowledge base action
          }
        },
        tooltip: _selectedTab == 0 ? 'Create Assistant' : 'Create Knowledge Base',
      ),
    );
  }
}
