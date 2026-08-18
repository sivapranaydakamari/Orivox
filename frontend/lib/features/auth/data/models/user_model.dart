import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class ProjectRoleAccessModel with _$ProjectRoleAccessModel {
  const ProjectRoleAccessModel._();
  const factory ProjectRoleAccessModel({
    required String projectId,
    required String role,
  }) = _ProjectRoleAccessModel;

  factory ProjectRoleAccessModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectRoleAccessModelFromJson(json);

  ProjectRoleAccess toEntity() {
    return ProjectRoleAccess(
      projectId: projectId,
      role: ProjectRole.values.firstWhere(
        (e) => e.name.replaceAll('_', '').toUpperCase() == role.replaceAll('_', '').toUpperCase(),
        orElse: () => ProjectRole.viewer,
      ),
    );
  }
}

@freezed
class MembershipModel with _$MembershipModel {
  const MembershipModel._();
  const factory MembershipModel({
    required String organizationId,
    required String orgRole,
    @Default([]) List<ProjectRoleAccessModel> projectRoles,
  }) = _MembershipModel;

  factory MembershipModel.fromJson(Map<String, dynamic> json) =>
      _$MembershipModelFromJson(json);

  Membership toEntity() {
    return Membership(
      organizationId: organizationId,
      orgRole: OrgRole.values.firstWhere(
        (e) => e.name.replaceAll('_', '').toUpperCase() == orgRole.replaceAll('_', '').toUpperCase(),
        orElse: () => OrgRole.employee,
      ),
      projectRoles: projectRoles.map((e) => e.toEntity()).toList(),
    );
  }
}

@freezed
class UserModel with _$UserModel {
  const UserModel._();
  const factory UserModel({
    @JsonKey(name: '_id') required String id,
    required String name,
    required String email,
    @Default('USER') String globalRole,
    @Default([]) List<MembershipModel> memberships,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      globalRole: GlobalRole.values.firstWhere(
        (e) => e.name.replaceAll('_', '').toUpperCase() == globalRole.replaceAll('_', '').toUpperCase(),
        orElse: () => GlobalRole.user,
      ),
      memberships: memberships.map((e) => e.toEntity()).toList(),
    );
  }
}
