import 'package:chatbot_ai/features/assistant/bloc/assistant_bloc.dart';
import 'package:chatbot_ai/features/assistant/bloc/assistant_event.dart';
import 'package:chatbot_ai/features/assistant/bloc/assistant_state.dart';
import 'package:chatbot_ai/features/assistant/pages/assistant_create.dart';
import 'package:chatbot_ai/features/assistant/pages/widgets/assistant_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssistantHomePage extends StatefulWidget {
  const AssistantHomePage({Key? key}) : super(key: key);

  @override
  State<AssistantHomePage> createState() => _AssistantHomePageState();
}

class _AssistantHomePageState extends State<AssistantHomePage> {

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
  AssistantBloc bloc = AssistantBloc();
  StateGetAssistants currentState = StateGetAssistants(
    data: [],
    limit: 10,
    offset: 0,
    hasNext: true,
    total: 0,
  );

  @override
  void initState() {
    super.initState();
    bloc.add(EventGetAssistants(currentState: currentState));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: BlocListener<AssistantBloc, AssistantState>(
        bloc: bloc,
        listener: (context, state) {
          if(state is StateGetAssistants) {
            setState(() {
              currentState = state;
            });
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                              color: _selectedTab == 0
                                  ? Colors.deepPurple
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Bots',
                              style: TextStyle(
                                color: _selectedTab == 0
                                    ? Colors.white
                                    : Colors.deepPurple,
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
                              color: _selectedTab == 1
                                  ? Colors.deepPurple
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Knowledge Base',
                              style: TextStyle(
                                color: _selectedTab == 1
                                    ? Colors.white
                                    : Colors.deepPurple,
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
                        ? (currentState.data.isEmpty
                            ? Center(
                                child: Text(
                                  'No assistants yet. Tap the + button to create one!',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              )
                            : NotificationListener<ScrollNotification>(
                                onNotification: (ScrollNotification scrollInfo) {
                                  if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                                      !currentState.isLoading &&
                                      currentState.hasNext) {
                                    bloc.add(EventGetAssistants(currentState: currentState));
                                  }
                                  return false;
                                },
                                child: ListView.builder(
                                  itemCount: currentState.data.length + (currentState.hasNext ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index < currentState.data.length) {
                                      final assistant = currentState.data[index];
                                      return AssistantItemCard(
                                        item: AssistantItem.fromAssistantModel(assistant),
                                      );
                                    } else {
                                      // Loader at the bottom
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                                        child: Center(
                                          child: SizedBox(
                                            width: 28,
                                            height: 28,
                                            child: CircularProgressIndicator(strokeWidth: 3),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
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
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: ListTile(
                                      leading: const Icon(Icons.menu_book,
                                          color: Colors.deepPurple),
                                      title: Text(kb['title'] ?? '',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
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
            onPressed: () async {
              if (_selectedTab == 0) {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateAssistantPage(
                      onCreateAssistant: () {
                        bloc.add(EventGetAssistants(currentState: currentState));
                      },
                    ),
                  ),
                );
                if (result == true) {
                  bloc.add(EventGetAssistants(currentState: currentState));
                }
              } else {
                // TODO: Implement create knowledge base action
              }
            },
          ),
        ),
      ),
    );
  }
}
