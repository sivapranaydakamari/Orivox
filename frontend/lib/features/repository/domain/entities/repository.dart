import 'package:freezed_annotation/freezed_annotation.dart';
import 'sync_status.dart';

part 'repository.freezed.dart';
part 'repository.g.dart';

@freezed
class Repository with _$Repository {
  const factory Repository({
    @JsonKey(name: '_id') required String id,
    required String organizationId,
    required String projectId,
    required String provider,
    required String repositoryUrl,
    required String repositoryName,
    @Default(true) bool isActive,
    @Default('AUTOMATIC') String syncMode,
    @Default('NOT_CONFIGURED') String webhookStatus,
    @JsonKey(unknownEnumValue: SyncStatus.pending) @Default(SyncStatus.pending) SyncStatus syncStatus,
    DateTime? syncLockedAt,
    String? syncLockedBy,
    DateTime? lastSyncStartedAt,
    DateTime? lastSyncCompletedAt,
    DateTime? lastSuccessfulSync,
    String? lastProcessedCommitSha,
    @Default(0) int filesAdded,
    @Default(0) int filesModified,
    @Default(0) int filesDeleted,
    @Default(0) int prsProcessed,
    String? syncError,
    String? createdBy,
    String? updatedBy,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Repository;

  factory Repository.fromJson(Map<String, dynamic> json) => _$RepositoryFromJson(json);
}
