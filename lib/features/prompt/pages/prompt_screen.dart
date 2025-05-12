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
  StatePromptGet statePromptGet = StatePromptGet(
      data: [],
      limit: 10,
      offset: 0,
      hasNext: true,
      total: 0,
      isLoading: true,
      isPublic: true);
  String selectedFilter = 'All';
  final List<String> filterOptions = ['All', 'Favorite', 'Public', 'Private'];

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

  @override
  Widget build(BuildContext context) {
    super.build(context);
          print('All prompts:');
      for (var p in statePromptGet.data) {
        print('title: ${p.title}, isPublic: ${p.isPublic}, isFavorite: ${p.isFavorite}');
      }
    // Filter prompts based on selectedFilter
    List<PromptGetModel> filteredPrompts = statePromptGet.data.where((prompt) {
      if (selectedFilter == 'Favorite') {
        return prompt.isFavorite == true;
      } else if (selectedFilter == 'Public') {
        return prompt.isPublic == true;
      } else if (selectedFilter == 'Private') {
        // Lọc prompt private của chính user
        final currentUserId = StoreData.instant.pref.getString('user_id');
        return prompt.isPublic == false && prompt.userId == currentUserId;
      }
      return true;
    }).toList();
    return BlocProvider(
          create: (context) => promptBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<PromptBloc, PromptState>(
            bloc: promptBloc,
            listenWhen: (_, state) => state is StatePromptGet,
            listener: (context, state) {
              if (state is StatePromptGet) {
                if (state.isLoading) {
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
              promptBloc.add(EventPromptGet(currentState: statePromptGet));
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
                        DropdownButton<String>(
                          value: selectedFilter,
                          items: filterOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedFilter = value!;
                            });
                          },
                        ),
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
            backgroundColor: Colors.black,
            child: const Icon(Icons.add, color: Colors.white),
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