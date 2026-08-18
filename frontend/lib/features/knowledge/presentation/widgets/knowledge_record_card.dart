import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/indicators.dart';
import '../../domain/entities/knowledge_record.dart';

class KnowledgeRecordCard extends StatelessWidget {
  final KnowledgeRecord record;
  final VoidCallback onTap;

  const KnowledgeRecordCard({
    super.key,
    required this.record,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      record.title,
                      style: theme.textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _buildStatusBadge(context, record.embeddingStatus),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                record.summary,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: [
                  _buildChip(context, record.sourceType),
                  if (record.confidence != null)
                    _buildChip(context, 'Confidence: ${record.confidence}'),
                  Text(
                    DateFormat.yMMMd().format(record.updatedAt.toLocal()),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, String status) {
    StatusType type;
    switch (status) {
      case 'EMBEDDED':
      case 'COMPLETED':
        type = StatusType.success;
        break;
      case 'FAILED':
        type = StatusType.error;
        break;
      case 'PENDING':
      case 'EMBEDDING':
      case 'PROCESSING':
        type = StatusType.warning;
        break;
      default:
        type = StatusType.info;
    }
    return StatusBadge(type: type, label: status);
  }
}
