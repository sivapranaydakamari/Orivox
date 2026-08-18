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
import '../widgets/document_card.dart';
import '../../../repository/presentation/widgets/postman_import_dialog.dart';

class DocumentListScreen extends ConsumerWidget {
  final String projectId;

  const DocumentListScreen({
    super.key,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDocs = ref.watch(filteredDocumentListProvider(projectId));
    final filter = ref.watch(documentFilterProvider);

    return SaaSLayout(
      title: 'Documents',
      child: ResponsiveLayout(
        mobile: _buildContent(context, ref, asyncDocs, filter),
        desktop: Align(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            width: double.infinity,
            height: double.infinity,
            child: _buildContent(context, ref, asyncDocs, filter),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    AsyncValue asyncDocs,
    DocumentFilter filter,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 600;
              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SearchField(
                      hintText: 'Search documents...',
                      onChanged: (value) => ref.read(documentFilterProvider.notifier).updateQuery(value),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ElevatedButton.icon(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => PostmanImportDialog(projectId: projectId),
                      ),
                      icon: const Icon(Icons.api),
                      label: const Text('Import Postman'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                        foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ElevatedButton.icon(
                      onPressed: () => _showCreateDocumentDialog(context, ref),
                      icon: const Icon(Icons.add),
                      label: const Text('Create Document'),
                    ),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(
                    child: SearchField(
                      hintText: 'Search documents...',
                      onChanged: (value) => ref.read(documentFilterProvider.notifier).updateQuery(value),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  ElevatedButton.icon(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => PostmanImportDialog(projectId: projectId),
                    ),
                    icon: const Icon(Icons.api),
                    label: const Text('Import Postman'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                      foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  ElevatedButton.icon(
                    onPressed: () => _showCreateDocumentDialog(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Create Document'),
                  ),
                ],
              );
            },
          ),
        ),
        Expanded(
          child: asyncDocs.when(
            data: (docs) {
              if (docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const EmptyState(
                        title: 'No Documents',
                        message: 'No documents found for this project.',
                        icon: Icons.search_off,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ElevatedButton.icon(
                        onPressed: () => _showCreateDocumentDialog(context, ref),
                        icon: const Icon(Icons.add),
                        label: const Text('Create Custom Document'),
                      ),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(rawDocumentListProvider(projectId));
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    return DocumentCard(
                      document: doc,
                      onTap: () => context.push('/documents/${doc.id}'),
                    );
                  },
                ),
              );
            },
            loading: () => const SkeletonListLoader(count: 4, itemHeight: 90),
            error: (error, stack) => ErrorState(
              message: 'Failed to load documents: $error',
              onRetry: () => ref.invalidate(rawDocumentListProvider(projectId)),
            ),
          ),
        ),
      ],
    );
  }

  void _showCreateDocumentDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Custom Document'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Document Title', hintText: 'e.g. System Architecture Specification'),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: const InputDecoration(labelText: 'Content / Specs (Markdown)', hintText: 'Paste technical documentation...'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.trim().isEmpty) return;
              Navigator.pop(context);
              await ref.read(createDocumentActionProvider.notifier).createDocument(
                titleController.text.trim(),
                contentController.text.trim(),
                projectId,
              );
            },
            child: const Text('Create & Ingest'),
          ),
        ],
      ),
    );
  }
}
