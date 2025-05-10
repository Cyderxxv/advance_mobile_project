import 'package:flutter/material.dart';

class CreateAssistantPage extends StatelessWidget {
  const CreateAssistantPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final instructionsController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create Assistant',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.smart_toy, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Assistant Details',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Assistant Name',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter assistant name',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Description',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Enter description',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Instructions',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: instructionsController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Enter instructions',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 200),
                      tween: Tween(begin: 1.0, end: 1.0),
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 2,
                            ),
                            onPressed: () {
                              // TODO: Implement create assistant logic
                            },
                            child: const Text(
                              'Create',
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: 0.2),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
