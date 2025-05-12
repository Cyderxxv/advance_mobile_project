import 'package:chatbot_ai/features/prompt/data/prompt_model.dart';
import 'package:chatbot_ai/features/prompt/pages/widgets/widget_edit_prompt.dart';
import 'package:flutter/material.dart';

class WidgetPrompt extends StatelessWidget {
  const WidgetPrompt({super.key, this.data, required this.onFavoriteToggle});
  final PromptGetModel? data;
  final Function onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (data == null) return;
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditPromptPage(
              prompt: data!,
              onEditPrompt: () {
                // You may want to trigger a refresh in the parent after editing
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    data?.title ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => onFavoriteToggle(data?.id),
                  child: Icon(
                    data?.isFavorite == true
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color:
                        data?.isFavorite == true ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              data?.description ?? '',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
