import 'package:flutter/material.dart';
import '../../../../core/network/api_error_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/project_provider.dart';
import '../../../../core/providers/permissions_provider.dart';
import '../../../../core/widgets/permission_tooltip.dart';
import '../../../../core/widgets/skeleton_loaders.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/inputs.dart';
import '../../../../core/widgets/saas_layout.dart';

class ProjectListScreen extends ConsumerWidget {
  const ProjectListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsState = ref.watch(projectListProvider);
    final permissions = ref.watch(permissionsProvider);

    return SaaSLayout(
      title: 'Projects',
      actions: [
        if (permissions.canCreateProject)
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateProjectDialog(context, ref),
          ),
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Projects', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                PermissionTooltip(
                  hasPermission: permissions.canCreateProject,
                  requiredRole: 'Organization Admin',
                  child: ElevatedButton.icon(
                    onPressed: permissions.canCreateProject ? () => _showCreateProjectDialog(context, ref) : null,
                    icon: const Icon(Icons.add),
                    label: const Text('Create Project'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            projectsState.when(
              data: (projects) {
                if (projects.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(64.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.folder_open_outlined, size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text('No Projects Found', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          const Text('No projects available in this workspace.', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 700;
                    if (isWide) {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 2.5,
                        ),
                        itemCount: projects.length,
                        itemBuilder: (context, index) {
                          final project = projects[index];
                          return Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.withAlpha(50)),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => context.push('/projects/${project.id}'),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.withAlpha(20),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Icon(Icons.folder, color: Colors.blue),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            project.name,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      project.description?.isNotEmpty == true ? project.description! : 'No description provided',
                                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: projects.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final project = projects[index];
                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.withAlpha(20),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.folder, color: Colors.blue),
                            ),
                            title: Text(project.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(
                              project.description?.isNotEmpty == true ? project.description! : 'No description',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => context.push('/projects/${project.id}'),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const SkeletonListLoader(count: 4, itemHeight: 90),
              error: (error, stack) => ErrorState(
                message: ApiErrorHandler.getMessage(error),
                onRetry: () => ref.refresh(projectListProvider),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateProjectDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        bool isLoading = false;
        
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Create Project'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextField(
                    labelText: 'Name',
                    controller: nameController,
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    labelText: 'Description (optional)',
                    controller: descController,
                    enabled: !isLoading,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                PrimaryButton(
                  text: 'Create',
                  isLoading: isLoading,
                  onPressed: () async {
                    if (nameController.text.isNotEmpty) {
                      setState(() => isLoading = true);
                      try {
                        await ref.read(projectListProvider.notifier).createProject(
                              nameController.text,
                              descController.text.isNotEmpty ? descController.text : null,
                            );
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      } finally {
                        if (context.mounted) {
                          setState(() => isLoading = false);
                        }
                      }
                    }
                  },
                ),
              ],
            );
          }
        );
      },
    );
  }
}
