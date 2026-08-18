import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/indicators.dart';
import '../../../../core/widgets/layout.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/utils/responsive.dart';
import '../providers/knowledge_providers.dart';
import '../../domain/entities/knowledge_record.dart';

import '../../../../core/widgets/saas_layout.dart';

class KnowledgeRecordDetailsScreen extends ConsumerWidget {
  final String recordId;

  const KnowledgeRecordDetailsScreen({
    super.key,
    required this.recordId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncRecord = ref.watch(knowledgeRecordDetailsProvider(recordId));

    return SaaSLayout(
      title: 'Knowledge Record Details',
      child: ResponsiveLayout(
        mobile: _buildContent(context, ref, asyncRecord),
        desktop: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: _buildContent(context, ref, asyncRecord),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, AsyncValue<KnowledgeRecord> asyncRecord) {
    return asyncRecord.when(
      data: (record) {
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(knowledgeRecordDetailsProvider(recordId));
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoCard(
                  title: record.title,
                  description: 'Source Type: ${record.sourceType}',
                  icon: Icons.psychology,
                ),
                const SizedBox(height: AppSpacing.lg),
                
                const SectionHeader(title: 'Overview'),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Summary', style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: AppSpacing.sm),
                        Text(record.summary, style: Theme.of(context).textTheme.bodyMedium),
                        const Divider(height: AppSpacing.xl),
                        
                        _buildInfoRow(context, 'Confidence', Text(record.confidence?.toString() ?? 'N/A')),
                        _buildInfoRow(context, 'Status', _buildStatusBadge(context, record.embeddingStatus)),
                        if (record.documentId != null) ...[
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            children: [
                              SizedBox(
                                width: 120,
                                child: Text('Source', style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                )),
                              ),
                              SecondaryButton(
                                text: 'View Document',
                                onPressed: () => context.push('/documents/${record.documentId}'),
                              ),
                            ],
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                if (record.businessContext != null || record.engineeringReasoning != null) ...[
                  const SectionHeader(title: 'Context & Reasoning'),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (record.businessContext != null) ...[
                            Text('Business Context', style: Theme.of(context).textTheme.titleSmall),
                            const SizedBox(height: AppSpacing.xs),
                            Text(record.businessContext!),
                            const SizedBox(height: AppSpacing.md),
                          ],
                          if (record.engineeringReasoning != null) ...[
                            Text('Engineering Reasoning', style: Theme.of(context).textTheme.titleSmall),
                            const SizedBox(height: AppSpacing.xs),
                            Text(record.engineeringReasoning!),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],

                if (record.technicalDecisions.isNotEmpty || record.risks.isNotEmpty || record.breakingChanges.isNotEmpty) ...[
                  const SectionHeader(title: 'Technical Insights'),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildListSection(context, 'Technical Decisions', record.technicalDecisions),
                          _buildListSection(context, 'Risks', record.risks),
                          _buildListSection(context, 'Breaking Changes', record.breakingChanges),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],

                if (record.dependencies.isNotEmpty || record.affectedComponents.isNotEmpty || record.referencedApis.isNotEmpty) ...[
                  const SectionHeader(title: 'Relationships'),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildListSection(context, 'Dependencies', record.dependencies),
                          _buildListSection(context, 'Affected Components', record.affectedComponents),
                          _buildListSection(context, 'Referenced APIs', record.referencedApis),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
      loading: () => const LoadingWidget(message: 'Loading knowledge record...'),
      error: (error, stack) => ErrorState(
        message: 'Failed to load record: $error',
        onRetry: () => ref.invalidate(knowledgeRecordDetailsProvider(recordId)),
      ),
    );
  }

  Widget _buildListSection(BuildContext context, String title, List<String> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.xs),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• '),
                Expanded(child: Text(item)),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, Widget value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: value,
            ),
          ),
        ],
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
