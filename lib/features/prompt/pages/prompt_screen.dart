import 'package:chatbot_ai/features/prompt/bloc/prompt_bloc.dart';
import 'package:chatbot_ai/features/prompt/bloc/prompt_event.dart';
import 'package:chatbot_ai/features/prompt/bloc/prompt_state.dart';
import 'package:chatbot_ai/features/prompt/pages/widgets/widget_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          body: SingleChildScrollView(
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
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: statePromptGet.data.length,
                  itemBuilder: (context, index) {
                    return WidgetPrompt(
                      data: statePromptGet.data[index],
                      onFavoriteToggle: (id) {
                        setState(() {
                          
                        statePromptGet.data[index].isFavorite = !(statePromptGet.data[index].isFavorite??false);
                        });
                        promptBloc.add(EventToggleFavorite(promptId: id,isFavorite: !(statePromptGet.data[index].isFavorite??false)));
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          
        ),
      ),
    );
  }
}