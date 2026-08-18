import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/job.dart';

class JobDetailsCard extends StatelessWidget {
  final JobStatus job;

  const JobDetailsCard({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Job Details',
                  style: theme.textTheme.titleMedium,
                ),
                _buildJobStatusBadge(context, job.status),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (job.status == 'active' || job.status == 'pending') ...[
              LinearProgressIndicator(
                value: job.progress > 0 ? job.progress / 100 : null,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Progress: ${job.progress.toStringAsFixed(1)}%',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            _buildInfoRow(context, 'Type', job.type),
            if (job.queuedAt != null)
              _buildInfoRow(context, 'Queued', job.queuedAt!.toLocal().toString()),
            if (job.startedAt != null)
              _buildInfoRow(context, 'Started', job.startedAt!.toLocal().toString()),
            if (job.completedAt != null)
              _buildInfoRow(context, 'Completed', job.completedAt!.toLocal().toString()),
            if (job.duration != null)
              _buildInfoRow(context, 'Duration', '${job.duration}ms'),
            _buildInfoRow(context, 'Retries', job.retries.toString()),
            if (job.error != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                color: theme.colorScheme.errorContainer,
                child: Text(
                  'Error: ${job.error}',
                  style: TextStyle(color: theme.colorScheme.onErrorContainer),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobStatusBadge(BuildContext context, String status) {
    Color color;
    switch (status) {
      case 'completed':
        color = Colors.green;
        break;
      case 'failed':
        color = Theme.of(context).colorScheme.error;
        break;
      case 'active':
        color = Theme.of(context).colorScheme.primary;
        break;
      case 'pending':
      case 'delayed':
      default:
        color = Theme.of(context).colorScheme.onSurfaceVariant;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(26), // 0.1 opacity
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(128)), // 0.5 opacity
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
