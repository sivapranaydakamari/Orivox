import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../core/widgets/saas_layout.dart';
import '../../../../core/widgets/permission_tooltip.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/providers/permissions_provider.dart';
import '../../../../core/providers/active_org_provider.dart';
import '../providers/project_members_provider.dart';
import '../../../organization/presentation/providers/organization_members_provider.dart';

class ProjectMembersScreen extends ConsumerStatefulWidget {
  final String projectId;

  const ProjectMembersScreen({super.key, required this.projectId});

  @override
  _ProjectMembersScreenState createState() => _ProjectMembersScreenState();
}

class _ProjectMembersScreenState extends ConsumerState<ProjectMembersScreen> {
  String? _selectedMemberEmail;
  String _selectedRole = 'VIEWER';

  Future<void> _addMember() async {
    if (_selectedMemberEmail != null) {
      try {
        await ref.read(addProjectMemberProvider)(widget.projectId, _selectedMemberEmail!, _selectedRole);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Added member: $_selectedMemberEmail as $_selectedRole')),
          );
        }
      } on DioException catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.response?.data['message'] ?? e.message}')),
          );
        }
      }
      setState(() {
        _selectedRole = 'VIEWER';
        _selectedMemberEmail = null;
      });
    }
  }

  Future<void> _removeMember(String userId) async {
    final permissions = ref.read(permissionsProvider);
    if (!permissions.canManageProjectMembers(widget.projectId)) return;

    try {
      await ref.read(removeProjectMemberProvider)(widget.projectId, userId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project member removed successfully')),
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
      await ref.read(updateProjectMemberRoleProvider)(widget.projectId, userId, newRole);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project role updated successfully')),
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
    final hasProjectAdminAccess = permissions.canManageProjectMembers(widget.projectId);
    final colors = Theme.of(context).colorScheme;
    final membersAsync = ref.watch(projectMembersProvider(widget.projectId));

    return SaaSLayout(
      title: 'Project Members & Access',
      actions: [
        PermissionTooltip(
          hasPermission: hasProjectAdminAccess,
          requiredRole: 'PROJECT_ADMIN',
          child: ElevatedButton.icon(
            onPressed: hasProjectAdminAccess ? () => _showAddMemberDialog(context) : null,
            icon: const Icon(Icons.person_add),
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
                'Project Access',
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
                      return _buildMemberTile(member, hasProjectAdminAccess, colors);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Text('Error loading project members: $error', style: TextStyle(color: colors.error)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemberTile(ProjectMember member, bool isAdmin, ColorScheme colors) {
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
          isAdmin
              ? DropdownButton<String>(
                  value: member.projectRole,
                  dropdownColor: colors.surface,
                  underline: const SizedBox(),
                  style: TextStyle(
                    color: colors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  items: ['PROJECT_ADMIN', 'PROJECT_MANAGER', 'TEAM_LEAD', 'ENGINEER', 'VIEWER']
                      .map((role) => DropdownMenuItem(
                            value: role,
                            child: Text(role),
                          ))
                      .toList(),
                  onChanged: (newValue) {
                    if (newValue != null && newValue != member.projectRole) {
                      _changeRole(member.id, newValue);
                    }
                  },
                )
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    member.projectRole,
                    style: TextStyle(
                      color: colors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
          const SizedBox(width: 8),
          PermissionTooltip(
            hasPermission: isAdmin,
            requiredRole: 'PROJECT_ADMIN',
            child: IconButton(
              icon: Icon(Icons.remove_circle_outline, color: colors.error),
              onPressed: isAdmin ? () => _removeMember(member.id) : null,
            ),
          )
        ],
      ),
    );
  }

  void _showAddMemberDialog(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final orgId = ref.read(activeOrgProvider);
    if (orgId == null) return;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setStateDialog) {
        return AlertDialog(
          backgroundColor: colors.surface,
          title: Text('Add Member to Project', style: TextStyle(color: colors.onSurface)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer(
                builder: (context, ref, child) {
                  final orgMembersAsync = ref.watch(organizationMembersProvider(orgId));
                  return orgMembersAsync.when(
                    data: (members) {
                      return DropdownButtonFormField<String>(
                        value: _selectedMemberEmail,
                        dropdownColor: colors.surface,
                        hint: Text('Select Org Member', style: TextStyle(color: colors.onSurfaceVariant)),
                        style: TextStyle(color: colors.onSurface),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: colors.outline)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colors.primary)),
                        ),
                        items: members.map((m) => DropdownMenuItem(value: m.email, child: Text('${m.name} (${m.email})'))).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setStateDialog(() => _selectedMemberEmail = value);
                          }
                        },
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stack) => const Text('Failed to load org members'),
                  );
                }
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
                items: ['PROJECT_ADMIN', 'PROJECT_MANAGER', 'TEAM_LEAD', 'ENGINEER', 'VIEWER']
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
              child: Text('Add', style: TextStyle(color: colors.onPrimary)),
            ),
          ],
        );
      }),
    );
  }
}
