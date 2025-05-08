import 'package:chatbot_ai/features/chat/pages/chat_home.dart';
import 'package:flutter/material.dart';
import '../../chat/pages/chat_screen.dart';
import '../../prompt/pages/prompt_screen.dart';
import '../../history/pages/history_screen.dart';
import '../../profiles/pages/profile.dart';
import 'bottom_nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    KeepAlive(keepAlive: true, child: ChatHomeScreen(),),
    KeepAlive(keepAlive: true, child: PromptScreen(),),
    KeepAlive(keepAlive: true, child: HistoryScreen(),),
    KeepAlive(keepAlive: true, child: ProfileScreen(),),
  ];

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
          KeepAlive(keepAlive: true, child: ChatHomeScreen(),),
          KeepAlive(keepAlive: true, child: PromptScreen(),),
          KeepAlive(keepAlive: true, child: HistoryScreen(),),
          KeepAlive(keepAlive: true, child: ProfileScreen(),),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
