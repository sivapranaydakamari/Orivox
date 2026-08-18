// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SourceConfigurationDtoImpl _$$SourceConfigurationDtoImplFromJson(
  Map<String, dynamic> json,
) => _$SourceConfigurationDtoImpl(
  code: json['code'] as bool? ?? true,
  docs: json['docs'] as bool? ?? true,
  prs: json['prs'] as bool? ?? false,
);

Map<String, dynamic> _$$SourceConfigurationDtoImplToJson(
  _$SourceConfigurationDtoImpl instance,
) => <String, dynamic>{
  'code': instance.code,
  'docs': instance.docs,
  'prs': instance.prs,
};

_$CreateRepositoryDtoImpl _$$CreateRepositoryDtoImplFromJson(
  Map<String, dynamic> json,
) => _$CreateRepositoryDtoImpl(
  projectId: json['projectId'] as String,
  repositoryName: json['repositoryName'] as String,
  repositoryUrl: json['repositoryUrl'] as String?,
  provider: json['provider'] as String? ?? 'GITHUB',
  githubInstallationId: json['githubInstallationId'] as String?,
  githubRepositoryId: (json['githubRepositoryId'] as num?)?.toInt(),
  githubRepositoryFullName: json['githubRepositoryFullName'] as String?,
  sourceConfiguration:
      json['sourceConfiguration'] == null
          ? null
          : SourceConfigurationDto.fromJson(
            json['sourceConfiguration'] as Map<String, dynamic>,
          ),
);

Map<String, dynamic> _$$CreateRepositoryDtoImplToJson(
  _$CreateRepositoryDtoImpl instance,
) => <String, dynamic>{
  'projectId': instance.projectId,
  'repositoryName': instance.repositoryName,
  'repositoryUrl': instance.repositoryUrl,
  'provider': instance.provider,
  'githubInstallationId': instance.githubInstallationId,
  'githubRepositoryId': instance.githubRepositoryId,
  'githubRepositoryFullName': instance.githubRepositoryFullName,
  'sourceConfiguration': instance.sourceConfiguration,
};

_$UpdateRepositoryDtoImpl _$$UpdateRepositoryDtoImplFromJson(
  Map<String, dynamic> json,
) => _$UpdateRepositoryDtoImpl(isActive: json['isActive'] as bool?);

Map<String, dynamic> _$$UpdateRepositoryDtoImplToJson(
  _$UpdateRepositoryDtoImpl instance,
) => <String, dynamic>{'isActive': instance.isActive};
