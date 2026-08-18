// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Repository _$RepositoryFromJson(Map<String, dynamic> json) {
  return _Repository.fromJson(json);
}

/// @nodoc
mixin _$Repository {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  String get projectId => throw _privateConstructorUsedError;
  String get provider => throw _privateConstructorUsedError;
  String get repositoryUrl => throw _privateConstructorUsedError;
  String get repositoryName => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String get syncMode => throw _privateConstructorUsedError;
  String get webhookStatus => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: SyncStatus.pending)
  SyncStatus get syncStatus => throw _privateConstructorUsedError;
  DateTime? get syncLockedAt => throw _privateConstructorUsedError;
  String? get syncLockedBy => throw _privateConstructorUsedError;
  DateTime? get lastSyncStartedAt => throw _privateConstructorUsedError;
  DateTime? get lastSyncCompletedAt => throw _privateConstructorUsedError;
  DateTime? get lastSuccessfulSync => throw _privateConstructorUsedError;
  String? get lastProcessedCommitSha => throw _privateConstructorUsedError;
  int get filesAdded => throw _privateConstructorUsedError;
  int get filesModified => throw _privateConstructorUsedError;
  int get filesDeleted => throw _privateConstructorUsedError;
  int get prsProcessed => throw _privateConstructorUsedError;
  String? get syncError => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  String? get updatedBy => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Repository to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Repository
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RepositoryCopyWith<Repository> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RepositoryCopyWith<$Res> {
  factory $RepositoryCopyWith(
    Repository value,
    $Res Function(Repository) then,
  ) = _$RepositoryCopyWithImpl<$Res, Repository>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String organizationId,
    String projectId,
    String provider,
    String repositoryUrl,
    String repositoryName,
    bool isActive,
    String syncMode,
    String webhookStatus,
    @JsonKey(unknownEnumValue: SyncStatus.pending) SyncStatus syncStatus,
    DateTime? syncLockedAt,
    String? syncLockedBy,
    DateTime? lastSyncStartedAt,
    DateTime? lastSyncCompletedAt,
    DateTime? lastSuccessfulSync,
    String? lastProcessedCommitSha,
    int filesAdded,
    int filesModified,
    int filesDeleted,
    int prsProcessed,
    String? syncError,
    String? createdBy,
    String? updatedBy,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$RepositoryCopyWithImpl<$Res, $Val extends Repository>
    implements $RepositoryCopyWith<$Res> {
  _$RepositoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Repository
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? projectId = null,
    Object? provider = null,
    Object? repositoryUrl = null,
    Object? repositoryName = null,
    Object? isActive = null,
    Object? syncMode = null,
    Object? webhookStatus = null,
    Object? syncStatus = null,
    Object? syncLockedAt = freezed,
    Object? syncLockedBy = freezed,
    Object? lastSyncStartedAt = freezed,
    Object? lastSyncCompletedAt = freezed,
    Object? lastSuccessfulSync = freezed,
    Object? lastProcessedCommitSha = freezed,
    Object? filesAdded = null,
    Object? filesModified = null,
    Object? filesDeleted = null,
    Object? prsProcessed = null,
    Object? syncError = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            organizationId:
                null == organizationId
                    ? _value.organizationId
                    : organizationId // ignore: cast_nullable_to_non_nullable
                        as String,
            projectId:
                null == projectId
                    ? _value.projectId
                    : projectId // ignore: cast_nullable_to_non_nullable
                        as String,
            provider:
                null == provider
                    ? _value.provider
                    : provider // ignore: cast_nullable_to_non_nullable
                        as String,
            repositoryUrl:
                null == repositoryUrl
                    ? _value.repositoryUrl
                    : repositoryUrl // ignore: cast_nullable_to_non_nullable
                        as String,
            repositoryName:
                null == repositoryName
                    ? _value.repositoryName
                    : repositoryName // ignore: cast_nullable_to_non_nullable
                        as String,
            isActive:
                null == isActive
                    ? _value.isActive
                    : isActive // ignore: cast_nullable_to_non_nullable
                        as bool,
            syncMode:
                null == syncMode
                    ? _value.syncMode
                    : syncMode // ignore: cast_nullable_to_non_nullable
                        as String,
            webhookStatus:
                null == webhookStatus
                    ? _value.webhookStatus
                    : webhookStatus // ignore: cast_nullable_to_non_nullable
                        as String,
            syncStatus:
                null == syncStatus
                    ? _value.syncStatus
                    : syncStatus // ignore: cast_nullable_to_non_nullable
                        as SyncStatus,
            syncLockedAt:
                freezed == syncLockedAt
                    ? _value.syncLockedAt
                    : syncLockedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            syncLockedBy:
                freezed == syncLockedBy
                    ? _value.syncLockedBy
                    : syncLockedBy // ignore: cast_nullable_to_non_nullable
                        as String?,
            lastSyncStartedAt:
                freezed == lastSyncStartedAt
                    ? _value.lastSyncStartedAt
                    : lastSyncStartedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            lastSyncCompletedAt:
                freezed == lastSyncCompletedAt
                    ? _value.lastSyncCompletedAt
                    : lastSyncCompletedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            lastSuccessfulSync:
                freezed == lastSuccessfulSync
                    ? _value.lastSuccessfulSync
                    : lastSuccessfulSync // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            lastProcessedCommitSha:
                freezed == lastProcessedCommitSha
                    ? _value.lastProcessedCommitSha
                    : lastProcessedCommitSha // ignore: cast_nullable_to_non_nullable
                        as String?,
            filesAdded:
                null == filesAdded
                    ? _value.filesAdded
                    : filesAdded // ignore: cast_nullable_to_non_nullable
                        as int,
            filesModified:
                null == filesModified
                    ? _value.filesModified
                    : filesModified // ignore: cast_nullable_to_non_nullable
                        as int,
            filesDeleted:
                null == filesDeleted
                    ? _value.filesDeleted
                    : filesDeleted // ignore: cast_nullable_to_non_nullable
                        as int,
            prsProcessed:
                null == prsProcessed
                    ? _value.prsProcessed
                    : prsProcessed // ignore: cast_nullable_to_non_nullable
                        as int,
            syncError:
                freezed == syncError
                    ? _value.syncError
                    : syncError // ignore: cast_nullable_to_non_nullable
                        as String?,
            createdBy:
                freezed == createdBy
                    ? _value.createdBy
                    : createdBy // ignore: cast_nullable_to_non_nullable
                        as String?,
            updatedBy:
                freezed == updatedBy
                    ? _value.updatedBy
                    : updatedBy // ignore: cast_nullable_to_non_nullable
                        as String?,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            updatedAt:
                null == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RepositoryImplCopyWith<$Res>
    implements $RepositoryCopyWith<$Res> {
  factory _$$RepositoryImplCopyWith(
    _$RepositoryImpl value,
    $Res Function(_$RepositoryImpl) then,
  ) = __$$RepositoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String organizationId,
    String projectId,
    String provider,
    String repositoryUrl,
    String repositoryName,
    bool isActive,
    String syncMode,
    String webhookStatus,
    @JsonKey(unknownEnumValue: SyncStatus.pending) SyncStatus syncStatus,
    DateTime? syncLockedAt,
    String? syncLockedBy,
    DateTime? lastSyncStartedAt,
    DateTime? lastSyncCompletedAt,
    DateTime? lastSuccessfulSync,
    String? lastProcessedCommitSha,
    int filesAdded,
    int filesModified,
    int filesDeleted,
    int prsProcessed,
    String? syncError,
    String? createdBy,
    String? updatedBy,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$RepositoryImplCopyWithImpl<$Res>
    extends _$RepositoryCopyWithImpl<$Res, _$RepositoryImpl>
    implements _$$RepositoryImplCopyWith<$Res> {
  __$$RepositoryImplCopyWithImpl(
    _$RepositoryImpl _value,
    $Res Function(_$RepositoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Repository
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? projectId = null,
    Object? provider = null,
    Object? repositoryUrl = null,
    Object? repositoryName = null,
    Object? isActive = null,
    Object? syncMode = null,
    Object? webhookStatus = null,
    Object? syncStatus = null,
    Object? syncLockedAt = freezed,
    Object? syncLockedBy = freezed,
    Object? lastSyncStartedAt = freezed,
    Object? lastSyncCompletedAt = freezed,
    Object? lastSuccessfulSync = freezed,
    Object? lastProcessedCommitSha = freezed,
    Object? filesAdded = null,
    Object? filesModified = null,
    Object? filesDeleted = null,
    Object? prsProcessed = null,
    Object? syncError = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$RepositoryImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        organizationId:
            null == organizationId
                ? _value.organizationId
                : organizationId // ignore: cast_nullable_to_non_nullable
                    as String,
        projectId:
            null == projectId
                ? _value.projectId
                : projectId // ignore: cast_nullable_to_non_nullable
                    as String,
        provider:
            null == provider
                ? _value.provider
                : provider // ignore: cast_nullable_to_non_nullable
                    as String,
        repositoryUrl:
            null == repositoryUrl
                ? _value.repositoryUrl
                : repositoryUrl // ignore: cast_nullable_to_non_nullable
                    as String,
        repositoryName:
            null == repositoryName
                ? _value.repositoryName
                : repositoryName // ignore: cast_nullable_to_non_nullable
                    as String,
        isActive:
            null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                    as bool,
        syncMode:
            null == syncMode
                ? _value.syncMode
                : syncMode // ignore: cast_nullable_to_non_nullable
                    as String,
        webhookStatus:
            null == webhookStatus
                ? _value.webhookStatus
                : webhookStatus // ignore: cast_nullable_to_non_nullable
                    as String,
        syncStatus:
            null == syncStatus
                ? _value.syncStatus
                : syncStatus // ignore: cast_nullable_to_non_nullable
                    as SyncStatus,
        syncLockedAt:
            freezed == syncLockedAt
                ? _value.syncLockedAt
                : syncLockedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        syncLockedBy:
            freezed == syncLockedBy
                ? _value.syncLockedBy
                : syncLockedBy // ignore: cast_nullable_to_non_nullable
                    as String?,
        lastSyncStartedAt:
            freezed == lastSyncStartedAt
                ? _value.lastSyncStartedAt
                : lastSyncStartedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        lastSyncCompletedAt:
            freezed == lastSyncCompletedAt
                ? _value.lastSyncCompletedAt
                : lastSyncCompletedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        lastSuccessfulSync:
            freezed == lastSuccessfulSync
                ? _value.lastSuccessfulSync
                : lastSuccessfulSync // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        lastProcessedCommitSha:
            freezed == lastProcessedCommitSha
                ? _value.lastProcessedCommitSha
                : lastProcessedCommitSha // ignore: cast_nullable_to_non_nullable
                    as String?,
        filesAdded:
            null == filesAdded
                ? _value.filesAdded
                : filesAdded // ignore: cast_nullable_to_non_nullable
                    as int,
        filesModified:
            null == filesModified
                ? _value.filesModified
                : filesModified // ignore: cast_nullable_to_non_nullable
                    as int,
        filesDeleted:
            null == filesDeleted
                ? _value.filesDeleted
                : filesDeleted // ignore: cast_nullable_to_non_nullable
                    as int,
        prsProcessed:
            null == prsProcessed
                ? _value.prsProcessed
                : prsProcessed // ignore: cast_nullable_to_non_nullable
                    as int,
        syncError:
            freezed == syncError
                ? _value.syncError
                : syncError // ignore: cast_nullable_to_non_nullable
                    as String?,
        createdBy:
            freezed == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                    as String?,
        updatedBy:
            freezed == updatedBy
                ? _value.updatedBy
                : updatedBy // ignore: cast_nullable_to_non_nullable
                    as String?,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        updatedAt:
            null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RepositoryImpl implements _Repository {
  const _$RepositoryImpl({
    @JsonKey(name: '_id') required this.id,
    required this.organizationId,
    required this.projectId,
    required this.provider,
    required this.repositoryUrl,
    required this.repositoryName,
    this.isActive = true,
    this.syncMode = 'AUTOMATIC',
    this.webhookStatus = 'NOT_CONFIGURED',
    @JsonKey(unknownEnumValue: SyncStatus.pending)
    this.syncStatus = SyncStatus.pending,
    this.syncLockedAt,
    this.syncLockedBy,
    this.lastSyncStartedAt,
    this.lastSyncCompletedAt,
    this.lastSuccessfulSync,
    this.lastProcessedCommitSha,
    this.filesAdded = 0,
    this.filesModified = 0,
    this.filesDeleted = 0,
    this.prsProcessed = 0,
    this.syncError,
    this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory _$RepositoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$RepositoryImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String organizationId;
  @override
  final String projectId;
  @override
  final String provider;
  @override
  final String repositoryUrl;
  @override
  final String repositoryName;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final String syncMode;
  @override
  @JsonKey()
  final String webhookStatus;
  @override
  @JsonKey(unknownEnumValue: SyncStatus.pending)
  final SyncStatus syncStatus;
  @override
  final DateTime? syncLockedAt;
  @override
  final String? syncLockedBy;
  @override
  final DateTime? lastSyncStartedAt;
  @override
  final DateTime? lastSyncCompletedAt;
  @override
  final DateTime? lastSuccessfulSync;
  @override
  final String? lastProcessedCommitSha;
  @override
  @JsonKey()
  final int filesAdded;
  @override
  @JsonKey()
  final int filesModified;
  @override
  @JsonKey()
  final int filesDeleted;
  @override
  @JsonKey()
  final int prsProcessed;
  @override
  final String? syncError;
  @override
  final String? createdBy;
  @override
  final String? updatedBy;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Repository(id: $id, organizationId: $organizationId, projectId: $projectId, provider: $provider, repositoryUrl: $repositoryUrl, repositoryName: $repositoryName, isActive: $isActive, syncMode: $syncMode, webhookStatus: $webhookStatus, syncStatus: $syncStatus, syncLockedAt: $syncLockedAt, syncLockedBy: $syncLockedBy, lastSyncStartedAt: $lastSyncStartedAt, lastSyncCompletedAt: $lastSyncCompletedAt, lastSuccessfulSync: $lastSuccessfulSync, lastProcessedCommitSha: $lastProcessedCommitSha, filesAdded: $filesAdded, filesModified: $filesModified, filesDeleted: $filesDeleted, prsProcessed: $prsProcessed, syncError: $syncError, createdBy: $createdBy, updatedBy: $updatedBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RepositoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.repositoryUrl, repositoryUrl) ||
                other.repositoryUrl == repositoryUrl) &&
            (identical(other.repositoryName, repositoryName) ||
                other.repositoryName == repositoryName) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.syncMode, syncMode) ||
                other.syncMode == syncMode) &&
            (identical(other.webhookStatus, webhookStatus) ||
                other.webhookStatus == webhookStatus) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            (identical(other.syncLockedAt, syncLockedAt) ||
                other.syncLockedAt == syncLockedAt) &&
            (identical(other.syncLockedBy, syncLockedBy) ||
                other.syncLockedBy == syncLockedBy) &&
            (identical(other.lastSyncStartedAt, lastSyncStartedAt) ||
                other.lastSyncStartedAt == lastSyncStartedAt) &&
            (identical(other.lastSyncCompletedAt, lastSyncCompletedAt) ||
                other.lastSyncCompletedAt == lastSyncCompletedAt) &&
            (identical(other.lastSuccessfulSync, lastSuccessfulSync) ||
                other.lastSuccessfulSync == lastSuccessfulSync) &&
            (identical(other.lastProcessedCommitSha, lastProcessedCommitSha) ||
                other.lastProcessedCommitSha == lastProcessedCommitSha) &&
            (identical(other.filesAdded, filesAdded) ||
                other.filesAdded == filesAdded) &&
            (identical(other.filesModified, filesModified) ||
                other.filesModified == filesModified) &&
            (identical(other.filesDeleted, filesDeleted) ||
                other.filesDeleted == filesDeleted) &&
            (identical(other.prsProcessed, prsProcessed) ||
                other.prsProcessed == prsProcessed) &&
            (identical(other.syncError, syncError) ||
                other.syncError == syncError) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    organizationId,
    projectId,
    provider,
    repositoryUrl,
    repositoryName,
    isActive,
    syncMode,
    webhookStatus,
    syncStatus,
    syncLockedAt,
    syncLockedBy,
    lastSyncStartedAt,
    lastSyncCompletedAt,
    lastSuccessfulSync,
    lastProcessedCommitSha,
    filesAdded,
    filesModified,
    filesDeleted,
    prsProcessed,
    syncError,
    createdBy,
    updatedBy,
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of Repository
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RepositoryImplCopyWith<_$RepositoryImpl> get copyWith =>
      __$$RepositoryImplCopyWithImpl<_$RepositoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RepositoryImplToJson(this);
  }
}

abstract class _Repository implements Repository {
  const factory _Repository({
    @JsonKey(name: '_id') required final String id,
    required final String organizationId,
    required final String projectId,
    required final String provider,
    required final String repositoryUrl,
    required final String repositoryName,
    final bool isActive,
    final String syncMode,
    final String webhookStatus,
    @JsonKey(unknownEnumValue: SyncStatus.pending) final SyncStatus syncStatus,
    final DateTime? syncLockedAt,
    final String? syncLockedBy,
    final DateTime? lastSyncStartedAt,
    final DateTime? lastSyncCompletedAt,
    final DateTime? lastSuccessfulSync,
    final String? lastProcessedCommitSha,
    final int filesAdded,
    final int filesModified,
    final int filesDeleted,
    final int prsProcessed,
    final String? syncError,
    final String? createdBy,
    final String? updatedBy,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$RepositoryImpl;

  factory _Repository.fromJson(Map<String, dynamic> json) =
      _$RepositoryImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get organizationId;
  @override
  String get projectId;
  @override
  String get provider;
  @override
  String get repositoryUrl;
  @override
  String get repositoryName;
  @override
  bool get isActive;
  @override
  String get syncMode;
  @override
  String get webhookStatus;
  @override
  @JsonKey(unknownEnumValue: SyncStatus.pending)
  SyncStatus get syncStatus;
  @override
  DateTime? get syncLockedAt;
  @override
  String? get syncLockedBy;
  @override
  DateTime? get lastSyncStartedAt;
  @override
  DateTime? get lastSyncCompletedAt;
  @override
  DateTime? get lastSuccessfulSync;
  @override
  String? get lastProcessedCommitSha;
  @override
  int get filesAdded;
  @override
  int get filesModified;
  @override
  int get filesDeleted;
  @override
  int get prsProcessed;
  @override
  String? get syncError;
  @override
  String? get createdBy;
  @override
  String? get updatedBy;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of Repository
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RepositoryImplCopyWith<_$RepositoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
