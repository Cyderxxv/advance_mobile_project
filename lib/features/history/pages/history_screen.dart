import 'package:chatbot_ai/features/chat/pages/chat_home.dart';
import 'package:chatbot_ai/features/profiles/pages/profile.dart';
import 'package:flutter/material.dart';
import '../data/history.dart';
import '../../chat/pages/chat_screen.dart';
import 'package:dio/dio.dart';
import 'package:chatbot_ai/cores/network/dio_network.dart';
import 'package:chatbot_ai/cores/constants/app_constants.dart';
import 'package:chatbot_ai/cores/store/store.dart';

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
  List<dynamic> _publicPrompts = [];

  @override
  void initState() {
    super.initState();
    // TEST LOAD
    _loadChatHistory();
    _fetchPublicPrompts(); // Fetch public prompts

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
    _todayHistory = [];
    _yesterdayHistory = [];
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

  Future<void> _fetchPublicPrompts() async {
    try {
      DioNetwork.instant.init(AppConstants.jarvisBaseUrl, isAuth: true);
      final headers = {
        'x-jarvis-guid': '361331f8-fc9b-4dfe-a3f7-6d9a1e8b289b',
        'Authorization': 'Bearer ${StoreData.instant.token}',
      };

      final response = await DioNetwork.instant.dio.get(
        '/prompts',
        queryParameters: {
          'query': _searchController.text,
          'offset': 0,
          'limit': 20,
          'isFavorite': false,
          'isPublic': true,
        },
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        setState(() {
          _publicPrompts = response.data['items'];
          _isSearching = true; // Indicate that a search is active
        });
      }
    } catch (e) {
      print('Error fetching public prompts: $e');
    }
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
                            _fetchPublicPrompts(); // Refresh prompts when cleared
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
                onSubmitted: (value) {
                  _fetchPublicPrompts(); // Fetch prompts on enter
                },
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
                        const SizedBox(height: 16),
                        _buildPublicPromptsSection(), // Display public prompts
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
    if (_publicPrompts.isEmpty) {
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
      itemCount: _publicPrompts.length,
      itemBuilder: (context, index) => _buildPromptItem(_publicPrompts[index]),
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

  Widget _buildPublicPromptsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Public Prompts',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        ..._publicPrompts.map((prompt) => _buildPromptItem(prompt)),
      ],
    );
  }

  Widget _buildPromptItem(dynamic prompt) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            prompt['title'] ?? 'No Title',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Created on: ${prompt['createdAt'] ?? 'Unknown Date'}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Category: ${prompt['category'] ?? 'Unknown'}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'By: ${prompt['userName'] ?? 'Unknown'}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
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
