import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/knowledge_stats.dart';
import 'package:intl/intl.dart';

class KnowledgeStatsGrid extends StatelessWidget {
  final KnowledgeStats stats;

  const KnowledgeStatsGrid({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: Column(
        children: _buildCards(context),
      ),
      desktop: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 2.5,
        children: _buildCards(context),
      ),
    );
  }

  List<Widget> _buildCards(BuildContext context) {
    final lastIndexedStr = stats.lastIndexed != null 
        ? DateFormat.yMMMd().add_jm().format(stats.lastIndexed!.toLocal()) 
        : 'Never';

    return [
      _buildStatCard(context, 'Total Documents', stats.totalDocuments.toString(), Icons.article),
      _buildStatCard(context, 'Knowledge Records', stats.totalRecords.toString(), Icons.psychology),
      _buildStatCard(context, 'Repositories', stats.repositoryCount.toString(), Icons.source),
      _buildStatCard(context, 'Processing', stats.processingCount.toString(), Icons.sync),
      _buildStatCard(context, 'Failed Records', stats.failedCount.toString(), Icons.error_outline, isError: stats.failedCount > 0),
      _buildStatCard(context, 'Last Indexed', lastIndexedStr, Icons.access_time),
    ];
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, {bool isError = false}) {
    final theme = Theme.of(context);
    final color = isError ? theme.colorScheme.error : theme.colorScheme.primary;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: color.withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isError ? color : null,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
