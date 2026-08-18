import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';

class SuggestedQuestionsWidget extends StatelessWidget {
  final ValueChanged<String> onQuestionSelected;

  const SuggestedQuestionsWidget({
    super.key,
    required this.onQuestionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final questions = [
      'Explain the authentication flow.',
      'How does repository synchronization work?',
      'What are the technical decisions for this project?',
      'Summarize the ingestion pipeline.',
    ];

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
            const SizedBox(height: AppSpacing.md),
            Text(
              'How can I help you today?',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            ...questions.map((q) => _buildQuestionCard(context, q)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(BuildContext context, String question) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: () => onQuestionSelected(question),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              const Icon(Icons.lightbulb_outline, size: 20),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  question,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
