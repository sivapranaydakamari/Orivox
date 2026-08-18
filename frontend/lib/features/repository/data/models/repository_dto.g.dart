// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateRepositoryDtoImpl _$$CreateRepositoryDtoImplFromJson(
  Map<String, dynamic> json,
) => _$CreateRepositoryDtoImpl(
  projectId: json['projectId'] as String,
  repositoryUrl: json['repositoryUrl'] as String,
  repositoryName: json['repositoryName'] as String,
  provider: json['provider'] as String? ?? 'GITHUB',
);

Map<String, dynamic> _$$CreateRepositoryDtoImplToJson(
  _$CreateRepositoryDtoImpl instance,
) => <String, dynamic>{
  'projectId': instance.projectId,
  'repositoryUrl': instance.repositoryUrl,
  'repositoryName': instance.repositoryName,
  'provider': instance.provider,
};

_$UpdateRepositoryDtoImpl _$$UpdateRepositoryDtoImplFromJson(
  Map<String, dynamic> json,
) => _$UpdateRepositoryDtoImpl(isActive: json['isActive'] as bool?);

Map<String, dynamic> _$$UpdateRepositoryDtoImplToJson(
  _$UpdateRepositoryDtoImpl instance,
) => <String, dynamic>{'isActive': instance.isActive};
