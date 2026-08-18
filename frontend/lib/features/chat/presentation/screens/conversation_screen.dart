import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../providers/chat_providers.dart';
import '../widgets/ai_response_card.dart';
import '../widgets/suggested_questions.dart';
import '../../domain/entities/chat_models.dart';

class ConversationScreen extends ConsumerStatefulWidget {
  final String projectId;
  final String? conversationId;

  const ConversationScreen({
    super.key,
    required this.projectId,
    this.conversationId,
  });

  @override
  ConsumerState<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late String _currentProviderArg;

  @override
  void initState() {
    super.initState();
    _currentProviderArg = widget.conversationId != null 
        ? '${widget.projectId}:${widget.conversationId}'
        : widget.projectId;
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _submitQuestion(String question) async {
    if (question.trim().isEmpty) return;
    _controller.clear();

    final notifier = ref.read(activeChatProvider(_currentProviderArg).notifier);
    await notifier.askQuestion(question);
    
    // Once first message is sent on a "new" chat, we might want to update the URL
    // but the provider continues to track it.
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  @override
  Widget build(BuildContext context) {
    final asyncConv = ref.watch(activeChatProvider(_currentProviderArg));
    final isLoading = asyncConv.isLoading;
    final conv = asyncConv.value;

    return Scaffold(
      appBar: AppBar(
        title: Text(conv?.title ?? 'New Chat'),
      ),
      body: ResponsiveLayout(
        mobile: _buildBody(context, conv, isLoading),
        desktop: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: _buildBody(context, conv, isLoading),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, Conversation? conv, bool isLoading) {
    final messages = conv?.messages ?? [];

    return Column(
      children: [
        Expanded(
          child: messages.isEmpty
              ? SuggestedQuestionsWidget(onQuestionSelected: _submitQuestion)
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return AiResponseCard(
                      message: msg,
                      isLoading: isLoading && index == messages.length - 1,
                      onRegenerate: () {
                        // Resubmit the last user message
                        if (index > 0) {
                          final prevMsg = messages[index - 1];
                          if (prevMsg.role == ChatRole.user) {
                            _submitQuestion(prevMsg.content);
                          }
                        }
                      },
                    );
                  },
                ),
        ),
        _buildInputArea(context, isLoading),
      ],
    );
  }

  Widget _buildInputArea(BuildContext context, bool isLoading) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                enabled: !isLoading,
                maxLines: 5,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: 'Ask a question about the project...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (val) {
                  if (!isLoading) {
                    _submitQuestion(val);
                  }
                },
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            FloatingActionButton(
              onPressed: isLoading ? null : () => _submitQuestion(_controller.text),
              elevation: 0,
              child: isLoading 
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
