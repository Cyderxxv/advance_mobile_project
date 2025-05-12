import 'package:flutter/material.dart';
import 'package:chatbot_ai/features/prompt/data/prompt_model.dart';

class PromptStatusBox extends StatelessWidget {
  final PromptGetModel prompt;
  const PromptStatusBox({Key? key, required this.prompt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (prompt.isFavorite == true)
            Icon(Icons.favorite, color: Colors.red, size: 18),
          if (prompt.isFavorite == true)
            SizedBox(width: 4),
          Icon(
            prompt.isPublic == true ? Icons.public : Icons.lock,
            color: prompt.isPublic == true ? Colors.green : Colors.grey,
            size: 18,
          ),
          SizedBox(width: 4),
          Text(
            prompt.isPublic == true ? 'Public' : 'Private',
            style: TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
