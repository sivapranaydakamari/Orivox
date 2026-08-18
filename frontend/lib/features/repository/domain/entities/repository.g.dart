// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RepositoryImpl _$$RepositoryImplFromJson(Map<String, dynamic> json) =>
    _$RepositoryImpl(
      id: json['_id'] as String,
      organizationId: json['organizationId'] as String,
      projectId: json['projectId'] as String,
      provider: json['provider'] as String,
      repositoryUrl: json['repositoryUrl'] as String,
      repositoryName: json['repositoryName'] as String,
      isActive: json['isActive'] as bool? ?? true,
      syncMode: json['syncMode'] as String? ?? 'AUTOMATIC',
      webhookStatus: json['webhookStatus'] as String? ?? 'NOT_CONFIGURED',
      syncStatus:
          $enumDecodeNullable(
            _$SyncStatusEnumMap,
            json['syncStatus'],
            unknownValue: SyncStatus.pending,
          ) ??
          SyncStatus.pending,
      syncLockedAt:
          json['syncLockedAt'] == null
              ? null
              : DateTime.parse(json['syncLockedAt'] as String),
      syncLockedBy: json['syncLockedBy'] as String?,
      lastSyncStartedAt:
          json['lastSyncStartedAt'] == null
              ? null
              : DateTime.parse(json['lastSyncStartedAt'] as String),
      lastSyncCompletedAt:
          json['lastSyncCompletedAt'] == null
              ? null
              : DateTime.parse(json['lastSyncCompletedAt'] as String),
      lastSuccessfulSync:
          json['lastSuccessfulSync'] == null
              ? null
              : DateTime.parse(json['lastSuccessfulSync'] as String),
      lastProcessedCommitSha: json['lastProcessedCommitSha'] as String?,
      filesAdded: (json['filesAdded'] as num?)?.toInt() ?? 0,
      filesModified: (json['filesModified'] as num?)?.toInt() ?? 0,
      filesDeleted: (json['filesDeleted'] as num?)?.toInt() ?? 0,
      prsProcessed: (json['prsProcessed'] as num?)?.toInt() ?? 0,
      syncError: json['syncError'] as String?,
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$RepositoryImplToJson(_$RepositoryImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'organizationId': instance.organizationId,
      'projectId': instance.projectId,
      'provider': instance.provider,
      'repositoryUrl': instance.repositoryUrl,
      'repositoryName': instance.repositoryName,
      'isActive': instance.isActive,
      'syncMode': instance.syncMode,
      'webhookStatus': instance.webhookStatus,
      'syncStatus': _$SyncStatusEnumMap[instance.syncStatus]!,
      'syncLockedAt': instance.syncLockedAt?.toIso8601String(),
      'syncLockedBy': instance.syncLockedBy,
      'lastSyncStartedAt': instance.lastSyncStartedAt?.toIso8601String(),
      'lastSyncCompletedAt': instance.lastSyncCompletedAt?.toIso8601String(),
      'lastSuccessfulSync': instance.lastSuccessfulSync?.toIso8601String(),
      'lastProcessedCommitSha': instance.lastProcessedCommitSha,
      'filesAdded': instance.filesAdded,
      'filesModified': instance.filesModified,
      'filesDeleted': instance.filesDeleted,
      'prsProcessed': instance.prsProcessed,
      'syncError': instance.syncError,
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$SyncStatusEnumMap = {
  SyncStatus.pending: 'PENDING',
  SyncStatus.syncing: 'SYNCING',
  SyncStatus.success: 'SUCCESS',
  SyncStatus.failed: 'FAILED',
};
