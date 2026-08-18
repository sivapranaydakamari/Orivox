import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/layout.dart';
import '../../../../core/widgets/saas_layout.dart';
import '../../../../core/widgets/skeleton_loaders.dart';
import '../providers/knowledge_providers.dart';
import '../widgets/knowledge_stats_grid.dart';
import '../../../../core/utils/responsive.dart';

class KnowledgeDashboardScreen extends ConsumerWidget {
  final String projectId;

  const KnowledgeDashboardScreen({
    super.key,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(knowledgeDashboardStatsProvider(projectId));

    return SaaSLayout(
      title: 'Knowledge Explorer',
      child: ResponsiveLayout(
        mobile: _buildContent(context, ref, statsAsync),
        desktop: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: _buildContent(context, ref, statsAsync),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, AsyncValue statsAsync) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(rawDocumentListProvider(projectId));
        ref.invalidate(rawKnowledgeRecordListProvider(projectId));
      },
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const SectionHeader(title: 'Overview'),
          statsAsync.when(
            data: (stats) => KnowledgeStatsGrid(stats: stats),
            loading: () => const SkeletonListLoader(count: 2, itemHeight: 120),
            error: (error, stack) => ErrorState(
              message: 'Failed to load statistics',
              onRetry: () {
                ref.invalidate(rawDocumentListProvider(projectId));
                ref.invalidate(rawKnowledgeRecordListProvider(projectId));
              },
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'Explore'),
          Row(
            children: [
              Expanded(
                child: _buildNavigationCard(
                  context,
                  title: 'Documents',
                  description: 'View and search ingested documents',
                  icon: Icons.article,
                  onTap: () => context.push('/documents?projectId=$projectId'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _buildNavigationCard(
                  context,
                  title: 'Knowledge Records',
                  description: 'Explore extracted structured knowledge',
                  icon: Icons.psychology,
                  onTap: () => context.push('/knowledge/records?projectId=$projectId'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 40, color: theme.colorScheme.primary),
              const SizedBox(height: AppSpacing.md),
              Text(title, style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
