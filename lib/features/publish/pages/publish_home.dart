import 'package:flutter/material.dart';
import 'package:chatbot_ai/features/publish/domain/publish_repo.dart';

class PublishTelegramPage extends StatefulWidget {
  final String assistantId;
  const PublishTelegramPage({super.key, required this.assistantId});

  @override
  State<PublishTelegramPage> createState() => _PublishTelegramPageState();
}

class _PublishTelegramPageState extends State<PublishTelegramPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _botTokenController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _botTokenController.dispose();
    super.dispose();
  }

  void _handlePublish() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final response = await PublishRepo.instant.publishTelegram(
        botToken: _botTokenController.text.trim(),
        assistantId: widget.assistantId,
      );
      setState(() => _isLoading = false);
      if (response != null && response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Telegram bot published!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${response?.data?['message'] ?? 'Unknown error'}')),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Publish Telegram Bot', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text(
                'Bot Token',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _botTokenController,
                decoration: InputDecoration(
                  hintText: 'Enter your bot token',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: const TextStyle(color: Colors.black),
                validator: (value) => value == null || value.isEmpty ? 'Bot token required' : null,
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handlePublish,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Publish Bot', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
