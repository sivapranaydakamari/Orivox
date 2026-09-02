import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/active_org_provider.dart';
import '../../../../core/providers/permissions_provider.dart';
import '../../../../core/widgets/saas_layout.dart';
import '../../../../core/widgets/skeleton_loaders.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../project/presentation/providers/project_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkActiveOrg();
    });
  }

  void _checkActiveOrg() {
    final activeOrg = ref.read(activeOrgProvider);
    final authState = ref.read(authNotifierProvider);
    
    authState.maybeWhen(
      authenticated: (user) {
        if (activeOrg == null && user.memberships.isNotEmpty) {
          // If 1 membership or more, and none selected, auto-select the first one.
          // In the case of > 1, they shouldn't reach here without it set, but just in case.
          ref.read(activeOrgProvider.notifier).setActiveOrg(user.memberships.first.organizationId);
        } else if (activeOrg == null && user.memberships.isEmpty) {
          context.go('/organizations');
        }
      },
      orElse: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final activeOrg = ref.watch(activeOrgProvider);
    final projectsAsync = ref.watch(projectListProvider);
    final permissions = ref.watch(permissionsProvider);

    return authState.maybeWhen(
      authenticated: (user) {
        if (user.memberships.isEmpty) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.business_outlined, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text('Welcome to Orivox ✨', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('You don\'t belong to any workspace yet.', style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Go to Workspaces'),
                      onPressed: () => context.go('/organizations'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (activeOrg == null || !user.memberships.any((m) => m.organizationId == activeOrg)) {
          final targetOrgId = user.memberships.first.organizationId;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(activeOrgProvider.notifier).setActiveOrg(targetOrgId);
          });
          // DO NOT return a spinner here. The activeOrgProvider will update and rebuild.
          // Let SaaSLayout render with the targetOrgId temporarily if needed.
        }

        return SaaSLayout(
          title: 'Dashboard',
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome back, ${user.name}', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue.withAlpha(25),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.blue.withAlpha(128)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.shield_outlined, size: 14, color: Colors.blue),
                                  const SizedBox(width: 6),
                                  Text(
                                    permissions.roleTitle.toUpperCase(),
                                    style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              user.email,
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                // Quick Actions
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    if (permissions.canCreateProject)
                      ElevatedButton.icon(
                        onPressed: () => context.push('/projects'),
                        icon: const Icon(Icons.add),
                        label: const Text('Create Project'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    OutlinedButton.icon(
                      onPressed: () => context.push('/chat'),
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('Ask AI Assistant'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => context.push('/knowledge'),
                      icon: const Icon(Icons.article_outlined),
                      label: const Text('Knowledge Base'),
                    ),
                  ],
                ),
                
                const SizedBox(height: 36),
                
                // Split View
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 800;

                    final projectsColumn = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Recent Projects', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        projectsAsync.when(
                          data: (projects) {
                            if (projects.isEmpty) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(color: Colors.grey.withAlpha(40)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(40.0),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        const Icon(Icons.folder_open_outlined, size: 56, color: Colors.grey),
                                        const SizedBox(height: 16),
                                        const Text('No projects found', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                        const SizedBox(height: 8),
                                        if (permissions.canCreateProject)
                                          const Text('Start by creating your first workspace project.', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center)
                                        else
                                          const Text('Contact your workspace administrator to assign you to a project.', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                                        if (permissions.canCreateProject) ...[
                                          const SizedBox(height: 20),
                                          ElevatedButton.icon(
                                            icon: const Icon(Icons.add),
                                            label: const Text('Create Project'),
                                            onPressed: () => context.push('/projects'),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: projects.take(5).length,
                              itemBuilder: (context, index) {
                                final p = projects[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(color: Colors.grey.withAlpha(40)),
                                  ),
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
                                    title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: Text(
                                      (p.description != null && p.description!.isNotEmpty) ? p.description! : 'No description provided',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: const Icon(Icons.chevron_right),
                                    onTap: () => context.push('/projects/${p.id}'),
                                  ),
                                );
                              },
                            );
                          },
                          loading: () => const SkeletonListLoader(count: 3, itemHeight: 70),
                          error: (e, st) => Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text('Unable to load projects: $e', style: const TextStyle(color: Colors.red)),
                            ),
                          ),
                        ),
                      ],
                    );

                    final summaryColumn = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Workspace Command Center', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.withAlpha(40)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.indigo.withAlpha(20),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.folder_outlined, color: Colors.indigo),
                                  ),
                                  title: const Text('Active Projects'),
                                  trailing: Text(
                                    projectsAsync.valueOrNull?.length.toString() ?? '0',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                  ),
                                ),
                                const Divider(height: 24),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.withAlpha(20),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.shield_outlined, color: Colors.amber),
                                  ),
                                  title: const Text('Your Role Scope'),
                                  trailing: Text(
                                    permissions.roleTitle,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                ),
                                const Divider(height: 24),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.secondary.withAlpha(20),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.check_circle_outline, color: AppColors.secondary),
                                  ),
                                  title: const Text('Workers & System Health'),
                                  subtitle: const Text('BullMQ • Atlas • Redis', style: TextStyle(fontSize: 12)),
                                  trailing: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.secondary.withAlpha(25),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text('OPERATIONAL', style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold, fontSize: 10)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );

                    if (isWide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: projectsColumn),
                          const SizedBox(width: 32),
                          Expanded(flex: 1, child: summaryColumn),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        summaryColumn,
                        const SizedBox(height: 32),
                        projectsColumn,
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
      orElse: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
