enum GlobalRole { platformOwner, user }
enum OrgRole { orgAdmin, manager, teamLead, employee }
enum ProjectRole { projectAdmin, projectManager, teamLead, engineer, viewer }

class ProjectRoleAccess {
  final String projectId;
  final ProjectRole role;

  const ProjectRoleAccess({required this.projectId, required this.role});
}

class Membership {
  final String organizationId;
  final OrgRole orgRole;
  final List<ProjectRoleAccess> projectRoles;

  const Membership({
    required this.organizationId,
    required this.orgRole,
    required this.projectRoles,
  });
}

class User {
  final String id;
  final String name;
  final String email;
  final GlobalRole globalRole;
  final List<Membership> memberships;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.globalRole = GlobalRole.user,
    this.memberships = const [],
  });
}
