import 'package:chatbot_ai/features/chat/pages/chat_home.dart';
import 'package:chatbot_ai/features/profiles/pages/profile.dart';
import 'package:chatbot_ai/features/prompt/bloc/prompt_bloc.dart';
import 'package:chatbot_ai/features/prompt/bloc/prompt_event.dart';
import 'package:chatbot_ai/features/prompt/bloc/prompt_state.dart';
import 'package:chatbot_ai/features/prompt/pages/widgets/widget_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../history/data/history.dart';
import '../../chat/pages/chat_screen.dart';

class PromptScreen extends StatefulWidget {
  const PromptScreen({super.key});

  @override
  State<PromptScreen> createState() => _PromptScreenState();
}

class _PromptScreenState extends State<PromptScreen> {
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
  Widget build(BuildContext context) {
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
          BlocListener<PromptBloc, PromptState>(
            listenWhen: (_, state) => state is StatePromptToggleFavorite,
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
          bottomNavigationBar: _buildBottomNavBar(),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home_outlined, false, () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ChatHomeScreen()),
            );
          }),
          _buildNavItem(Icons.history, true, () {}),
          _buildNavItem(Icons.person_outline, false, () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        size: 28,
        color: isSelected ? Colors.black : Colors.grey,
      ),
    );
  }
}
