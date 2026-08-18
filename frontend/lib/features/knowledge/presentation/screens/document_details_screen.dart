import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/indicators.dart';
import '../../../../core/widgets/layout.dart';
import '../../../../core/utils/responsive.dart';
import '../providers/knowledge_providers.dart';
import '../../domain/entities/document.dart';

import '../../../../core/widgets/saas_layout.dart';

class DocumentDetailsScreen extends ConsumerWidget {
  final String documentId;

  const DocumentDetailsScreen({
    super.key,
    required this.documentId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDoc = ref.watch(documentDetailsProvider(documentId));

    return SaaSLayout(
      title: 'Document Details',
      child: ResponsiveLayout(
        mobile: _buildContent(context, ref, asyncDoc),
        desktop: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: _buildContent(context, ref, asyncDoc),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, AsyncValue<AppDocument> asyncDoc) {
    return asyncDoc.when(
      data: (doc) {
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(documentDetailsProvider(documentId));
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoCard(
                  title: doc.title,
                  description: 'Source: ${doc.sourceType}',
                  icon: Icons.article,
                ),
                const SizedBox(height: AppSpacing.lg),
                const SectionHeader(title: 'Metadata'),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      children: [
                        _buildInfoRow(context, 'Status', _buildStatusBadge(context, doc.status)),
                        _buildInfoRow(context, 'Created', Text(DateFormat.yMMMd().add_jm().format(doc.createdAt.toLocal()))),
                        _buildInfoRow(context, 'Updated', Text(DateFormat.yMMMd().add_jm().format(doc.updatedAt.toLocal()))),
                        if (doc.metadata != null)
                          ...doc.metadata!.entries.map((e) => _buildInfoRow(context, e.key, Text(e.value.toString()))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                const SectionHeader(title: 'Raw Content'),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: SelectableText(
                      doc.rawContent,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const LoadingWidget(message: 'Loading document...'),
      error: (error, stack) => ErrorState(
        message: 'Failed to load document: $error',
        onRetry: () => ref.invalidate(documentDetailsProvider(documentId)),
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
      case 'EXTRACTED':
        type = StatusType.success;
        break;
      case 'FAILED':
        type = StatusType.error;
        break;
      case 'PENDING':
      case 'EXTRACTING':
        type = StatusType.warning;
        break;
      default:
        type = StatusType.info;
    }
    return StatusBadge(type: type, label: status);
  }
}
