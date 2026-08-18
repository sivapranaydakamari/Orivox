import 'package:flutter/material.dart';
import '../../../../core/network/api_error_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/organization_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/providers/permissions_provider.dart';
import '../../../../core/widgets/indicators.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/inputs.dart';
import '../../../../core/providers/active_org_provider.dart';

class OrganizationListScreen extends ConsumerWidget {
  const OrganizationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final organizationsState = ref.watch(organizationListProvider);
    final permissions = ref.watch(permissionsProvider);
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orivox'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authNotifierProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: organizationsState.when(
            data: (organizations) {
              if (organizations.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Welcome to Orivox ✨', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: AppSpacing.sm),
                    const Text('You don\'t belong to any workspace yet.', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    const SizedBox(height: AppSpacing.lg),
                    if (permissions.canCreateOrganization)
                      PrimaryButton(
                        text: 'Create Organization',
                        onPressed: () => _showCreateOrganizationDialog(context, ref),
                      ),
                  ],
                );
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Select a Workspace',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const Text(
                    'Choose an organization to continue.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: organizations.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final org = organizations[index];
                      // Find role from auth profile
                      String roleStr = 'Member';
                      authState.maybeWhen(
                        authenticated: (user) {
                          final mem = user.memberships.where((m) => m.organizationId == org.id).firstOrNull;
                          if (mem != null) {
                            roleStr = mem.orgRole.name.toUpperCase();
                          }
                        },
                        orElse: () {},
                      );

                      return InkWell(
                        onTap: () async {
                          await ref.read(activeOrgProvider.notifier).setActiveOrg(org.id);
                          if (context.mounted) {
                            context.go('/dashboard');
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.sm),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(org.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withAlpha(51),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(roleStr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  const Icon(Icons.chevron_right, color: Colors.grey),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  if (permissions.canCreateOrganization)
                    TextButton.icon(
                      onPressed: () => _showCreateOrganizationDialog(context, ref),
                      icon: const Icon(Icons.add),
                      label: const Text('Create New Workspace'),
                    ),
                ],
              );
            },
            loading: () => const LoadingWidget(message: 'Loading workspaces...'),
            error: (error, stack) => ErrorState(
              message: ApiErrorHandler.getMessage(error),
              onRetry: () => ref.refresh(organizationListProvider),
            ),
          ),
        ),
      ),
    );
  }

  void _showCreateOrganizationDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final slugController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        bool isLoading = false;
        
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Create Organization'),
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
                    labelText: 'Slug (e.g. my-org)',
                    controller: slugController,
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
                    if (nameController.text.isNotEmpty && slugController.text.isNotEmpty) {
                      setState(() => isLoading = true);
                      try {
                        final org = await ref.read(organizationListProvider.notifier).createOrganization(
                              nameController.text,
                              slugController.text,
                            );
                        if (org != null) {
                          // Refresh auth status and org list
                          await ref.read(authNotifierProvider.notifier).checkAuthStatus();
                          await ref.read(activeOrgProvider.notifier).setActiveOrg(org.id);
                          ref.invalidate(organizationListProvider);
                          if (context.mounted) {
                            Navigator.of(context, rootNavigator: true).pop(); // Close dialog safely
                            context.go('/dashboard'); // Navigate to dashboard
                          }
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
