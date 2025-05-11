import 'package:chatbot_ai/features/assistant/bloc/assistant_bloc.dart';
import 'package:chatbot_ai/features/assistant/bloc/assistant_event.dart';
import 'package:chatbot_ai/features/assistant/bloc/assistant_state.dart';
import 'package:chatbot_ai/features/assistant/bloc/knowledge_event.dart';
import 'package:chatbot_ai/features/assistant/bloc/knowledge_bloc.dart';
import 'package:chatbot_ai/features/assistant/bloc/knowledge_state.dart';
import 'package:chatbot_ai/features/assistant/pages/assistant_create.dart';
import 'package:chatbot_ai/features/assistant/pages/widgets/assistant_item.dart';
import 'package:chatbot_ai/features/assistant/pages/widgets/knowledge_item.dart';
import 'package:chatbot_ai/features/assistant/pages/knowledge_create.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssistantHomePage extends StatefulWidget {
  const AssistantHomePage({Key? key}) : super(key: key);

  @override
  State<AssistantHomePage> createState() => _AssistantHomePageState();
}

class _AssistantHomePageState extends State<AssistantHomePage> {
  int _selectedTab = 0; // 0: Create Assistant, 1: Knowledge Base
  AssistantBloc bloc = AssistantBloc();
  KnowledgeBloc knowledgeBloc = KnowledgeBloc();
  StateGetAssistants currentState = StateGetAssistants(
    data: [],
    limit: 10,
    offset: 0,
    hasNext: true,
    total: 0,
  );
  StateGetKnowledges currentKnowledgeState = StateGetKnowledges(
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
    knowledgeBloc.add(EventGetKnowledges(currentState: currentKnowledgeState));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AssistantBloc>.value(value: bloc),
        BlocProvider<KnowledgeBloc>.value(value: knowledgeBloc),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AssistantBloc, AssistantState>(
            bloc: bloc,
            listener: (context, state) {
              if (state is StateCreateAssistant || state is StateUpdateAssistant) {
                if (state.isSuccess ?? false) {
                  bloc.add(EventGetAssistants(currentState: currentState));
                }
              }
            },
          ),
          BlocListener<KnowledgeBloc, KnowledgeState>(
            bloc: knowledgeBloc,
            listener: (context, state) {
              if (state is StateCreateKnowledge || state is StateUpdateKnowledge) {
                if (state.isSuccess ?? false) {
                  knowledgeBloc.add(EventGetKnowledges(currentState: currentKnowledgeState));
                }
              }
            },
          ),
        ],
        child: BlocBuilder<AssistantBloc, AssistantState>(
          bloc: bloc,
          builder: (context, state) {
            if (state is StateGetAssistants) {
              currentState = state;
            }
            return BlocBuilder<KnowledgeBloc, KnowledgeState>(
              bloc: knowledgeBloc,
              builder: (context, knowledgeState) {
                if (knowledgeState is StateGetKnowledges) {
                  currentKnowledgeState = knowledgeState;
                }
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
                                ? RefreshIndicator(
                                    onRefresh: () async {
                                      setState(() {
                                        currentState = currentState.copyWith(
                                          data: [],
                                          offset: 0,
                                          limit: 10,
                                          hasNext: true,
                                          total: 0,
                                        );
                                      });
                                      bloc.add(EventGetAssistants(currentState: currentState));
                                    },
                                    child: (currentState.data.isEmpty
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
                                            child: RefreshIndicator(
                                              onRefresh: () async {
                                                setState(() {
                                                  currentState = currentState.copyWith(
                                                    data: [],
                                                    offset: 0,
                                                    limit: 10,
                                                    hasNext: true,
                                                    total: 0,
                                                  );
                                                });
                                                bloc.add(EventGetAssistants(currentState: currentState));
                                              },
                                              child: ListView.builder(
                                                itemCount: currentState.data.length + (currentState.hasNext ? 1 : 0),
                                                itemBuilder: (context, index) {
                                                  if (index < currentState.data.length) {
                                                    final assistant = currentState.data[index];
                                                    return AssistantItemCard(
                                                      key: ValueKey(assistant.id ?? assistant.hashCode),
                                                      bloc: bloc,
                                                      item: assistant,
                                                      onDeleteAssistant: () {
                                                        setState(() {
                                                          currentState = currentState.copyWith(
                                                            data: List.from(currentState.data)..removeAt(index),
                                                            offset: currentState.offset - 1,
                                                          );
                                                        });
                                                      },
                                                    );
                                                  } else {
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
                                            ),
                                          )),
                                  )
                                : RefreshIndicator(
                                    onRefresh: () async {
                                      setState(() {
                                        currentKnowledgeState = currentKnowledgeState.copyWith(
                                          data: [],
                                          offset: 0,
                                          limit: 10,
                                          hasNext: true,
                                          total: 0,
                                        );
                                      });
                                      knowledgeBloc.add(EventGetKnowledges(currentState: currentKnowledgeState));
                                    },
                                    child: (currentKnowledgeState.data.isEmpty
                                        ? Center(
                                            child: Text(
                                              'No knowledge bases yet. Tap the + button to create one!',
                                              style: TextStyle(color: Colors.grey[600]),
                                            ),
                                          )
                                        : NotificationListener<ScrollNotification>(
                                            onNotification: (ScrollNotification scrollInfo) {
                                              if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                                                  !currentKnowledgeState.isLoading &&
                                                  currentKnowledgeState.hasNext) {
                                                knowledgeBloc.add(EventGetKnowledges(currentState: currentKnowledgeState));
                                              }
                                              return false;
                                            },
                                            child: ListView.builder(
                                              itemCount: currentKnowledgeState.data.length + (currentKnowledgeState.hasNext ? 1 : 0),
                                              itemBuilder: (context, index) {
                                                if (index < currentKnowledgeState.data.length) {
                                                  final kb = currentKnowledgeState.data[index];
                                                  return KnowledgeItemCard(
                                                    key: ValueKey(kb.id ?? kb.hashCode),
                                                    item: kb,
                                                    bloc: knowledgeBloc,
                                                    onDeleteAssistant: () {
                                                      setState(() {
                                                        currentKnowledgeState = currentKnowledgeState.copyWith(
                                                          data: List.from(currentKnowledgeState.data)..removeAt(index),
                                                          offset: currentKnowledgeState.offset - 1,
                                                        );
                                                        _selectedTab = 1; // Switch to Knowledge Base tab
                                                      });
                                                    },
                                                  );
                                                } else {
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
                                          )),
                                  ),
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
                              bloc: bloc,
                              onCreateAssistant: () {
                                setState(() {
                                  currentState = currentState.copyWith(
                                    data: [],
                                    offset: 0,
                                    limit: 10,
                                    hasNext: true,
                                    total: 0,
                                  );
                                });
                                bloc.add(EventGetAssistants(currentState: currentState));
                              },
                            ),
                          ),
                        );
                        if (result == true) {
                          bloc.add(EventGetAssistants(currentState: currentState));
                        }
                      } else {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateKnowledgePage(
                              bloc: knowledgeBloc,
                              onCreateKnowledge: () {
                                setState(() {
                                  currentKnowledgeState = currentKnowledgeState.copyWith(
                                    data: [],
                                    offset: 0,
                                    limit: 10,
                                    hasNext: true,
                                    total: 0,
                                  );
                                });
                                knowledgeBloc.add(EventGetKnowledges(currentState: currentKnowledgeState));
                              },
                            ),
                          ),
                        );
                        if (result != null) {
                          knowledgeBloc.add(EventGetKnowledges(currentState: currentKnowledgeState));
                        }
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
