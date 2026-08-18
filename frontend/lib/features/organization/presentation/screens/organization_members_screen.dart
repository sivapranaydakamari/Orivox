import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/saas_layout.dart';
import '../../../../core/widgets/permission_tooltip.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/providers/permissions_provider.dart';
import '../providers/organization_members_provider.dart';
import 'package:dio/dio.dart';

class OrganizationMembersScreen extends ConsumerStatefulWidget {
  final String organizationId;

  const OrganizationMembersScreen({super.key, required this.organizationId});

  @override
  _OrganizationMembersScreenState createState() => _OrganizationMembersScreenState();
}

class _OrganizationMembersScreenState extends ConsumerState<OrganizationMembersScreen> {
  final _emailController = TextEditingController();
  String _selectedRole = 'EMPLOYEE';

  Future<void> _addMember() async {
    if (_emailController.text.isNotEmpty) {
      try {
        await ref.read(addOrganizationMemberProvider)(widget.organizationId, _emailController.text, _selectedRole);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Added member: ${_emailController.text}')),
          );
        }
      } on DioException catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.response?.data['message'] ?? e.message}')),
          );
        }
      }
      _emailController.clear();
      setState(() {
        _selectedRole = 'EMPLOYEE';
      });
    }
  }

  Future<void> _removeMember(String userId, String currentRole) async {
    final permissions = ref.read(permissionsProvider);
    if (!permissions.isOrgAdmin) return;
    
    try {
      await ref.read(removeOrganizationMemberProvider)(widget.organizationId, userId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Member removed successfully')),
        );
      }
    } on DioException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.response?.data['message'] ?? e.message}')),
        );
      }
    }
  }

  Future<void> _changeRole(String userId, String newRole) async {
    try {
      await ref.read(updateOrganizationMemberRoleProvider)(widget.organizationId, userId, newRole);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Role updated successfully')),
        );
      }
    } on DioException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.response?.data['message'] ?? e.message}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final permissions = ref.watch(permissionsProvider);
    final isOrgAdmin = permissions.isOrgAdmin;
    final colors = Theme.of(context).colorScheme;
    final membersAsync = ref.watch(organizationMembersProvider(widget.organizationId));

    return SaaSLayout(
      title: 'Organization Members',
      actions: [
        PermissionTooltip(
          hasPermission: isOrgAdmin,
          requiredRole: 'ORG_ADMIN',
          child: ElevatedButton.icon(
            onPressed: isOrgAdmin ? () => _showAddMemberDialog(context) : null,
            icon: const Icon(Icons.add),
            label: const Text('Add Member'),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
            ),
          ),
        )
      ],
      child: Card(
        color: colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Team Members',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              membersAsync.when(
                data: (members) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      final member = members[index];
                      return _buildMemberTile(member, isOrgAdmin, colors);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Text('Error loading members: $error', style: TextStyle(color: colors.error)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemberTile(OrgMember member, bool isOrgAdmin, ColorScheme colors) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: colors.primary.withAlpha(50),
        child: Text(member.name[0].toUpperCase(), style: TextStyle(color: colors.primary)),
      ),
      title: Text(member.name, style: TextStyle(color: colors.onSurface)),
      subtitle: Text(member.email, style: TextStyle(color: colors.onSurfaceVariant)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isOrgAdmin
              ? DropdownButton<String>(
                  value: member.orgRole,
                  dropdownColor: colors.surface,
                  underline: const SizedBox(),
                  style: TextStyle(
                    color: member.orgRole == 'ORG_ADMIN' ? colors.error : colors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  items: ['ORG_ADMIN', 'MANAGER', 'TEAM_LEAD', 'EMPLOYEE']
                      .map((role) => DropdownMenuItem(
                            value: role,
                            child: Text(role),
                          ))
                      .toList(),
                  onChanged: (newValue) {
                    if (newValue != null && newValue != member.orgRole) {
                      _changeRole(member.id, newValue);
                    }
                  },
                )
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: member.orgRole == 'ORG_ADMIN' ? colors.errorContainer : colors.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    member.orgRole,
                    style: TextStyle(
                      color: member.orgRole == 'ORG_ADMIN' ? colors.error : colors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
          const SizedBox(width: 8),
          PermissionTooltip(
            hasPermission: isOrgAdmin,
            requiredRole: 'ORG_ADMIN',
            child: IconButton(
              icon: Icon(Icons.remove_circle_outline, color: colors.error),
              onPressed: isOrgAdmin ? () => _removeMember(member.id, member.orgRole) : null,
            ),
          )
        ],
      ),
    );
  }

  void _showAddMemberDialog(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setStateDialog) {
        return AlertDialog(
          backgroundColor: colors.surface,
          title: Text('Add Existing Registered User', style: TextStyle(color: colors.onSurface)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _emailController,
                style: TextStyle(color: colors.onSurface),
                decoration: InputDecoration(
                  hintText: 'user@example.com',
                  hintStyle: TextStyle(color: colors.onSurfaceVariant),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: colors.outline)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colors.primary)),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                dropdownColor: colors.surface,
                style: TextStyle(color: colors.onSurface),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: colors.outline)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colors.primary)),
                ),
                items: ['ORG_ADMIN', 'MANAGER', 'TEAM_LEAD', 'EMPLOYEE']
                    .map((role) => DropdownMenuItem(value: role, child: Text(role)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setStateDialog(() => _selectedRole = value);
                  }
                },
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: colors.onSurfaceVariant)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _addMember();
              },
              style: ElevatedButton.styleFrom(backgroundColor: colors.primary),
              child: Text('Add Member', style: TextStyle(color: colors.onPrimary)),
            ),
          ],
        );
      }),
    );
  }
}
