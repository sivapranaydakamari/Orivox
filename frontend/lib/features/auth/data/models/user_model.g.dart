// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectRoleAccessModelImpl _$$ProjectRoleAccessModelImplFromJson(
  Map<String, dynamic> json,
) => _$ProjectRoleAccessModelImpl(
  projectId: json['projectId'] as String,
  role: json['role'] as String,
);

Map<String, dynamic> _$$ProjectRoleAccessModelImplToJson(
  _$ProjectRoleAccessModelImpl instance,
) => <String, dynamic>{'projectId': instance.projectId, 'role': instance.role};

_$MembershipModelImpl _$$MembershipModelImplFromJson(
  Map<String, dynamic> json,
) => _$MembershipModelImpl(
  organizationId: json['organizationId'] as String,
  orgRole: json['orgRole'] as String,
  projectRoles:
      (json['projectRoles'] as List<dynamic>?)
          ?.map(
            (e) => ProjectRoleAccessModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$$MembershipModelImplToJson(
  _$MembershipModelImpl instance,
) => <String, dynamic>{
  'organizationId': instance.organizationId,
  'orgRole': instance.orgRole,
  'projectRoles': instance.projectRoles,
};

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      globalRole: json['globalRole'] as String? ?? 'USER',
      memberships:
          (json['memberships'] as List<dynamic>?)
              ?.map((e) => MembershipModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'globalRole': instance.globalRole,
      'memberships': instance.memberships,
    };
