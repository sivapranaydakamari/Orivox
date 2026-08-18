import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/presentation/providers/auth_provider.dart';
import '../providers/active_org_provider.dart';
import '../../../features/organization/presentation/providers/organization_provider.dart';
import '../providers/permissions_provider.dart';
import '../widgets/buttons.dart';
import '../widgets/inputs.dart';
import '../theme/app_spacing.dart';

class OrganizationSwitcher extends ConsumerWidget {
  const OrganizationSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeOrgId = ref.watch(activeOrgProvider);
    final authState = ref.watch(authNotifierProvider);
    final permissions = ref.watch(permissionsProvider);

    final orgsAsync = ref.watch(organizationListProvider);
    final orgs = orgsAsync.valueOrNull ?? [];

    return authState.maybeWhen(
      authenticated: (user) {
        if (user.memberships.isEmpty) {
          return const Text('Orivox', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18));
        }

        final activeMembership = activeOrgId != null
            ? user.memberships.firstWhere((m) => m.organizationId == activeOrgId, orElse: () => user.memberships.first)
            : user.memberships.first;

        final displayName = orgs.where((o) => o.id == activeMembership.organizationId).firstOrNull?.name ?? 'Workspace';

        return PopupMenuButton<String>(
          offset: const Offset(0, kToolbarHeight),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          tooltip: 'Switch Workspace',
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  displayName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down, size: 20),
              ],
            ),
          ),
          itemBuilder: (context) {
            final List<PopupMenuEntry<String>> items = [];
            items.add(const PopupMenuItem(
              enabled: false,
              child: Text('Switch Workspace', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ));

            for (final membership in user.memberships) {
              final isCurrent = membership.organizationId == activeOrgId;
              final orgName = orgs.where((o) => o.id == membership.organizationId).firstOrNull?.name ?? 'Workspace';
              items.add(
                PopupMenuItem(
                  value: membership.organizationId,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        orgName,
                        style: TextStyle(fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal),
                      ),
                      if (isCurrent) const Icon(Icons.check, size: 16),
                    ],
                  ),
                ),
              );
            }

            if (permissions.canCreateOrganization) {
              items.add(const PopupMenuDivider());
              items.add(
                const PopupMenuItem(
                  value: 'create_new',
                  child: Row(
                    children: [
                      Icon(Icons.add, size: 18),
                      SizedBox(width: 8),
                      Text('Create Organization'),
                    ],
                  ),
                ),
              );
            }

            return items;
          },
          onSelected: (value) async {
            if (value == 'create_new') {
              _showCreateOrganizationDialog(context, ref);
            } else if (value != activeOrgId) {
              await ref.read(activeOrgProvider.notifier).setActiveOrg(value);
              if (context.mounted) {
                context.go('/dashboard');
              }
            }
          },
        );
      },
      orElse: () => const Text('Orivox', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
                          await ref.read(authNotifierProvider.notifier).checkAuthStatus();
                          await ref.read(activeOrgProvider.notifier).setActiveOrg(org.id);
                          if (context.mounted) {
                            Navigator.pop(context);
                            context.go('/dashboard');
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
