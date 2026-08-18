import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/network/api_error_handler.dart';
import '../../../../core/providers/permissions_provider.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/inputs.dart';
import '../../../../core/widgets/saas_layout.dart';
import '../../../../core/widgets/permission_tooltip.dart';
import '../../../../core/widgets/skeleton_loaders.dart';
import '../../../repository/presentation/providers/repository_providers.dart';
import '../../../repository/presentation/widgets/repository_card.dart';
import '../../../knowledge/presentation/providers/knowledge_providers.dart';
import '../../../knowledge/presentation/widgets/document_card.dart';
import '../../../knowledge/presentation/widgets/knowledge_record_card.dart';
import '../providers/project_provider.dart';

class ProjectDetailsScreen extends ConsumerWidget {
  final String id;
  const ProjectDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsState = ref.watch(projectListProvider);
    final permissions = ref.watch(permissionsProvider);

    return projectsState.when(
      data: (projects) {
        final project = projects.firstWhere(
          (p) => p.id == id,
          orElse: () => throw Exception('Project not found'),
        );

        final nameController = TextEditingController(text: project.name);
        final descController = TextEditingController(text: project.description);

        return DefaultTabController(
          length: 5,
          child: SaaSLayout(
            title: project.name,
            actions: [
              if (permissions.canDeleteProject(id))
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: Theme.of(context).colorScheme.error,
                  tooltip: 'Delete Project',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmationDialog(
                        title: 'Delete Project',
                        message: 'Are you sure you want to delete ${project.name}? This action cannot be undone.',
                        confirmText: 'Delete',
                        onConfirm: () {
                          Navigator.pop(context);
                          ref.read(projectListProvider.notifier).deleteProject(id);
                          context.go('/projects');
                        },
                        onCancel: () => Navigator.pop(context),
                      ),
                    );
                  },
                ),
            ],
            child: Column(
              children: [
                Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    tabs: const [
                      Tab(icon: Icon(Icons.dashboard_outlined, size: 18), text: 'Overview'),
                      Tab(icon: Icon(Icons.source_outlined, size: 18), text: 'Repositories'),
                      Tab(icon: Icon(Icons.find_in_page_outlined, size: 18), text: 'Documents'),
                      Tab(icon: Icon(Icons.psychology_outlined, size: 18), text: 'Knowledge Base'),
                      Tab(icon: Icon(Icons.settings_outlined, size: 18), text: 'Settings'),
                    ],
                  ),
                ),
                Expanded(
                  child: Builder(
                    builder: (tabContext) {
                      return TabBarView(
                        children: [
                          // Tab 1: Overview
                          _buildOverviewTab(tabContext, ref, project, permissions),
                          // Tab 2: Repositories
                          _buildRepositoriesTab(tabContext, ref, id, permissions),
                          // Tab 3: Documents
                          _buildDocumentsTab(tabContext, ref, id),
                          // Tab 4: Knowledge
                          _buildKnowledgeTab(tabContext, ref, id),
                          // Tab 5: Settings
                          _buildSettingsTab(tabContext, ref, project, nameController, descController, permissions),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SaaSLayout(
        title: 'Project Workspace',
        child: Center(child: SkeletonListLoader(count: 3, itemHeight: 120)),
      ),
      error: (error, stack) => SaaSLayout(
        title: 'Project Error',
        child: ErrorState(message: ApiErrorHandler.getMessage(error)),
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context, WidgetRef ref, dynamic project, Permissions permissions) {
    final asyncRepos = ref.watch(repositoryListProvider(id));
    final asyncDocs = ref.watch(filteredDocumentListProvider(id));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(project.name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    project.description ?? 'No description provided.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      children: [
                        const Icon(Icons.source_outlined, size: 32, color: Colors.blue),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '${asyncRepos.valueOrNull?.length ?? 0}',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Text('Repositories', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      children: [
                        const Icon(Icons.article_outlined, size: 32, color: Colors.green),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '${asyncDocs.valueOrNull?.length ?? 0}',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Text('Documents', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRepositoriesTab(BuildContext context, WidgetRef ref, String projectId, Permissions permissions) {
    final asyncRepos = ref.watch(repositoryListProvider(projectId));

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: [
              Text('Connected Repositories', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              PermissionTooltip(
                hasPermission: permissions.canCreateRepository(projectId),
                requiredRole: 'Project Manager',
                child: SizedBox(
                  width: 200,
                  child: PrimaryButton(
                    text: 'Connect Repository',
                    icon: Icons.add,
                    onPressed: permissions.canCreateRepository(projectId) ? () => context.push('/projects/$projectId/repositories/new') : null,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: asyncRepos.when(
              data: (repos) {
                if (repos.isEmpty) {
                  return const EmptyState(
                    title: 'No Connected Repositories',
                    message: 'Connect a GitHub repository to start importing engineering knowledge into this project.',
                    icon: Icons.source_outlined,
                  );
                }
                return ListView.builder(
                  itemCount: repos.length,
                  itemBuilder: (context, index) {
                    final repo = repos[index];
                    return RepositoryCard(
                      repository: repo,
                      onTap: () => context.push('/repositories/${repo.id}'),
                    );
                  },
                );
              },
              loading: () => const SkeletonListLoader(count: 3, itemHeight: 90),
              error: (err, st) => ErrorState(message: ApiErrorHandler.getMessage(err)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsTab(BuildContext context, WidgetRef ref, String projectId) {
    final asyncDocs = ref.watch(filteredDocumentListProvider(projectId));

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: asyncDocs.when(
        data: (docs) {
          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const EmptyState(
                    title: 'No Documents Found',
                    message: 'Documents are extracted automatically when a connected GitHub repository is synchronized.',
                    icon: Icons.find_in_page_outlined,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: 240,
                    child: PrimaryButton(
                      text: 'Connect & Sync Repository',
                      icon: Icons.sync,
                      onPressed: () => DefaultTabController.of(context).animateTo(1), // Switch to Repositories tab
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              return DocumentCard(
                document: doc,
                onTap: () => context.push('/documents/${doc.id}'),
              );
            },
          );
        },
        loading: () => const SkeletonListLoader(count: 3, itemHeight: 90),
        error: (err, st) => ErrorState(message: ApiErrorHandler.getMessage(err)),
      ),
    );
  }

  Widget _buildKnowledgeTab(BuildContext context, WidgetRef ref, String projectId) {
    final asyncRecords = ref.watch(filteredKnowledgeRecordListProvider(projectId));

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: asyncRecords.when(
        data: (records) {
          if (records.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const EmptyState(
                    title: 'No Knowledge Records',
                    message: 'Knowledge records are generated automatically after code ingestion and RAG vector embedding.',
                    icon: Icons.psychology_outlined,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: 240,
                    child: PrimaryButton(
                      text: 'Connect & Ingest Code',
                      icon: Icons.hub,
                      onPressed: () => DefaultTabController.of(context).animateTo(1), // Switch to Repositories tab
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return KnowledgeRecordCard(
                record: record,
                onTap: () => context.push('/knowledge/records/${record.id}'),
              );
            },
          );
        },
        loading: () => const SkeletonListLoader(count: 3, itemHeight: 90),
        error: (err, st) => ErrorState(message: ApiErrorHandler.getMessage(err)),
      ),
    );
  }

  Widget _buildSettingsTab(
    BuildContext context,
    WidgetRef ref,
    dynamic project,
    TextEditingController nameController,
    TextEditingController descController,
    Permissions permissions,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Project Settings', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                labelText: 'Project Name',
                controller: nameController,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                labelText: 'Description',
                controller: descController,
              ),
              const SizedBox(height: AppSpacing.xl),
              PermissionTooltip(
                hasPermission: permissions.canEditProject(id),
                requiredRole: 'Project Admin',
                child: PrimaryButton(
                  text: 'Save Project Changes',
                  onPressed: permissions.canEditProject(id)
                      ? () async {
                          await ref.read(projectListProvider.notifier).updateProject(
                                id,
                                nameController.text,
                                descController.text.isNotEmpty ? descController.text : null,
                              );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Project updated successfully!')),
                            );
                          }
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

