import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/history_bloc.dart';
import '../bloc/history_event.dart';
import '../bloc/history_state.dart';
import '../../chat/pages/chat_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with AutomaticKeepAliveClientMixin {
  late HistoryBloc _historyBloc;

  @override
  void initState() {
    super.initState();
    _historyBloc = HistoryBloc();
    _historyBloc.add(EventGetConversations(assistantModel: 'dify'));
  }

  @override
  void dispose() {
    _historyBloc.close();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (_) => _historyBloc,
      child: Scaffold(
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
                      'History',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 22),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.07),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.tune, size: 20),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: BlocBuilder<HistoryBloc, HistoryState>(
                    builder: (context, state) {
                      if (state is StateGetConversations && state.isLoading == true) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is StateGetConversations && state.items != null) {
                        final items = state.items!;
                        if (items.isEmpty) {
                          return const Center(child: Text('No conversations found'));
                        }
                        return ListView.separated(
                          itemCount: items.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            final title = item['title'] ?? 'No Title';
                            final createdAt = item['createdAt'] != null
                                ? (item['createdAt'] is int
                                    ? DateTime.fromMillisecondsSinceEpoch(item['createdAt'] * 1000)
                                    : DateTime.tryParse(item['createdAt'].toString()))
                                : null;
                            return _historyItem(
                              title,
                              subtitle: createdAt != null
                                  ? DateFormat('yyyy-MM-dd HH:mm').format(createdAt)
                                  : '',
                              onTap: () => _openChatScreen(context, item['id'].toString()),
                            );
                          },
                        );
                      }
                      if (state is StateGetConversations && state.isSuccess == false) {
                        return Center(child: Text(state.message ?? 'Error loading history'));
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        
      ),
    );
  }

  Widget _historyItem(String text, {String? subtitle, VoidCallback? onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          text,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
        subtitle: subtitle != null && subtitle.isNotEmpty ? Text(subtitle) : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        onTap: onTap,
      ),
    );
  }

  void _openChatScreen(BuildContext context, String conversationId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(conversationId: conversationId),
      ),
    );
  }

  void _showConversationMessages(BuildContext context, String conversationId, String title) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return BlocProvider.value(
          value: _historyBloc,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              children: [
                AppBar(
                  title: Text(title),
                  automaticallyImplyLeading: false,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Expanded(
                  child: BlocBuilder<HistoryBloc, HistoryState>(
                    builder: (context, state) {
                      if (state is StateGetConversationsHistory && state.isLoading == true) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is StateGetConversationsHistory && state.messages != null) {
                        final messages = state.messages!;
                        if (messages.isEmpty) {
                          return const Center(child: Text('No messages in this conversation'));
                        }
                        return ListView.separated(
                          itemCount: messages.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final msg = messages[index];
                            final query = msg.query ?? '';
                            final answer = msg.answer ?? '';
                            return ListTile(
                              title: Text(query),
                              subtitle: Text(answer),
                            );
                          },
                        );
                      }
                      if (state is StateGetConversationsHistory && state.isSuccess == false) {
                        return Center(child: Text(state.message ?? 'Error loading messages'));
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    _historyBloc.add(EventGetConversationsHistory(
      conversationId: conversationId,
      assistantModel: 'dify',
    ));
  }
}