import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/inputs.dart';
import '../../../../core/widgets/saas_layout.dart';
import '../../../../core/widgets/skeleton_loaders.dart';
import '../../../../core/utils/responsive.dart';
import '../providers/knowledge_providers.dart';
import '../widgets/knowledge_record_card.dart';

class KnowledgeRecordListScreen extends ConsumerWidget {
  final String projectId;

  const KnowledgeRecordListScreen({
    super.key,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncRecords = ref.watch(filteredKnowledgeRecordListProvider(projectId));
    final filter = ref.watch(knowledgeFilterProvider);

    return SaaSLayout(
      title: 'Knowledge Records',
      child: ResponsiveLayout(
        mobile: _buildContent(context, ref, asyncRecords, filter),
        desktop: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: _buildContent(context, ref, asyncRecords, filter),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    AsyncValue asyncRecords,
    KnowledgeFilter filter,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: SearchField(
            hintText: 'Search records...',
            onChanged: (value) => ref.read(knowledgeFilterProvider.notifier).updateQuery(value),
          ),
        ),
        // Filter Chips could go here
        Expanded(
          child: asyncRecords.when(
            data: (records) {
              if (records.isEmpty) {
                return const EmptyState(
                  title: 'No Records',
                  message: 'No knowledge records found matching the criteria.',
                  icon: Icons.psychology,
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(rawKnowledgeRecordListProvider(projectId));
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final record = records[index];
                    return KnowledgeRecordCard(
                      record: record,
                      onTap: () => context.push('/knowledge/records/${record.id}'),
                    );
                  },
                ),
              );
            },
            loading: () => const SkeletonListLoader(count: 4, itemHeight: 90),
            error: (error, stack) => ErrorState(
              message: 'Failed to load records: $error',
              onRetry: () => ref.invalidate(rawKnowledgeRecordListProvider(projectId)),
            ),
          ),
        ),
      ],
    );
  }
}
