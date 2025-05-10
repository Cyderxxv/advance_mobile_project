import 'package:chatbot_ai/features/assistant/pages/assistant_home.dart';
import 'package:chatbot_ai/features/chat/pages/chat_home.dart';
import 'package:flutter/material.dart';
import '../../prompt/pages/prompt_screen.dart';
import '../../history/pages/history_screen.dart';
import '../../profiles/pages/profile.dart';
import 'bottom_nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  int _currentIndex = 0;
  final GlobalKey<HistoryScreenState> _historyKey =
      GlobalKey<HistoryScreenState>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const KeepAlive(keepAlive: true, child: ChatHomeScreen()),
          const KeepAlive(keepAlive: true, child: PromptScreen()),
          KeepAlive(keepAlive: true, child: HistoryScreen()),
          const KeepAlive(keepAlive: true, child: ProfileScreen()),
          const KeepAlive(keepAlive: true, child: AssistantHomePage()),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (index == 2) {
              // History tab
              _historyKey.currentState?.reloadPrompts();
            }
          });
        },
      ),
    );
  }
}
