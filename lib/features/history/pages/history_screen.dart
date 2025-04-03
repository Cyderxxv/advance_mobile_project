import 'package:chatbot_ai/features/chat/pages/chat_home.dart';
import 'package:chatbot_ai/features/profiles/pages/profile.dart';
import 'package:flutter/material.dart';
import '../data/history.dart';
import '../../chat/pages/chat_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ChatHistory> _todayHistory = [];
  List<ChatHistory> _yesterdayHistory = [];
  bool _isSearching = false;
  List<ChatHistory> _filteredHistory = [];

  @override
  void initState() {
    super.initState();
    // TEST LOAD
    _loadChatHistory();

    _searchController.addListener(() {
      _filterHistory(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadChatHistory() {
    _todayHistory = [
      ChatHistory(
        message: "How can I improve my productivity?",
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      ChatHistory(
        message: "What are the best practices for Flutter development?",
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      ChatHistory(
        message: "Tell me about artificial intelligence",
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      ),
    ];

    _yesterdayHistory = [
      ChatHistory(
        message: "Explain machine learning concepts",
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      ChatHistory(
        message: "How to implement authentication in Flutter?",
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
      ),
      ChatHistory(
        message: "What are the trending technologies in 2023?",
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
      ),
    ];
  }

  void _filterHistory(String query) {
    setState(() {
      if (query.isEmpty) {
        _isSearching = false;
      } else {
        _isSearching = true;
        _filteredHistory = [
          ..._todayHistory,
          ..._yesterdayHistory,
        ]
            .where((history) =>
                history.message.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Text(
                    'History',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      _showDeleteConfirmation(context);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search in history',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isSearching
                  ? _buildSearchResults()
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildSection('Today', _todayHistory),
                        const SizedBox(height: 16),
                        _buildSection('Yesterday', _yesterdayHistory),
                      ],
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildSearchResults() {
    if (_filteredHistory.isEmpty) {
      return const Center(
        child: Text(
          'No results found',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredHistory.length,
      itemBuilder: (context, index) =>
          _buildHistoryItem(_filteredHistory[index]),
    );
  }

  Widget _buildSection(String title, List<ChatHistory> history) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        ...history.map((chat) => _buildHistoryItem(chat)),
      ],
    );
  }

  Widget _buildHistoryItem(ChatHistory chat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat.message,
                  style: TextStyle(
                    fontSize: 16,
                    color: chat.isDeleted ? Colors.grey : Colors.black87,
                    decoration:
                        chat.isDeleted ? TextDecoration.lineThrough : null,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(chat.timestamp),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (!chat.isDeleted)
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 16),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChatScreen()),
                );
              },
            ),
          if (chat.isDeleted)
            IconButton(
              icon: const Icon(Icons.restore, size: 16),
              onPressed: () {
                setState(() {
                  chat.isDeleted = false;
                });
              },
            ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
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

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete History'),
          content:
              const Text('Are you sure you want to delete all chat history?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                setState(() {
                  for (var chat in _todayHistory) {
                    chat.isDeleted = true;
                  }
                  for (var chat in _yesterdayHistory) {
                    chat.isDeleted = true;
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
