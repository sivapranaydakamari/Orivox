import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';

enum PipelineStageStatus { pending, running, success, failed, notStarted }

class PipelineStage {
  final String title;
  final PipelineStageStatus status;

  PipelineStage({required this.title, required this.status});
}

class StatusTimeline extends StatelessWidget {
  final List<PipelineStage> stages;

  const StatusTimeline({
    super.key,
    required this.stages,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(stages.length, (index) {
        final stage = stages[index];
        final isLast = index == stages.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  _buildStatusIndicator(context, stage.status),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: _getLineColor(context, stage.status),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stage.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        _getStatusText(stage.status),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getStatusColor(context, stage.status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatusIndicator(BuildContext context, PipelineStageStatus status) {
    final color = _getStatusColor(context, status);

    if (status == PipelineStageStatus.running) {
      return Container(
        width: 24,
        height: 24,
        padding: const EdgeInsets.all(2),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }

    IconData icon;
    switch (status) {
      case PipelineStageStatus.success:
        icon = Icons.check_circle;
        break;
      case PipelineStageStatus.failed:
        icon = Icons.error;
        break;
      case PipelineStageStatus.notStarted:
        icon = Icons.circle_outlined;
        break;
      case PipelineStageStatus.pending:
      default:
        icon = Icons.radio_button_unchecked;
        break;
    }

    return Icon(icon, color: color, size: 24);
  }

  Color _getStatusColor(BuildContext context, PipelineStageStatus status) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case PipelineStageStatus.success:
        return Colors.green;
      case PipelineStageStatus.failed:
        return colorScheme.error;
      case PipelineStageStatus.running:
        return colorScheme.primary;
      case PipelineStageStatus.notStarted:
        return colorScheme.onSurfaceVariant.withAlpha(90);
      case PipelineStageStatus.pending:
        return colorScheme.onSurfaceVariant.withAlpha(150);
    }
  }

  Color _getLineColor(BuildContext context, PipelineStageStatus status) {
    if (status == PipelineStageStatus.success) {
      return Colors.green;
    }
    return Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(51);
  }

  String _getStatusText(PipelineStageStatus status) {
    switch (status) {
      case PipelineStageStatus.success:
        return 'SUCCESS';
      case PipelineStageStatus.failed:
        return 'FAILED';
      case PipelineStageStatus.running:
        return 'RUNNING';
      case PipelineStageStatus.notStarted:
        return 'NOT STARTED';
      case PipelineStageStatus.pending:
        return 'PENDING';
    }
  }
}
