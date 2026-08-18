import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/indicators.dart';
import '../../domain/entities/chat_models.dart';
import 'evidence_panel.dart';

class AiResponseCard extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback onRegenerate;
  final bool isLoading;

  const AiResponseCard({
    super.key,
    required this.message,
    required this.onRegenerate,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAssistant = message.role == ChatRole.assistant;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isAssistant ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isAssistant) _buildAvatar(theme, isAssistant),
          if (isAssistant) const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isAssistant 
                    ? theme.colorScheme.surface
                    : theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16).copyWith(
                  topLeft: isAssistant ? const Radius.circular(0) : null,
                  topRight: !isAssistant ? const Radius.circular(0) : null,
                ),
                border: isAssistant ? Border.all(color: theme.colorScheme.outlineVariant) : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.isError)
                    Row(
                      children: [
                        Icon(Icons.error_outline, color: theme.colorScheme.error),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            message.content,
                            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
                          ),
                        ),
                      ],
                    )
                  else if (isAssistant && message.content.isEmpty && isLoading)
                    const Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: AppSpacing.md),
                        Text('Thinking...'),
                      ],
                    )
                  else
                    MarkdownBody(
                      data: message.content,
                      selectable: true,
                    ),
                  if (isAssistant && message.metadata != null && !message.isError) ...[
                    const SizedBox(height: AppSpacing.md),
                    const Divider(),
                    if (message.metadata!.warnings.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.warning_amber_rounded, color: theme.colorScheme.onErrorContainer, size: 20),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                message.metadata!.warnings.join('\n'),
                                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onErrorContainer),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        StatusBadge(
                          label: 'Confidence: ${(message.metadata!.confidence * 100).toStringAsFixed(1)}%',
                          type: message.metadata!.confidence > 0.8 
                              ? StatusType.success 
                              : message.metadata!.confidence > 0.5 
                                  ? StatusType.warning 
                                  : StatusType.error,
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 20),
                          tooltip: 'Copy Answer',
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: message.content));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Copied to clipboard')),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh, size: 20),
                          tooltip: 'Regenerate',
                          onPressed: onRegenerate,
                        ),
                      ],
                    ),
                    if (message.metadata!.sources.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sm),
                      EvidencePanel(rawSources: message.metadata!.sources),
                    ]
                  ],
                ],
              ),
            ),
          ),
          if (!isAssistant) const SizedBox(width: AppSpacing.sm),
          if (!isAssistant) _buildAvatar(theme, isAssistant),
        ],
      ),
    );
  }

  Widget _buildAvatar(ThemeData theme, bool isAssistant) {
    return CircleAvatar(
      backgroundColor: isAssistant ? theme.colorScheme.primary : theme.colorScheme.secondary,
      child: Icon(
        isAssistant ? Icons.smart_toy : Icons.person,
        color: isAssistant ? theme.colorScheme.onPrimary : theme.colorScheme.onSecondary,
      ),
    );
  }
}
