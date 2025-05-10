import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../history/bloc/history_bloc.dart';

class ChatHistory {
  final String message;
  final DateTime timestamp;
  bool isDeleted;

  ChatHistory({
    required this.message,
    required this.timestamp,
    this.isDeleted = false,
  });
}

late HistoryBloc _historyBloc;

Widget _buildPublicPromptsSection() {
  return Container();
}

Widget _buildPrivatePromptsSection() {
  return Container();
}

Widget _buildBottomNavBar() {
  return SizedBox.shrink();
}

Widget _buildPromptItem(dynamic prompt) {
  return ListTile(title: Text(prompt['title'] ?? ''));
}

String _formatTime(DateTime time) {
  return DateFormat('HH:mm').format(time);
}
