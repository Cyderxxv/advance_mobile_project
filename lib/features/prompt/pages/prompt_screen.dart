import 'package:chatbot_ai/features/prompt/bloc/prompt_bloc.dart';
import 'package:chatbot_ai/features/prompt/bloc/prompt_event.dart';
import 'package:chatbot_ai/features/prompt/bloc/prompt_state.dart';
import 'package:chatbot_ai/features/prompt/pages/widgets/widget_prompt.dart';
import 'package:chatbot_ai/features/prompt/pages/widgets/widget_create_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatbot_ai/features/prompt/data/prompt_model.dart';
import 'package:chatbot_ai/cores/store/store.dart';

class PromptScreen extends StatefulWidget {
  const PromptScreen({super.key});

  @override
  State<PromptScreen> createState() => _PromptScreenState();
}

class _PromptScreenState extends State<PromptScreen> with AutomaticKeepAliveClientMixin {
  bool isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  PromptBloc promptBloc = PromptBloc();
  dynamic statePromptGet = StatePromptGet(
      data: [],
      limit: 10,
      offset: 0,
      hasNext: true,
      total: 0,
      isLoading: true,
      isPublic: true);
  String selectedFilter = 'All';
  final List<String> filterOptions = ['All', 'Favorite', 'Public', 'Private'];
  final List<String> categories = [
    'marketing',
    'business',
    'seo',
    'writing',
    'coding',
    'career',
    'chatbot',
    'education',
    'fun',
    'productivity',
    'other',
  ];
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    promptBloc.add(EventPromptGet(
      currentState: statePromptGet,
    ));

    _searchController.addListener(() {
      //_filterPrompts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  void _onFilterChanged(String value) {
    setState(() {
      selectedFilter = value;
      if (value == 'Private') {
        final privateState = StateGetPrivatePrompt(
          data: [],
          limit: 10,
          offset: 0,
          hasNext: true,
          total: 0,
          isLoading: true,
          isPublic: false,
        );
        statePromptGet = privateState;
        promptBloc.add(EventGetPrivatePrompt(currentState: privateState));
      } else {
        final publicState = StatePromptGet(
          data: [],
          limit: 10,
          offset: 0,
          hasNext: true,
          total: 0,
          isLoading: true,
          isPublic: true,
        );
        statePromptGet = publicState;
        promptBloc.add(EventPromptGet(currentState: publicState));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
          print('All prompts:');
      for (var p in statePromptGet.data) {
        print('title: ${p.title}, isPublic: ${p.isPublic}, isFavorite: ${p.isFavorite}');
      }
    // Filter prompts based on selectedFilter and selectedCategory
    List<PromptGetModel> filteredPrompts = statePromptGet.data.where((prompt) {
      bool matchesFilter;
      if (selectedFilter == 'Favorite') {
        matchesFilter = prompt.isFavorite == true;
      } else if (selectedFilter == 'Public') {
        matchesFilter = prompt.isPublic == true;
      } else if (selectedFilter == 'Private') {
        matchesFilter = prompt.isPublic == false;
      } else {
        matchesFilter = true;
      }
      bool matchesCategory = selectedCategory == 'All' || (prompt.category?.toLowerCase() == selectedCategory.toLowerCase());
      return matchesFilter && matchesCategory;
    }).toList();
    return BlocProvider(
          create: (context) => promptBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<PromptBloc, PromptState>(
            bloc: promptBloc,
            listenWhen: (_, state) => state is StatePromptGet || state is StateGetPrivatePrompt,
            listener: (context, state) {
              if (state is StatePromptGet || state is StateGetPrivatePrompt) {
                final loading = (state as dynamic).isLoading;
                if (loading) {
                  setState(() {
                    isLoading = true;
                  });
                } else {
                  setState(() {
                    isLoading = false;
                    statePromptGet = state;
                  });
                } 
              }
            },
          ),
          BlocListener<PromptBloc, PromptState>(
            listenWhen: (_, state) => state is StatePromptUpdate,
            listener: (context, state) {
              // TODO: implement listener
            },
          ),
          BlocListener<PromptBloc, PromptState>(
            listenWhen: (_, state) => state is StatePromptDelete,
            listener: (context, state) {
              // TODO: implement listener
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: Colors.white,
          body: RefreshIndicator(
            onRefresh: () async {
              if (selectedFilter == 'Private') {
                promptBloc.add(EventGetPrivatePrompt(currentState: statePromptGet));
              } else {
                promptBloc.add(EventPromptGet(currentState: statePromptGet));
              }
              // Đợi state cập nhật xong
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Text(
                          'Prompts',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3E8FF), // light violet
                            borderRadius: BorderRadius.circular(20), // rounded
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedFilter,
                              borderRadius: BorderRadius.circular(20),
                              dropdownColor: Colors.white,
                              items: filterOptions.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) _onFilterChanged(value);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Search bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search prompts...',
                        prefixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
                      ),
                      onChanged: (value) {
                        setState(() {}); // Triggers rebuild for search
                      },
                    ),
                  ),
                  // Category chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        ChoiceChip(
                          label: const Text('All'),
                          selected: selectedCategory == 'All',
                          onSelected: (_) {
                            setState(() {
                              selectedCategory = 'All';
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30), // More rounded corners
                          ),
                        ),
                        ...categories.map((cat) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: ChoiceChip(
                                label: Text(cat[0].toUpperCase() + cat.substring(1)),
                                selected: selectedCategory == cat,
                                onSelected: (_) {
                                  setState(() {
                                    selectedCategory = cat;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30), // More rounded corners
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredPrompts.length,
                    itemBuilder: (context, index) {
                      return WidgetPrompt(
                        data: filteredPrompts[index],
                        onFavoriteToggle: (id) {
                          setState(() {
                            filteredPrompts[index].isFavorite = !(filteredPrompts[index].isFavorite??false);
                          });
                          promptBloc.add(EventToggleFavorite(promptId: id,isFavorite: !(filteredPrompts[index].isFavorite??false)));
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xFFF3E8FF), // light violet like filter
            child: const Icon(Icons.add, color: Colors.black),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreatePromptPage(
                    onCreatePrompt: () {
                      // Sau khi tạo prompt xong, reload lại danh sách
                      promptBloc.add(EventPromptGet(currentState: statePromptGet));
                    },
                  ),
                ),
              );
            },
            tooltip: 'Tạo Prompt mới',
          ),
        ),
      ),
    );
  }
}