import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/domain/entities/user.dart';
import 'active_org_provider.dart';

class Permissions {
  final bool isPlatformOwner;
  final bool isOrgAdmin;
  final bool isMember;
  final bool canCreateOrganization;
  final bool canDeleteOrganization;
  final bool canCreateProject;
  final bool canManageOrgMembers;
  final bool canAccessSettings;
  final String roleTitle;
  
  final List<ProjectRoleAccess> _projectRoles;

  const Permissions({
    this.isPlatformOwner = false,
    this.isOrgAdmin = false,
    this.isMember = false,
    this.canCreateOrganization = false,
    this.canDeleteOrganization = false,
    this.canCreateProject = false,
    this.canManageOrgMembers = false,
    this.canAccessSettings = false,
    this.roleTitle = 'Member',
    List<ProjectRoleAccess> projectRoles = const [],
  }) : _projectRoles = projectRoles;

  ProjectRole? _getProjectRole(String projectId) {
    if (isPlatformOwner || isOrgAdmin) return ProjectRole.projectAdmin; // Admins have implicit admin access
    try {
      return _projectRoles.firstWhere((p) => p.projectId == projectId).role;
    } catch (_) {
      return null;
    }
  }

  bool canEditProject(String projectId) {
    final role = _getProjectRole(projectId);
    return role == ProjectRole.projectAdmin || role == ProjectRole.projectManager;
  }

  bool canDeleteProject(String projectId) {
    final role = _getProjectRole(projectId);
    return role == ProjectRole.projectAdmin;
  }

  bool canCreateRepository(String projectId) {
    final role = _getProjectRole(projectId);
    return role == ProjectRole.projectAdmin || role == ProjectRole.projectManager;
  }

  bool canDeleteRepository(String projectId) {
    final role = _getProjectRole(projectId);
    return role == ProjectRole.projectAdmin || role == ProjectRole.projectManager;
  }

  bool canEditRepository(String projectId) {
    final role = _getProjectRole(projectId);
    return role == ProjectRole.projectAdmin || role == ProjectRole.projectManager;
  }

  bool canSyncRepository(String projectId) {
    final role = _getProjectRole(projectId);
    return role == ProjectRole.projectAdmin || role == ProjectRole.projectManager || role == ProjectRole.teamLead;
  }

  bool canManageProjectMembers(String projectId) {
    final role = _getProjectRole(projectId);
    return role == ProjectRole.projectAdmin;
  }

  bool canUploadDocument(String projectId) {
    final role = _getProjectRole(projectId);
    return role == ProjectRole.projectAdmin || role == ProjectRole.projectManager || role == ProjectRole.teamLead || role == ProjectRole.engineer;
  }
}

final permissionsProvider = Provider<Permissions>((ref) {
  final authState = ref.watch(authNotifierProvider);
  final activeOrgId = ref.watch(activeOrgProvider);

  return authState.maybeWhen(
    authenticated: (user) {
      final isPlatformOwner = user.globalRole == GlobalRole.platformOwner;
      final activeMembership = user.memberships.where((m) => m.organizationId == activeOrgId).firstOrNull;
      final isOrgAdmin = activeMembership?.orgRole == OrgRole.orgAdmin;

      final roleTitle = isPlatformOwner
          ? 'Platform Owner'
          : isOrgAdmin
              ? 'Organization Admin'
              : 'Workspace Member';

      return Permissions(
        isPlatformOwner: isPlatformOwner,
        isOrgAdmin: isOrgAdmin,
        isMember: !isOrgAdmin && !isPlatformOwner,
        canCreateOrganization: true,
        canDeleteOrganization: isPlatformOwner || isOrgAdmin,
        canCreateProject: isPlatformOwner || isOrgAdmin,
        canManageOrgMembers: isPlatformOwner || isOrgAdmin,
        canAccessSettings: isPlatformOwner || isOrgAdmin,
        roleTitle: roleTitle,
        projectRoles: activeMembership?.projectRoles ?? [],
      );
    },
    orElse: () => const Permissions(),
  );
});
